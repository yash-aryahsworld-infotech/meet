import 'package:flutter/material.dart';

class PaymentLinksComponent extends StatelessWidget {
  const PaymentLinksComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Payment Links Page",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
