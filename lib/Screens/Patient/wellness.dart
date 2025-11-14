import 'package:flutter/material.dart';

class Wellness extends StatefulWidget {
  const Wellness({super.key});

  @override
  State<Wellness> createState() => _WellnessState();
}

class _WellnessState extends State<Wellness> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Wellness",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );;
  }
}
