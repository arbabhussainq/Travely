import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travely/src/services/auth_service.dart';
import 'package:travely/src/ui/pages/home_shell.dart';
import 'signup_page.dart';
import '../../app/theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    checkUser();
  }

  Future<void> checkUser() async {
    await Future.delayed(const Duration(seconds: 2));
    final authService = context.read<AuthService>();
    final user = authService.user;
    if (mounted) {
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeShell()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SignUpPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: TravelyTheme.gradient),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Travely',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Your simple travel mate',
                  style: TextStyle(color: Colors.white70, fontSize: 25),
                ),
                SizedBox(height: 28),
                CircularProgressIndicator(color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
