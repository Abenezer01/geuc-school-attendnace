import 'package:flutter/material.dart';
import 'package:flutter_attendance/models/session.dart';
import 'package:flutter_attendance/models.dart';
import 'package:flutter_attendance/services/attendance_service.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
class QRScanScreen extends StatefulWidget {
  final Session? session;
  const QRScanScreen({Key? key, this.session}) : super(key: key);

  @override
  State<QRScanScreen> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  String? _scanResult;
  String? _message;
  bool _attendanceMarked = false;
  bool _toastShown = false;
  dynamic modelInstance;

  void _onDetect(BarcodeCapture capture) async {
    if (_attendanceMarked || _toastShown) return;
    final barcode = capture.barcodes.first;
    final String? rawValue = barcode.rawValue;
    _toastShown = true;
    Fluttertoast.showToast(
      msg: "QR code detected: $rawValue",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0
    );
    if (rawValue != null && rawValue.isNotEmpty) {
      dynamic decoded;
      String? userId;
      String userType = 'student';
      print('decoded $rawValue');
      
      try {
        decoded = rawValue;
        
        // Try to decode as JSON
        decoded = jsonDecode(rawValue);
        print('userType decoded $decoded');
        if (decoded is Map<String, dynamic>) {

          if (decoded.containsKey('type')) {
            userType = decoded['type'];
          } else if (decoded.containsKey('class_id')) {
            userType = 'student';
          } else if (decoded.containsKey('bio') || decoded.containsKey('expertise')) {
            userType = 'teacher';
          } else if (decoded.containsKey('memberId') && decoded.containsKey('classId')) {
            userType = 'student';
          }
          userId = decoded['id'] ?? decoded['userId'] ?? decoded['member_id'];
          // Instantiate model
          if (userType == 'teacher') {
            modelInstance = Teacher(
              id: (decoded['id'] ?? '') ?? '',
              memberId: (decoded['memberId'] ?? '') ?? '',
              bio: (decoded['bio'] ?? '') ?? '',
              member: Member(
                id: (decoded['member']?['id'] ?? '') ?? '',
                name: (decoded['member']?['name'] ?? '') ?? '',
                email: (decoded['member']?['email'] ?? '') ?? '',
              ),
            );
          } else if (userType == 'student') {
            modelInstance = Student(
              id: (decoded['id'] ?? '') ?? '',
              memberId: (decoded['member_id'] ?? '') ?? '',
              member: Member(
                id: (decoded['member']?['id'] ?? '') ?? '',
                name: (decoded['member']?['name'] ?? '') ?? '',
                email: (decoded['member']?['email'] ?? '') ?? '',
              ),
              classId: (decoded['classId'] ?? decoded['class_id'] ?? '') ?? '',
            );
          }
        } else {
        }
      } catch (e) {
        // Not JSON, treat as plain userId only if it looks like an ID, otherwise show error
        if (rawValue.trim().startsWith('{') && !rawValue.trim().endsWith('}')) {
          setState(() {
            _message = 'Invalid or incomplete QR code data. Please try again.';
          });
          return;
        }
        userId = rawValue;
      }
      if (userId != null && userId.isNotEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirm Attendance${userType =='teacher'? ' for ${modelInstance?.member.name}': ''}'),
              content: Text('Do you want to mark attendance for $userType ' + (modelInstance?.member?.name ?? '')),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Confirm'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    AttendanceService service = AttendanceService();
                    var result = await service.markAttendance(
                      userId.toString(),
                      userType,
                      widget.session?.id?? '',
                    );
                    print('result $result');
                    setState(() {
                      _scanResult = userId;
                      if (result['success'] == true) {
                        _message = 'Attendance marked for $userType $userId.';
                      } else {
                        String errorMsg = result['error'] ?? 'Failed to mark attendance. Please try again.';
                        _message = errorMsg;
                        Fluttertoast.showToast(
                          msg: errorMsg,
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                        );
                      }
                      _attendanceMarked = true;
                    });
                  },
                ),
              ],
            );
          },
        );
      } else {
        setState(() {
          _message = 'Invalid QR code.';
        });
      }
    } else {
      setState(() {
        _message = 'Invalid QR code.';
      });
    }
    if (_attendanceMarked) {
      _toastShown = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Code Scan')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: MobileScanner(
                onDetect: _onDetect,
              ),
            ),
          ),
          if (_message != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _message!,
                style: TextStyle(
                  fontSize: 18,
                  color: _attendanceMarked ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (_attendanceMarked)
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _attendanceMarked = false;
                  _toastShown = false;
                  _message = null;
                  _scanResult = null;
                });
              },
              child: const Text('Scan Another'),
            ),
        ],
      ),
    );
  }
}