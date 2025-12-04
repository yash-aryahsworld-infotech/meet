import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:healthcare_plus/widgets/custom_tab.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/custom_button.dart';

class SignUpForm extends StatefulWidget {
  final VoidCallback onSwitchToSignIn;

  const SignUpForm({super.key, required this.onSwitchToSignIn});

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

  int selectedRole = 0;
  bool _isLoading = false;

  // 🔹 Validation Function
  bool _validateInputs() {
    if (firstNameController.text.trim().isEmpty ||
        lastNameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        confirmPasswordController.text.trim().isEmpty) {
      _showSnackBar("Please fill in all fields");
      return false;
    }

    // 🔹 Basic Email Validation
    if (!RegExp(
      r"^[\w.-]+@[\w.-]+\.\w+$",
    ).hasMatch(emailController.text.trim())) {
      _showSnackBar("Enter a valid email address");
      return false;
    }

    // 🔹 Password Validation
    if (passwordController.text.length < 6) {
      _showSnackBar("Password must be at least 6 characters long");
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      _showSnackBar("Passwords do not match");
      return false;
    }

    // 🔹 Phone number validation
    if (!RegExp(r"^[0-9]{10}$").hasMatch(phoneController.text.trim())) {
      _showSnackBar("Enter a valid 10-digit phone number");
      return false;
    }

    return true;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  // 🔹 Save User to Firebase
  Future<void> _saveUserToFirebase() async {
    if (!_validateInputs()) return;

    setState(() => _isLoading = true);

    // Hash password
    String hashPassword(String password) {
      final bytes = utf8.encode(password);
      final digest = sha256.convert(bytes);
      return digest.toString();
    }

    try {
      // Root reference
      final DatabaseReference dbRef =
      FirebaseDatabase.instance.ref().child("healthcare/users");

      // Correct role folder
      String rolePath = selectedRole == 0
          ? "patients"
          : selectedRole == 1
          ? "providers"
          : "corporates";

      // ⭐ PUSH INSIDE ROLE NODE (CORRECT WAY)
      final roleRef = dbRef.child(rolePath).push();
      String userKey = roleRef.key!;

      // Save user
      await roleRef.set({
        "userKey": userKey,
        "firstName": firstNameController.text.trim(),
        "lastName": lastNameController.text.trim(),
        "email": emailController.text.trim(),
        "phone": phoneController.text.trim(),
        "role": rolePath, // stored as "patients/providers/corporate"
        "password": hashPassword(passwordController.text.trim()),
        "created_at": DateTime.now().toIso8601String(),
      });

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Account created successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      // Clear fields
      firstNameController.clear();
      lastNameController.clear();
      emailController.clear();
      phoneController.clear();
      passwordController.clear();
      confirmPasswordController.clear();

      widget.onSwitchToSignIn();
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar("Error saving data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
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

          // 🔹 Phone
          const Text(
            "Phone Number",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
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
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          TabToggle(
            options: const ["Patient", "Healthcare Provider","Corporate"],
            selectedIndex: selectedRole,
            onSelected: (index) => setState(() => selectedRole = index),
          ),
          const SizedBox(height: 20),

          // 🔹 Password
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
            labelText: "Create a password",
            icon: Icons.lock_outline,
            controller: passwordController,
            obscureText: true,
          ),
          const SizedBox(height: 20),

          // 🔹 Confirm Password
          const Text(
            "Confirm Password",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          CustomInputField(
            labelText: "Confirm your password",
            icon: Icons.lock_outline,
            controller: confirmPasswordController,
            obscureText: true,
          ),
          const SizedBox(height: 30),

          // 🔹 Submit Button (with loader)
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : CustomButton(
                  text: "Create Account",
                  onPressed: _saveUserToFirebase,
                ),
        ],
      ),
    );
  }
}
