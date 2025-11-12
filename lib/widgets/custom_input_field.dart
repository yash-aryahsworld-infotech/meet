import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String labelText;
  final IconData icon;
  final bool obscureText;
  final TextInputType inputType;
  final TextEditingController controller;

  const CustomInputField({
    super.key,
    required this.labelText,
    required this.icon,
    this.obscureText = false,
    this.inputType = TextInputType.text,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: inputType,
      style: const TextStyle(
        fontSize: 14, // smaller text size inside the field
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey, size: 20), // smaller icon
        labelText: labelText,
        labelStyle: const TextStyle(
          fontSize: 13, // smaller label text
          color: Colors.grey,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12, // reduced height
          horizontal: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
    );
  }
}
