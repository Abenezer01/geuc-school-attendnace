import 'package:flutter/material.dart';
import 'package:flutter_attendance/models/session.dart';
import 'package:flutter_attendance/services/attendance_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'login_screen.dart';
import 'attendance_screen.dart';
import 'qr_scan_screen.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Session _latestSession;
  bool _loadingSession = true;
  String? _sessionError;

  @override
  void initState() {
    super.initState();
    _fetchLatestSession();
  }

  Future<void> _fetchLatestSession() async {
    setState(() {
      _loadingSession = true;
      _sessionError = null;
    });
    try {
      final service = AttendanceService();
      final session = await service.fetchLatestSession();
      setState(() {
        _latestSession = session as Session;
        _loadingSession = false;
      });
    } catch (e) {
      print('apierror $e');
      setState(() {
        _sessionError = 'Failed to fetch latest session.';
        _loadingSession = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Modern Header with Branding
              Container(
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.qr_code_2, color: Colors.white, size: 40),
                    const SizedBox(width: 16),
                    Text(
                      'GEUC Attendance',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              // Hero Section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome!',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Manage your attendance sessions, mark attendance, and scan QR codes with ease.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onBackground.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              // Session Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _loadingSession
                    ? const Center(child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: CircularProgressIndicator(),
                      ))
                    : _sessionError != null
                        ? Card(
                            color: Colors.red.shade50,
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Icon(Icons.error_outline, color: Colors.red.shade400),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(_sessionError!, style: const TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : _latestSession != null
                            ? Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.event_note, color: theme.colorScheme.primary),
                                          const SizedBox(width: 8),
                                          Text('Latest Session', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Text('Title: ${_latestSession.title}', style: theme.textTheme.bodyLarge),
                                      Text('Date: ${_latestSession.date is DateTime ? (_latestSession.date as DateTime).toLocal().toString().split(' ')[0] : _latestSession.date}', style: theme.textTheme.bodyMedium),
                                      Text('Start: ${_latestSession.startTime}', style: theme.textTheme.bodyMedium),
                                      Text('End: ${_latestSession.endTime}', style: theme.textTheme.bodyMedium),
                                      if (_latestSession.notes != null && _latestSession.notes.toString().isNotEmpty)
                                        Text('Notes: ${_latestSession.notes}', style: theme.textTheme.bodyMedium),
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
              ),
              const SizedBox(height: 32),
              // Navigation Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _HomeNavCard(
                      icon: Icons.login,
                      label: 'Login',
                      color: theme.colorScheme.primary,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                    ),
                    _HomeNavCard(
                      icon: Icons.check_circle_outline,
                      label: 'Mark Attendance',
                      color: theme.colorScheme.secondary,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AttendanceScreen()),
                        );
                      },
                    ),
                    _HomeNavCard(
                      icon: Icons.qr_code_scanner,
                      label: 'Scan QR',
                      color: theme.colorScheme.tertiary ?? Colors.deepPurple,
                      onTap: () {
                        Navigator.push(
                          context,
                             MaterialPageRoute(builder: (context) => QRScanScreen(session: _latestSession)),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeNavCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _HomeNavCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: color.withOpacity(0.12),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 36),
                const SizedBox(height: 10),
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
