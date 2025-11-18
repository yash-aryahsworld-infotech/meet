import 'package:flutter/material.dart';

class ConsultationEmptyState extends StatelessWidget {
  final int selectedTab;

  const ConsultationEmptyState({super.key, required this.selectedTab});

  String getTitle() {
    switch (selectedTab) {
      case 0:
        return "No active consultations";
      case 1:
        return "No completed consultations";
      case 2:
        return "No consultations found";
      default:
        return "";
    }
  }

  String getSubtitle() {
    switch (selectedTab) {
      case 0:
        return "All consultations are completed.";
      case 1:
        return "You have not completed any consultations yet.";
      case 2:
        return "You have no consultation records.";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.medical_services_outlined,
            size: 50,
            color: Colors.grey.shade600,
          ),
          const SizedBox(height: 16),
          Text(
            getTitle(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            getSubtitle(),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
