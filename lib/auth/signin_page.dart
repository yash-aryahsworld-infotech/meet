import 'package:flutter/material.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/auth_toggle.dart';
import 'forgot_password_page.dart'; // ⬅️ import the new page

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA), // light gray background
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

              // 🔹 Inside the white container
              child: Column(
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

                  // 🔹 Toggle Tabs
                  const AuthToggle(isSignInPage: true),
                  const SizedBox(height: 30),

                  // 🔹 Email Input
                  CustomInputField(
                    labelText: "Enter your email",
                    icon: Icons.email_outlined,
                    controller: emailController,
                    inputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),

                  // 🔹 Password Input
                  CustomInputField(
                    labelText: "Enter your password",
                    icon: Icons.lock_outline,
                    controller: passwordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 30),

                  // 🔹 Sign In Button
                  CustomButton(
                    text: "Sign In",
                    onPressed: () {
                      // TODO: Add authentication logic
                    },
                  ),

                  const SizedBox(height: 20),

                  // 🔹 “Forgot Password?”
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.blueAccent),
                    ),
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
