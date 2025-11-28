import 'package:flutter/material.dart';

class HealthWellnessTab extends StatelessWidget {
  const HealthWellnessTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.favorite_border, size: 20, color: Colors.grey[700]),
              const SizedBox(width: 10),
              const Text(
                "Health & Wellness Configuration",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Switch 1
          _buildDirectSwitch("Enable Health Screenings", "Allow employees to book health screenings", true),
          // Switch 2
          _buildDirectSwitch("Mandatory Annual Checkup", "Require employees to complete annual health checkup", true),
          // Switch 3
          _buildDirectSwitch("Allow Family Members", "Extend health benefits to employee family members", false),
          // Switch 4
          _buildDirectSwitch("Enable Mental Health Support", "Provide access to mental health resources", true),
          // Switch 5
          _buildDirectSwitch("Enable Fitness Programs", "Offer fitness and wellness programs", true),

          const SizedBox(height: 16),
          // Input
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Health Budget per Employee (Annual)", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              TextFormField(
                initialValue: "5000",
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Switch 6
          _buildDirectSwitch("Emergency Contact Required", "Require employees to provide emergency contact", true),

          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Save Health Settings"),
          ),
        ],
      ),
    );
  }

  // Simple local helper just to reduce repeated Row code slightly, 
  // but logic is direct.
  Widget _buildDirectSwitch(String title, String subtitle, bool value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: (val) {},
            activeColor: const Color(0xFF2563EB),
          ),
        ],
      ),
    );
  }
}