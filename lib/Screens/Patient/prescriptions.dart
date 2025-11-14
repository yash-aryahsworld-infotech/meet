import 'package:flutter/material.dart';

class Prescriptions extends StatefulWidget {
  const Prescriptions({super.key});

  @override
  State<Prescriptions> createState() => _PrescriptionsState();
}

class _PrescriptionsState extends State<Prescriptions> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Prescriptions",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
