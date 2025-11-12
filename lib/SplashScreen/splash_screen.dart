import 'dart:async';
import 'package:flutter/material.dart';
import '../auth/signin_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to SignInPage after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // You can change background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Image.asset(
              'assets/logo/logo.png', // make sure this path is correct in pubspec.yaml
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),

            // App Name
            const Text(
              "HealthCare+",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 10),

            // Optional loading indicator
            const CircularProgressIndicator(
              color: Colors.blueAccent,
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}
