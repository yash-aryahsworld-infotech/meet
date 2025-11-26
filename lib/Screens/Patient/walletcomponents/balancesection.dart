import 'package:flutter/material.dart';
import 'package:healthcare_plus/widgets/custom_button.dart'; // ← your custom button file

class BalanceSection extends StatelessWidget {
  const BalanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFE9F2FD),
        borderRadius: BorderRadius.circular(12),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 800;

          // ⭐ Replaced with CustomButton
          Widget addMoneyBtn = CustomButton(
            text: "Add Money",
            icon: Icons.account_balance_wallet_outlined,
            width: isMobile ? double.infinity : 200,
            height: 30,
            colors: const [
              Color(0xFF1E88E5),
              Color(0xFF1565C0),
            ],
            onPressed: () {},
          );

          Widget card(String title, String value, Color valueColor) {
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: valueColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          List<Widget> cards = [
            card("Available Balance", "₹0", Colors.blue.shade700),
            card("Locked Amount", "₹0", Colors.grey.shade700),
            card("Reward Points", "125", Colors.orange.shade700),
          ];

          return isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: cards
                            .map(
                              (c) => Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: SizedBox(width: 160, child: c),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 14),
                    addMoneyBtn, // ⭐ Custom button here
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: cards
                            .map(
                              (c) => Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: c,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    addMoneyBtn, // ⭐ Custom button here
                  ],
                );
        },
      ),
    );
  }
}
