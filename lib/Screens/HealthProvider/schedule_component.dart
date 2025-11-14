import 'package:flutter/material.dart';

class ScheduleComponent extends StatelessWidget {
  const ScheduleComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Schedule Page",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
