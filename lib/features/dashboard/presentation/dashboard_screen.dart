/// Dashboard screen example using Riverpod and clean architecture.
import 'package:flutter/material.dart';
import 'package:flutter_attendance/services/dashboard_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/dependency_injection.dart';

final dashboardProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  // Replace with actual dashboard data fetching logic
  final result = await DashboardService().fetchDashboardData();
  return result;
});

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: dashboardAsync.when(
        data: (data) => ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Text('Welcome to the Dashboard!'),
            const SizedBox(height: 24),
            Text('Attendance Summary:', style: Theme.of(context).textTheme.titleMedium),
            Text('Present: ${data['present'] ?? 0}'),
            Text('Absent: ${data['absent'] ?? 0}'),
            // Add more dashboard widgets as needed
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
      ),
    );
  }
}