import 'package:flutter/material.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top Row: 4 KPI Cards
        Row(
          children: [
            _buildKpiCard("Total Users", "26", "+0.0% from last month", Icons.people_outline),
            const SizedBox(width: 16),
            _buildKpiCard("Total Revenue", "₹0", "+0.0% from last month", Icons.attach_money),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildKpiCard("Monthly Revenue", "₹0", "Current month earnings", Icons.show_chart),
            const SizedBox(width: 16),
            _buildKpiCard("Appointments", "0", "0 completed", Icons.calendar_today_outlined),
          ],
        ),

        const SizedBox(height: 24),

        // Bottom Row: Breakdown & Metrics
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Breakdown
            Expanded(
              child: _buildContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("User Breakdown", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 24),
                    _buildProgressBar("Patients", 12, 0.46, Colors.blue),
                    const SizedBox(height: 24),
                    _buildProgressBar("Providers", 9, 0.34, Colors.green),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 24),
            // Business Metrics
            Expanded(
              child: _buildContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Business Metrics", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 24),
                    _buildMetricRow("Avg Transaction Value", "₹0"),
                    const SizedBox(height: 16),
                    _buildMetricRow("Appointment Completion Rate", "0%"),
                    const SizedBox(height: 16),
                    _buildMetricRow("Patient to Provider Ratio", "1.3:1"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKpiCard(String title, String value, String subtitle, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w500)),
                Icon(icon, size: 18, color: Colors.grey[400]),
              ],
            ),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(color: subtitle.contains("+") ? Colors.green : Colors.grey[500], fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: child,
    );
  }

  Widget _buildProgressBar(String label, int count, double percent, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [Icon(label == "Patients" ? Icons.person_outline : Icons.medical_services_outlined, size: 16, color: color), const SizedBox(width: 8), Text(label)]),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text("$count", style: const TextStyle(fontWeight: FontWeight.bold)), Text("${(percent * 100).toStringAsFixed(1)}%", style: const TextStyle(fontSize: 11, color: Colors.grey))]),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(value: percent, backgroundColor: Colors.grey[100], color: color, minHeight: 6, borderRadius: BorderRadius.circular(3)),
      ],
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.black87)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}