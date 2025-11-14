import 'package:flutter/material.dart';
import '../utils/app_responsive.dart';

class ScheduleSection extends StatelessWidget {
  const ScheduleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppResponsive.radiusMD),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Today's Schedule",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Icon(Icons.calendar_today),
            ],
          ),
          SizedBox(height: 12),
          Text("0 appointments today"),
          SizedBox(height: 30),
          Center(
            child: Text(
              "No appointments scheduled for today",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
