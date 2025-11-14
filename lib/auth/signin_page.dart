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
      final DatabaseReference ref =
      FirebaseDatabase.instance.ref("healthcare/users");

      final snapshot = await ref.once();

      Map<dynamic, dynamic> data =
      snapshot.snapshot.value as Map<dynamic, dynamic>;

      bool found = false;
      bool isUserLogin = false;
      String userRole = "patient";
      String userKey = "";

      // 🔎 Loop through users to match email
      data.forEach((key, user) async {
        if (user["email"] == email) {
          found = true;

          userKey = user["userKey"];
          userRole = user["role"];

          String storedHashedPassword = user["password"];
          String enteredHashedPassword = hashPassword(password);

          if (storedHashedPassword == enteredHashedPassword) {

            isUserLogin = true;

            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString("userKey", userKey);
            await prefs.setBool("userFound", isUserLogin);
            await prefs.setString("userRole", userRole);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DashboardPage(userKey: userKey, userRole: userRole,)),
            );

            _showSnackBar("Login Successful!", bg: Colors.green);
          } else {
            _showSnackBar("Incorrect password");
          }
        }
      });

      if (!found) {
        _showSnackBar("No user found with this email");
      }
    } catch (e) {
      _showSnackBar("Error: $e");
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
