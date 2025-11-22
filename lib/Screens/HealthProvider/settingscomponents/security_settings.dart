import 'package:flutter/material.dart';
import 'package:healthcare_plus/widgets/custom_button.dart';

class SecuritySettings extends StatelessWidget {
  const SecuritySettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Security Settings",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 6),

          Text(
            "Manage your account security and privacy",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),

          const SizedBox(height: 25),

          // -------- Change Password Section ----------
          Row(
            children: const [
              Icon(Icons.lock_outline, size: 22),
              SizedBox(width: 8),
              Text(
                "Change Password",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // CURRENT PASSWORD
          const Text(
            "Current Password",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          _inputField(hint: "********"),

          const SizedBox(height: 20),

          // NEW PASSWORD
          const Text(
            "New Password",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          _inputField(hint: "Enter new password"),

          const SizedBox(height: 20),

          // CONFIRM PASSWORD
          const Text(
            "Confirm New Password",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          _inputField(hint: "Confirm new password"),

          const SizedBox(height: 25),

          // UPDATE BUTTON
          Align(
            alignment: Alignment.center,
            child: CustomButton(
              text: "Update Password",
              icon: Icons.save, // optional
              onPressed: () {
                // Your save logic here
              },

              // Optional button styling
              height: 40,
              textColor: Colors.white,
              buttonPadding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 0,
              ),

              colors: const [Color(0xFF2196F3), Color(0xFF1565C0)],
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------
  // REUSABLE TEXTFIELD WIDGET
  // ----------------------------------
  static Widget _inputField({required String hint}) {
    return TextField(
      obscureText: hint.contains("password"),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF4F6FF),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}
