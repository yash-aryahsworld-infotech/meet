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
      crossAxisAlignment: CrossAxisAlignment.start,
      key: key,
      children: [
        // 🔹 Email Label
        const Text(
          "Email Address",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        CustomInputField(
          labelText: "Enter your email",
          icon: Icons.email_outlined,
          controller: emailController,
          inputType: TextInputType.emailAddress,
        ),

        const SizedBox(height: 20),

        // 🔹 Password Label
        const Text(
          "Password",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
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
            // TODO: handle sign-in
          },
        ),

        const SizedBox(height: 15),

        // 🔹 Forgot Password Link
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
              );
            },
            child: const Text(
              "Forgot Password?",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
