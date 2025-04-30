/// Sets up dependency injection for the app using Riverpod.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../services/attendance_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final attendanceServiceProvider = Provider<AttendanceService>((ref) => AttendanceService());