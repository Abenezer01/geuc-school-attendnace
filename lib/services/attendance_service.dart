import 'package:flutter_attendance/models/attendance_record.dart';
import 'package:flutter_attendance/models/response_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_attendance/models/session.dart';

class AttendanceService {
  final List<AttendanceRecord> _records = [];

  List<AttendanceRecord> get records => List.unmodifiable(_records);

  final String apiUrl = '${dotenv.env['API_URL'] ?? 'https://default-url.com'}/auth/school-module';

  Future<Map<String, dynamic>> markAttendance(String userId,String userType,String sessionId) async {
    final body = {
      'user_id': userId,
      'user_type': userType,
      'session_id': sessionId,
    };
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/attendance/submit-attendance'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final res = ResponseModel.fromJson(jsonDecode(response.body));
        if (res.errors != null && res.errors is List && res.errors.length > 0) {
          return {'success': false, 'error': res.errors.toString()};
        }
        return {'success': true};
      } else {
        var errorMsg = '';
        try {
          final decoded = jsonDecode(response.body);
          errorMsg = decoded['message'] ?? decoded['error'] ?? response.body;
        } catch (e) {
          errorMsg = response.body;
        }
        // Avoid using print statements
        // Use interpolation to compose strings and values
        return {'success': false, 'error': errorMsg};
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  List<AttendanceRecord> getUserAttendance(String userId) {
    return _records.where((r) => r.userId == userId).toList();
  }

  Future<Session?> fetchLatestSession() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/latest-sessions'));
      if (response.statusCode == 200) {
        final res = ResponseModel.fromJson(jsonDecode(response.body));
      
        final data = res.payload ?? res;
        var session= Session.fromJson(data[0]);
        print('apierrors'+jsonEncode(session));
        return session;
      }
    } catch (e) {
      // Optionally log or handle the error
    }
    return null;
  }

}