import 'package:flutter/material.dart';

class UsersTab extends StatelessWidget {
  const UsersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top 3 Cards
        Row(
          children: [
            _buildUserKpi("Total Patients", "12", "46.2% of total users", Icons.person_outline),
            const SizedBox(width: 16),
            _buildUserKpi("Total Providers", "9", "34.6% of total users", Icons.medical_services_outlined),
            const SizedBox(width: 16),
            _buildUserKpi("User Growth", "+0.0%", "Compared to last month", Icons.show_chart, isGreen: true),
          ],
        ),
        const SizedBox(height: 24),
        
        // Registration Trends
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("User Registration Trends", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              _buildRegRow("Jul 2025", "0 new users", 0.0),
              const Divider(height: 32),
              _buildRegRow("Aug 2025", "0 new users", 0.0),
              const Divider(height: 32),
              _buildRegRow("Sep 2025", "21 new users", 0.8),
              const Divider(height: 32),
              _buildRegRow("Oct 2025", "0 new users", 0.0),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserKpi(String title, String value, String sub, IconData icon, {bool isGreen = false}) {
    return Expanded(
      child: Container(
        height: 110,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(title, style: TextStyle(fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.w500)),
              Icon(icon, size: 18, color: Colors.grey[400]),
            ]),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isGreen ? Colors.green : Colors.black)),
              Text(sub, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildRegRow(String date, String desc, double progress) {
    return Row(
      children: [
        SizedBox(width: 100, child: Text(date, style: const TextStyle(fontWeight: FontWeight.w600))),
        Expanded(child: Container()), // Spacer
        Text(desc, style: const TextStyle(fontSize: 13, color: Colors.black87)),
        const SizedBox(width: 16),
        SizedBox(
          width: 80,
          child: LinearProgressIndicator(
            value: progress, 
            minHeight: 8, 
            borderRadius: BorderRadius.circular(4),
            color: Colors.blue[600],
            backgroundColor: Colors.grey[100],
          ),
        )
      ],
    );
  }
}