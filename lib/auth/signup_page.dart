import 'package:flutter/material.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_toggle_switch.dart'; // ✅ import reusable toggle

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  int selectedRole = 0; // 0 = Patient, 1 = Healthcare Provider

  @override
  Widget build(BuildContext context) {
    return Column(
      key: widget.key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 Name Fields (Grouped)
        Row(
          children: [
            // 🧍‍♂️ First Name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "First Name",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  CustomInputField(
                    labelText: "Enter your first name",
                    icon: Icons.person_outline,
                    controller: firstNameController,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // 🧍‍♀️ Last Name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Last Name",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  CustomInputField(
                    labelText: "Enter your last name",
                    icon: Icons.person_outline,
                    controller: lastNameController,
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // 🔹 Email
        const Text(
          "Email Address",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        const SizedBox(height: 6),
        CustomInputField(
          labelText: "Enter your email",
          icon: Icons.email_outlined,
          controller: emailController,
          inputType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),

        // 🔹 Phone
        const Text(
          "Phone Number",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        const SizedBox(height: 6),
        CustomInputField(
          labelText: "Enter your phone number",
          icon: Icons.phone_outlined,
          controller: phoneController,
          inputType: TextInputType.phone,
        ),
        const SizedBox(height: 20),

        // 🔹 Role Toggle (Reusable)
        const Text(
          "I am a",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        CustomToggleSwitch(
          options: const ["Patient", "Healthcare Provider"],
          selectedIndex: selectedRole,
          onSelected: (index) => setState(() => selectedRole = index),
        ),
        const SizedBox(height: 20),

        // 🔹 Password
        const Text(
          "Password",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        const SizedBox(height: 6),
        CustomInputField(
          labelText: "Create a password",
          icon: Icons.lock_outline,
          controller: passwordController,
          obscureText: true,
        ),
        const SizedBox(height: 20),

        // 🔹 Confirm Password
        const Text(
          "Confirm Password",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        const SizedBox(height: 6),
        CustomInputField(
          labelText: "Confirm your password",
          icon: Icons.lock_outline,
          controller: confirmPasswordController,
          obscureText: true,
        ),
        const SizedBox(height: 30),

        // 🔹 Submit Button
        CustomButton(
          text: "Create Account",
          onPressed: () {
            debugPrint(
              'Selected role: ${selectedRole == 0 ? "Patient" : "Healthcare Provider"}',
            );
          },
        ),
      ],
    );
  }
}
