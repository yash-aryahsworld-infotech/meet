import 'package:flutter/material.dart';

class ROICard extends StatelessWidget {
  final Map<String, dynamic> data;
  
  const ROICard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Return on Investment", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          _roiRow("Program Investment", data['investment'], Colors.black87),
          const SizedBox(height: 16),
          _roiRow("Healthcare Savings", data['savings'], Colors.green),
          const SizedBox(height: 16),
          _roiRow("Productivity Gains", data['gains'], Colors.green),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Divider(),
          ),
          _roiRow("Net ROI", data['net'], Colors.green, isBold: true),
        ],
      ),
    );
  }

  Widget _roiRow(String label, String value, Color valueColor, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: isBold ? Colors.black87 : Colors.grey.shade600, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: valueColor, fontSize: isBold ? 16 : 14)),
      ],
    );
  }
}