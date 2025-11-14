import 'package:flutter/material.dart';

class PatientsComponent extends StatelessWidget {
  const PatientsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Patients Page",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
