import 'package:flutter/material.dart';

class ProjectionsTab extends StatelessWidget {
  const ProjectionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildCard("Revenue Projections", Icons.track_changes, [
                _buildRow("Next Month (Projected)", "₹0"),
                _buildRow("Next Quarter (Projected)", "₹0"),
                _buildRow("Annual Run Rate", "₹0"),
              ]),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildCard("Growth Projections", Icons.bar_chart, [
                _buildRow("Projected Users (Next Month)", "26"),
                _buildRow("Projected Appointments (Monthly)", "0"),
                _buildRow("Market Penetration", "0.26%"),
              ]),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Key Performance Indicators", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: _buildIndicator("Monthly Recurring Revenue Growth", "0.0%")),
                  const SizedBox(width: 24),
                  Expanded(child: _buildIndicator("Appointment Completion Rate", "0%")),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: _buildIndicator("User Acquisition Rate", "0.0%")),
                  const SizedBox(width: 24),
                  Expanded(child: _buildIndicator("Platform Utilization", "0.0%")),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildCard(String title, IconData icon, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(icon, size: 20, color: Colors.grey[700]), const SizedBox(width: 8), Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]),
          const SizedBox(height: 16),
          ...children.map((e) => Padding(padding: const EdgeInsets.only(bottom: 12), child: e)),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 13)),
      Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
    ]);
  }

  Widget _buildIndicator(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.black87)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ]),
        const SizedBox(height: 8),
        LinearProgressIndicator(value: 0, minHeight: 6, backgroundColor: Colors.grey[100], borderRadius: BorderRadius.circular(3)),
      ],
    );
  }
}