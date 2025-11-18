import 'package:flutter/material.dart';
import '../../utils/app_responsive.dart';
import './paymentcomponent/payment_summary_card.dart';

class PaymentLinksComponent extends StatelessWidget {
  const PaymentLinksComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return MaxWidthContainer(
      child: Padding(
        padding: AppResponsive.pagePadding(context),
        child: Column(
          children: [
            PaymentSummaryCard(
              pageTitle: "One-Tap Payment Link",
              subtitle: "Generate instant payment link for Teleconsultation",

              title: "Teleconsultation",
              amount: "₹500",
              doctorName: "Dr. Smith",
              date: "Tomorrow 10:00 AM",

              features: const [
                "One-tap payment",
                "24hr validity",
                "QR code included",
                "Auto receipt",
              ],

              // NEW → BUTTON TEXT + ACTION PASSED FROM PARENT
              buttonText: "Generate Payment Link",
              onButtonPressed: () {
                print("Payment link generated!");
              },
            ),
          ],
        ),
      ),
    );
  }
}
