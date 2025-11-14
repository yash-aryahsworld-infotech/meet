import 'package:flutter/material.dart';

class Insurance extends StatefulWidget {
  const Insurance({super.key});

  @override
  State<Insurance> createState() => _InsuranceState();
}

class _InsuranceState extends State<Insurance> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Insurance",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
