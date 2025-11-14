import 'package:flutter/material.dart';
import '../utils/app_responsive.dart';

class PatientOverviewSection extends StatelessWidget {
  const PatientOverviewSection({super.key});

  Widget overviewItem(String value, String label, Color color) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = AppResponsive.isMobile(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppResponsive.radiusLG),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Patient Overview",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 20),

          /// Values Row / Column
          isMobile
              ? Column(
                  children: [
                    overviewItem("245", "Total Patients", Colors.blue),
                    const SizedBox(height: 20),
                    overviewItem("89%", "Satisfaction Rate", Colors.green),
                    const SizedBox(height: 20),
                    overviewItem("156", "Consultations This Month", Colors.teal),
                  ],
                )
              : Row(
                  children: [
                    overviewItem("245", "Total Patients", Colors.blue),
                    overviewItem("89%", "Satisfaction Rate", Colors.green),
                    overviewItem("156", "Consultations This Month", Colors.teal),
                  ],
                )
        ],
      ),
    );
  }
}
