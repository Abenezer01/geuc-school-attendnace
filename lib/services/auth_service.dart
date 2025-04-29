import 'package:flutter_attendance/models/user.dart';

class AuthService {
  User? _currentUser;

  User? get currentUser => _currentUser;

  bool login(String id, String name, String role) {
    // In a real app, add authentication logic here
    _currentUser = User(id: id, name: name, role: role);
    return true;
  }

  void logout() {
    _currentUser = null;
  }
}