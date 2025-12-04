import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_plus/Screens/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/custom_button.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;

  // 🔐 Hash function
  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // 🔍 Login Function
  Future<void> _loginUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar("Enter email and password");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final ref = FirebaseDatabase.instance.ref("healthcare/users");

      final snapshot = await ref.get();

      if (!snapshot.exists) {
        _showSnackBar("No users found in database");
        setState(() => _isLoading = false);
        return;
      }

      Map data = snapshot.value as Map;

      String? finalRole;
      String? finalUserKey;
      Map? finalUserData;

      // LOOP THROUGH ROLES → patients/providers/corporate/admin
      for (String role in ["patients", "providers", "corporate", "admin"]) {
        if (data[role] != null) {
          Map usersOfRole = data[role];

          usersOfRole.forEach((key, user) {
            if (user["email"] == email) {
              finalRole = role;
              finalUserKey = key;
              finalUserData = user;
            }
          });
        }
      }

      if (finalUserData == null) {
        _showSnackBar("No user found with this email");
        setState(() => _isLoading = false);
        return;
      }

      // Compare passwords
      String storedHash = finalUserData!["password"];
      String enteredHash = hashPassword(password);

      if (storedHash != enteredHash) {
        _showSnackBar("Incorrect password");
        setState(() => _isLoading = false);
        return;
      }

      // LOGIN SUCCESS → Save user to SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("userKey", finalUserKey!);
      await prefs.setString("userRole", finalRole!); // patients/providers/corporate
      await prefs.setBool("userFound", true);

      if (!mounted) return;

      // Navigate to dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DashboardPage(
            userKey: finalUserKey!,
            userRole: finalRole!,
          ),
        ),
      );

      _showSnackBar("Login Successful!", bg: Colors.green);

    } catch (e) {
      _showSnackBar("Login failed: $e");
    }

    setState(() => _isLoading = false);
  }

  // Snackbar Helper
  void _showSnackBar(String message, {Color bg = Colors.redAccent}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: bg),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Email"),
        const SizedBox(height: 6),
        CustomInputField(
          labelText: "Enter your email",
          icon: Icons.email_outlined,
          controller: emailController,
        ),
        const SizedBox(height: 20),

        const Text("Password"),
        const SizedBox(height: 6),
        CustomInputField(
          labelText: "Enter your password",
          icon: Icons.lock_outline,
          controller: passwordController,
          obscureText: true,
        ),
        const SizedBox(height: 30),

        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomButton(
          text: "Login",
          onPressed: _loginUser,
        ),
      ],
    );
  }
}
