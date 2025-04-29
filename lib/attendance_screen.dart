import 'package:flutter/material.dart';
import 'package:flutter_attendance/services/attendance_service.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String _selectedStatus = 'present';
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();
  String? _message;

  void _markAttendance() async {
    final userId = _userIdController.text.trim();
    if (userId.isEmpty) {
      setState(() {
        _message = 'Please enter or scan a user ID.';
      });
      return;
    }
    AttendanceService service = AttendanceService();
    bool success = await service.markAttendance(
      userId,
      '',
      ''
    );
    setState(() {
      if (success) {
        _message = 'Attendance marked for user $userId as $_selectedStatus.';
        _userIdController.clear();
        _remarksController.clear();
      } else {
        _message = 'Failed to mark attendance. Please try again.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _userIdController,
              decoration: const InputDecoration(
                labelText: 'User ID',
                hintText: 'Enter or scan user ID',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              items: const [
                DropdownMenuItem(value: 'present', child: Text('Present')),
                DropdownMenuItem(value: 'absent', child: Text('Absent')),
                DropdownMenuItem(value: 'late', child: Text('Late')),
                DropdownMenuItem(value: 'excused', child: Text('Excused')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedStatus = value;
                  });
                }
              },
              decoration: const InputDecoration(labelText: 'Status'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _remarksController,
              decoration: const InputDecoration(
                labelText: 'Remarks (optional)',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _markAttendance,
              child: const Text('Mark Attendance'),
            ),
            if (_message != null) ...[
              const SizedBox(height: 16),
              Text(_message!, style: const TextStyle(color: Colors.green)),
            ],
          ],
        ),
      ),
    );
  }
}