

import 'package:flutter/material.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/custom_button.dart';
import './forgot_password_page.dart';
class SignInForm extends StatelessWidget {
  const SignInForm({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Column(
      key: key,
      children: [
        CustomInputField(
          labelText: "Enter your email",
          icon: Icons.email_outlined,
          controller: emailController,
          inputType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),
        CustomInputField(
          labelText: "Enter your password",
          icon: Icons.lock_outline,
          controller: passwordController,
          obscureText: true,
        ),
        const SizedBox(height: 30),
        CustomButton(
          text: "Sign In",
          onPressed: () {
            // TODO: handle sign-in
          },
        ),
        const SizedBox(height: 15),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
            );
          },
          child: const Text(
            "Forgot Password?",
            style: TextStyle(color: Colors.blueAccent),
          ),
        ),
      ],
    );
  }
}
