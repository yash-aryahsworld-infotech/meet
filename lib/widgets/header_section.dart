import 'package:flutter/material.dart';
import '../utils/app_responsive.dart';

class HeaderSection extends StatelessWidget {
  final String doctorName;
  final int appointmentsToday;
  final bool isOnline;

  const HeaderSection({
    super.key,
    required this.doctorName,
    required this.appointmentsToday,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade700,
        borderRadius: BorderRadius.circular(AppResponsive.radiusLG),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// LEFT SIDE
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome back, $doctorName!",
                    style: TextStyle(
                    color: Colors.white,
                    fontSize: AppResponsive.fontXL(context),
                    fontWeight: AppResponsive.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "You have $appointmentsToday appointments today",
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          /// RIGHT SIDE
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text("Online Status", style: TextStyle(color: Colors.white70)),
              Row(
                children: [
                  Icon(Icons.circle,
                      color: isOnline ? Colors.green : Colors.red, size: 12),
                  const SizedBox(width: 6),
                  Text(
                    isOnline ? "Available" : "Offline",
                    style: const TextStyle(color: Colors.white),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
