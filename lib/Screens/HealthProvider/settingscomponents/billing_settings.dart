import 'package:flutter/material.dart';
import 'package:healthcare_plus/widgets/custom_button.dart';

class BillingSettings extends StatelessWidget {
  const BillingSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            "Billing & Payments",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 6),

          // Subtitle
          Text(
            "Manage your payment methods and billing information",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),

          const SizedBox(height: 40),

          // Center Section
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.credit_card, size: 70, color: Colors.grey),

                const SizedBox(height: 20),

                const Text(
                  "Payment Setup",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 10),

                Text(
                  "Set up your bank account and payment preferences\n"
                  "to receive consultation fees",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),

                const SizedBox(height: 25),

                // SAVE BUTTON
                Align(
                  alignment: Alignment.center,
                  child: CustomButton(
                    text: "Add Payment Method", // optional
                    onPressed: () {
                      // Your save logic here
                    },
                   buttonPadding: EdgeInsets.symmetric(
                     horizontal: 0,
                     vertical: 0),
                    // Optional button styling
                    height: 30,
                    width: 200,
                    textColor: Colors.white,
                    colors: const [Color(0xFF2196F3), Color(0xFF1565C0)],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
