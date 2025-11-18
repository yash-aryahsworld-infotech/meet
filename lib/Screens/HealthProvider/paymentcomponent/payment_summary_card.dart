import 'package:flutter/material.dart';
import '../../../utils/app_responsive.dart';
import '../../../widgets/custom_button.dart';

class PaymentSummaryCard extends StatelessWidget {
  final String pageTitle;
  final String subtitle;

  final String title;
  final String amount;
  final String doctorName;
  final String date;

  final List<String> features;

  final String buttonText;          // NEW
  final VoidCallback onButtonPressed; // NEW

  const PaymentSummaryCard({
    super.key,
    required this.pageTitle,
    required this.subtitle,
    required this.title,
    required this.amount,
    required this.doctorName,
    required this.date,
    required this.features,
    required this.buttonText,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    double size = AppResponsive.width(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(size < AppResponsive.mobile ? 16 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppResponsive.radiusMD),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ------------------ TITLE ------------------
          Text(
            pageTitle,
            style: TextStyle(
              fontSize: AppResponsive.fontXL(context),
              fontWeight: AppResponsive.bold,
            ),
          ),

          const SizedBox(height: AppResponsive.spaceSM),

          Text(
            subtitle,
            style: TextStyle(
              fontSize: AppResponsive.fontSM(context),
              color: Colors.grey[600],
            ),
          ),

          const SizedBox(height: AppResponsive.spaceXL),

          // ------------------ LIGHT GREY SUB-CONTAINER ------------------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F4F7), // light grey
              borderRadius: BorderRadius.circular(AppResponsive.radiusSM),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Row
                Row(
                  children: [
                    Icon(
                      Icons.computer,
                      size: size < 600 ? 24 : 30,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: AppResponsive.fontLG(context),
                        fontWeight: AppResponsive.semiBold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppResponsive.spaceMD),

                Text(
                  "Amount: $amount",
                  style: TextStyle(
                    fontSize: AppResponsive.fontMD(context),
                    fontWeight: AppResponsive.medium,
                  ),
                ),
                const SizedBox(height: 6),

                Text(
                  "Doctor: $doctorName",
                  style: TextStyle(
                    fontSize: AppResponsive.fontSM(context),
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  "Date: $date",
                  style: TextStyle(
                    fontSize: AppResponsive.fontSM(context),
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppResponsive.spaceXL),

          // ------------------ FEATURES ------------------
          Text(
            "Features:",
            style: TextStyle(
              fontSize: AppResponsive.fontMD(context),
              fontWeight: AppResponsive.semiBold,
            ),
          ),

          const SizedBox(height: AppResponsive.spaceSM),
LayoutBuilder(
  builder: (context, constraints) {
    bool isMobile = AppResponsive.isMobile(context);

    // -------- MOBILE: ALL FEATURES IN ONE COLUMN --------
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: features.map((text) {
          return Padding(
            padding: EdgeInsets.only(bottom: AppResponsive.spaceSM),
            child: Row(
              children: [
                const Icon(Icons.check_circle, size: 18, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(fontSize: AppResponsive.fontSM(context)),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    }

    // -------- DESKTOP / TABLET: TWO COLUMNS --------
    int mid = (features.length / 2).ceil();
    List<String> left = features.sublist(0, mid);
    List<String> right = features.sublist(mid);

    Widget buildItem(String text) {
      return Padding(
        padding: EdgeInsets.only(bottom: AppResponsive.spaceSM),
        child: Row(
          children: [
            const Icon(Icons.check_circle, size: 18, color: Colors.green),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: AppResponsive.fontSM(context)),
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LEFT COLUMN
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: left.map(buildItem).toList(),
          ),
        ),

        SizedBox(width: AppResponsive.spaceXL),

        // RIGHT COLUMN
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: right.map(buildItem).toList(),
          ),
        ),
      ],
    );
  },
),
        const SizedBox(height: AppResponsive.spaceXL),

          // ------------------ BUTTON INSIDE CARD ------------------
          CustomButton(
            text: buttonText,
            onPressed: onButtonPressed,
            icon: Icons.link,
          ),
        ],
      ),
    );
  }
}
