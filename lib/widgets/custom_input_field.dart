import 'package:flutter/material.dart';
import '../utils/responsive.dart';

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
    final responsive = Responsive(context);
    final double scaledFont = responsive.scale(14);

    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: inputType,
      style: TextStyle(
        fontSize: scaledFont,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey, size: scaledFont + 4),
        labelText: labelText,
        labelStyle: TextStyle(
          fontSize: scaledFont - 1,
          color: Colors.grey.shade700,
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: responsive.isMobile ? 12 : 16,
          horizontal: responsive.isMobile ? 14 : 18,
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
