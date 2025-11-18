import 'package:flutter/material.dart';

class UpcomingPatientsTab extends StatelessWidget {
  const UpcomingPatientsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return _emptyState(
      icon: Icons.calendar_month,
      title: "No Upcoming Appointments",
      subtitle: "There are no upcoming patient appointments.",
    );
  }

  Widget _emptyState({required IconData icon, required String title, required String subtitle}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.04),
            blurRadius: 8,
            spreadRadius: 1,
          )
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 60, color: Colors.grey.shade500),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
