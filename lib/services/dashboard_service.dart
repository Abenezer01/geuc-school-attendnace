import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DashboardService {
  final String apiUrl = '${dotenv.env['API_URL'] ?? 'https://default-url.com'}/dashboard';

  Future<Map<String, dynamic>> fetchDashboardData() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/data'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data};
      } else {
        var errorMsg = '';
        try {
          final decoded = jsonDecode(response.body);
          errorMsg = decoded['message'] ?? decoded['error'] ?? response.body;
        } catch (e) {
          errorMsg = response.body;
        }
        return {'success': false, 'error': errorMsg};
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
}