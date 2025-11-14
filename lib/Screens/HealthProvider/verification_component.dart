import 'package:flutter/material.dart';

class VerificationComponent extends StatelessWidget {
  const VerificationComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Verification Page",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
