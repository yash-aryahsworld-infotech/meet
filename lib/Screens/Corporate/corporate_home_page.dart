import 'package:flutter/material.dart';

class CorporateDashboard extends StatelessWidget {
  const CorporateDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Dashboard",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 30),

          // TOP CARDS
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _infoCard("Enrolled", "238", "95% of workforce", Colors.blue),
              _infoCard("Active Programs", "12", "Updated this week", Colors.green),
              _infoCard("Pending Tasks", "5", "Requires attention", Colors.orange),
            ],
          ),

          const SizedBox(height: 40),

          // MAIN ANALYTICS BOX
          Container(
            height: 340,
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: _boxDecoration(),
            child: Center(
              child: Text(
                "Analytics charts appear here",
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(
      String title, String value, String subtitle, Color color) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(22),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Text(value,
              style: TextStyle(
                  fontSize: 32, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: Colors.black45)),
        ],
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 12,
        )
      ],
    );
  }
}
