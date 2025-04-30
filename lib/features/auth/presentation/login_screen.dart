import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/dependency_injection.dart';
import '../../../widgets/custom_button.dart';

final loginProvider = StateNotifierProvider<LoginController, AsyncValue<void>>(
  (ref) => LoginController(ref),
);

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginProvider);
    final controller = ref.read(loginProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 24),
            CustomButton(
              label: 'Login',
              isLoading: loginState.isLoading,
              onPressed: () {
                controller.login(
                  emailController.text.trim(),
                  passwordController.text,
                  context,
                );
              },
            ),
            if (loginState.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  loginState.error.toString(),
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class LoginController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  LoginController(this.ref) : super(const AsyncData(null));

  Future<void> login(String email, String password, BuildContext context) async {
    state = const AsyncLoading();
    try {
      final authService = ref.read(authServiceProvider);
      final result = await authService.login(email, password,'') as Map<String, dynamic>;

      if (result['success'] == true) {
        state = const AsyncData(null);
        Navigator.of(context).pushReplacementNamed('/dashboard');
      } else {
        state = AsyncError(result['error'] ?? 'Login failed', StackTrace.current);
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
