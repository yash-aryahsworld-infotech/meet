import 'package:flutter/material.dart';
import '../utils/app_responsive.dart';
import '../widgets/custom_button.dart'; // import your gradient button

class EarningsSection extends StatelessWidget {
  const EarningsSection({super.key});

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
        children: [
          const Text("₹ Earnings",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          const Text("Today", style: TextStyle(color: Colors.grey)),
          const Text(
            "₹4,500",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 20),

          const Text("This Week", style: TextStyle(color: Colors.grey)),
          const Text(
            "₹28,000",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          const Text("This Month", style: TextStyle(color: Colors.grey)),
          Row(
            children: const [
              Text(
                "₹125,000",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 8),
              Chip(
                label: Text("+12.5%"),
                backgroundColor: Color(0xFFE6FFF0),
                labelStyle: TextStyle(color: Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 20),

          /// 🔵 Replaced ElevatedButton → CustomButton
          CustomButton(
            text: "View Detailed Report",
            onPressed: () {
              // your action here
            },
          ),
        ],
      ),
    );
  }
}
