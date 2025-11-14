import 'package:flutter/material.dart';

class ConsultationsComponent extends StatelessWidget {
  const ConsultationsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Consultations Page",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
