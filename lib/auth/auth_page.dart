import 'package:flutter/material.dart';
import 'signin_page.dart';
import 'signup_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isSignIn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Welcome to HealthCare Platform",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Access comprehensive healthcare services\nand manage your health journey",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 30),

                  // 🔹 Sign In / Sign Up Toggle — styled like Patient/Provider
                  Container(
                    height: 45,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F1F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        AnimatedAlign(
                          alignment: isSignIn
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOutCubic,
                          child: Container(
                            width: 150,
                            height: 37,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => isSignIn = true),
                                child: Center(
                                  child: AnimatedDefaultTextStyle(
                                    duration:
                                    const Duration(milliseconds: 200),
                                    style: TextStyle(
                                      color: isSignIn
                                          ? Colors.black
                                          : Colors.grey.shade600,
                                      fontWeight: isSignIn
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    ),
                                    child: const Text("Sign In"),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => isSignIn = false),
                                child: Center(
                                  child: AnimatedDefaultTextStyle(
                                    duration:
                                    const Duration(milliseconds: 200),
                                    style: TextStyle(
                                      color: !isSignIn
                                          ? Colors.black
                                          : Colors.grey.shade600,
                                      fontWeight: !isSignIn
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    ),
                                    child: const Text("Sign Up"),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // 🔹 Smooth transition between Sign In and Sign Up forms
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (child, animation) =>
                        FadeTransition(opacity: animation, child: child),
                    child: isSignIn
                        ? const SignInForm(key: ValueKey('signIn'))
                        : const SignUpForm(key: ValueKey('signUp')),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
