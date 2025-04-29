import 'package:flutter/material.dart';

class QRGenerateScreen extends StatelessWidget {
  final String userId;
  const QRGenerateScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Code Generator')),
      body: Center(child: Text('QR Generate Screen Placeholder for user: $userId')),
    );
  }
}