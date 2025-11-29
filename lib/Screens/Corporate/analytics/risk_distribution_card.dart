import 'package:flutter/material.dart';

class RiskDistributionCard extends StatelessWidget {
  const RiskDistributionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withAlpha(20),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("Risk Distribution",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937))),
        const SizedBox(height: 32),
        _buildRiskItem(
            "Low Risk", 0.74, "145 employees (74%)", const Color(0xFF2563EB)),
        const SizedBox(height: 24),
        _buildRiskItem("Medium Risk", 0.18, "35 employees (18%)",
            const Color(0xFF2563EB).withOpacity(0.7)),
        const SizedBox(height: 24),
        _buildRiskItem("High Risk", 0.08, "15 employees (8%)",
            const Color(0xFF2563EB).withOpacity(0.4)),
      ]),
    );
  }

  Widget _buildRiskItem(
      String label, double percent, String countText, Color color) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        Text(countText,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
      ]),
      const SizedBox(height: 8),
      ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
              value: percent,
              minHeight: 8,
              backgroundColor: Colors.grey.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(color)))
    ]);
  }
}