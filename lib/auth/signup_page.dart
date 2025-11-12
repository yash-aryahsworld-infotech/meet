import 'package:flutter/material.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/auth_toggle.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isPatient = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA), // Light background
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
                    blurRadius: 10,
                    spreadRadius: 3,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),

              // 🔹 MAIN SIGN-UP BODY
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Welcome to HealthCare Platform",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      "Access comprehensive healthcare services\nand manage your health journey",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // ✅ Toggle component for Sign In / Sign Up
                  const Center(child: AuthToggle(isSignInPage: false)),
                  const SizedBox(height: 30),

                  // 🔹 Name Fields
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "First Name",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 6),
                            CustomInputField(
                              labelText: "Enter first name",
                              icon: Icons.person_outline,
                              controller: firstNameController,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Last Name",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 6),
                            CustomInputField(
                              labelText: "Enter last name",
                              icon: Icons.person_outline,
                              controller: lastNameController,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 🔹 Email Field
                  const Text(
                    "Email",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  CustomInputField(
                    labelText: "Enter your email",
                    icon: Icons.email_outlined,
                    controller: emailController,
                    inputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),

                  // 🔹 Phone Field
                  const Text(
                    "Phone Number",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  CustomInputField(
                    labelText: "Enter your phone number",
                    icon: Icons.phone_outlined,
                    controller: phoneController,
                    inputType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),

                  // 🔹 Role Toggle Label
                  const Text(
                    "I am a",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),

                  // ✅ Smooth Animated Role Toggle
                  Container(
                    height: 50,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FB),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Stack(
                      children: [
                        // Animated background slider
                        AnimatedAlign(
                          alignment: isPatient
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeInOutCubic,
                          child: Container(
                            width: 160,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.25),
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Row for toggle text
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => isPatient = true),
                                child: Center(
                                  child: AnimatedDefaultTextStyle(
                                    duration:
                                    const Duration(milliseconds: 300),
                                    style: TextStyle(
                                      color: isPatient
                                          ? Colors.black
                                          : Colors.grey.shade600,
                                      fontWeight: isPatient
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      fontSize: 15,
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
                                    duration:
                                    const Duration(milliseconds: 300),
                                    style: TextStyle(
                                      color: !isPatient
                                          ? Colors.black
                                          : Colors.grey.shade600,
                                      fontWeight: !isPatient
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      fontSize: 15,
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

                  // 🔹 Password Fields
                  const Text(
                    "Password",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  CustomInputField(
                    labelText: "Create a password",
                    icon: Icons.lock_outline,
                    controller: passwordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    "Confirm Password",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  CustomInputField(
                    labelText: "Confirm your password",
                    icon: Icons.lock_outline,
                    controller: confirmPasswordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 30),

                  // 🔹 Gradient Create Account Button
                  CustomButton(
                    text: "Create Account",
                    onPressed: () {
                      // TODO: handle sign-up logic here
                    },
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
