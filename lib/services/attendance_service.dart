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

  Future<bool> markAttendance(String userId,String userType,String sessionId) async {
    final body = {
      'user_id': userId,
      'user_type': userType,
      'session_id': sessionId,
    };
    print('apiSubmitbody : '+body.toString());
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/attendance/submit-attendance'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final res = ResponseModel.fromJson(jsonDecode(response.body));
        if (res.errors != null) {
          return false;
        }
        return true;
      } else {
             var someValue= jsonEncode(response.body);
              print('apiSubmitError : $someValue');

        return false;
      }
    } catch (e) {
      print('apiSubmitError : $e');
      return false;
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
    }
    return null;
  }

}