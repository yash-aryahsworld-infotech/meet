import 'package:flutter/material.dart';

class RevenueTab extends StatelessWidget {
  const RevenueTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildPlaceholderCard("Popular Services")),
            const SizedBox(width: 16),
            Expanded(child: _buildPlaceholderCard("Payment Methods")),
          ],
        ),
        const SizedBox(height: 24),
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
              const Text("Monthly Trends", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              _buildTrendRow("Jul 2025", "0", "₹0", "0"),
              const Divider(height: 32),
              _buildTrendRow("Aug 2025", "0", "₹0", "0"),
              const Divider(height: 32),
              _buildTrendRow("Sep 2025", "21", "₹0", "0"),
              const Divider(height: 32),
              _buildTrendRow("Oct 2025", "0", "₹0", "0"),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildPlaceholderCard(String title) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTrendRow(String date, String users, String revenue, String appts) {
    return Row(
      children: [
        Expanded(flex: 2, child: Text(date, style: const TextStyle(fontWeight: FontWeight.w600))),
        Expanded(child: _buildStatColumn(users, "Users")),
        Expanded(child: _buildStatColumn(revenue, "Revenue")),
        Expanded(child: _buildStatColumn(appts, "Appointments")),
      ],
    );
  }

  Widget _buildStatColumn(String val, String label) {
    return Column(
      children: [
        Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}