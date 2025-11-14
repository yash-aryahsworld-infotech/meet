import 'package:flutter/material.dart';

class CorporateBillingPage extends StatelessWidget {
  const CorporateBillingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Billing",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),

          const SizedBox(height: 30),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: _box(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Current Plan: Premium",
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text("Renews on: 12 Jan 2025"),
              ],
            ),
          )
        ],
      ),
    );
  }

  BoxDecoration _box() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: const [
      BoxShadow(color: Colors.black12, blurRadius: 10)
    ],
  );
}
