import 'package:flutter/material.dart';

class AllAppointmentsTab extends StatelessWidget {
  const AllAppointmentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Text(
        "All appointments will be listed here",
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
