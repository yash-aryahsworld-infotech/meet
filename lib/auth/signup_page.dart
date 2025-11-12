import 'package:flutter/material.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/custom_button.dart';

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
  bool isPatient = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: widget.key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: CustomInputField(
                labelText: "First Name",
                icon: Icons.person_outline,
                controller: firstNameController,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CustomInputField(
                labelText: "Last Name",
                icon: Icons.person_outline,
                controller: lastNameController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        CustomInputField(
          labelText: "Email",
          icon: Icons.email_outlined,
          controller: emailController,
          inputType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),
        CustomInputField(
          labelText: "Phone Number",
          icon: Icons.phone_outlined,
          controller: phoneController,
          inputType: TextInputType.phone,
        ),
        const SizedBox(height: 20),

        // 🔹 Role Toggle
        const Text("I am a", style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
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
                alignment:
                isPatient ? Alignment.centerLeft : Alignment.centerRight,
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
                      onTap: () => setState(() => isPatient = true),
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            color: isPatient
                                ? Colors.black
                                : Colors.grey.shade600,
                            fontWeight: isPatient
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                          child: const Text("Patient"),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isPatient = false),
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            color: !isPatient
                                ? Colors.black
                                : Colors.grey.shade600,
                            fontWeight: !isPatient
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                          child: const Text("Healthcare Provider"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        CustomInputField(
          labelText: "Create a password",
          icon: Icons.lock_outline,
          controller: passwordController,
          obscureText: true,
        ),
        const SizedBox(height: 20),
        CustomInputField(
          labelText: "Confirm password",
          icon: Icons.lock_outline,
          controller: confirmPasswordController,
          obscureText: true,
        ),
        const SizedBox(height: 30),
        CustomButton(
          text: "Create Account",
          onPressed: () {
            // TODO: handle sign up
          },
        ),
      ],
    );
  }
}
