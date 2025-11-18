import 'package:flutter/material.dart';
import '../../widgets/custom_header.dart';
import '../../utils/app_responsive.dart'; // if you have earnings cards

class EarningsComponent extends StatelessWidget {
  const EarningsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      
      children: [

        /// ------------------ HEADER ------------------
        PageHeader(
          title: "Earnings Dashboard",
          subtitle: "Track your consultation earnings and payments",
          button1Icon: Icons.download,
          button1Text: "Export Reports",
          button1OnPressed: () {
            // TODO: Export logic here
          },
          padding: AppResponsive.pagePadding(context), 
        ),

        const SizedBox(height: 20),

        /// ------------------ EARNINGS SUMMARY BOX ------------------
    // the white card you built
 

        /// ------------------ ADD MORE SECTIONS HERE ------------------
        Container(
          width: double.infinity,
  
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppResponsive.radiusMD),
          ),
          child: const Text(
            "More earnings content here...",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
