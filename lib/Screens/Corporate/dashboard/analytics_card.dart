import 'package:flutter/material.dart';

class AnalyticsCard extends StatelessWidget {
  final List analytics;
  
  const AnalyticsCard({super.key, required this.analytics});

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
          Row(
            children: [
              Icon(Icons.bar_chart, color: Colors.grey.shade700, size: 20),
              const SizedBox(width: 8),
              const Text("Health Analytics", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 24),
          ...analytics.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['label'], style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    Text(item['value'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: (item['isPositive'] ? const Color(0xFFE8F5E9) : const Color(0xFFE3F2FD)), // Light Green or Light Blue
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    item['change'],
                    style: TextStyle(
                      color: item['isPositive'] ? Colors.green.shade700 : Colors.blue.shade700,
                      fontSize: 11,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                )
              ],
            ),
          )),
        ],
      ),
    );
  }
}