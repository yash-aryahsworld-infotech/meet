import 'package:flutter/material.dart';

class EarningsComponent extends StatelessWidget {
  const EarningsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Earnings Page",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
