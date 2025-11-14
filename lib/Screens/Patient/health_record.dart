import 'package:flutter/material.dart';

class HealthRecord extends StatefulWidget {
  const HealthRecord({super.key});

  @override
  State<HealthRecord> createState() => _HealthRecordState();
}

class _HealthRecordState extends State<HealthRecord> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Health Record",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
