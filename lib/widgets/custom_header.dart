import 'package:flutter/material.dart';
import '../utils/app_responsive.dart';
import './custom_button.dart';

// custom_header.dart

//  PageHeader(
        //   title: "Earnings Dashboard",
        //   subtitle: "Track your consultation earnings and payments",
        //   button1Icon: Icons.download,
        //   button1Text: "Export Reports",
        //   button1OnPressed: () {},
        //   button2Icon: Icons.download,
        //   button2Text: "Export Reports",
        //   button2OnPressed: () {},
        //   padding: AppResponsive.pagePadding(context),
        // ),










class PageHeader extends StatelessWidget {
  final String title;

  final String? subtitle; // OPTIONAL

  final IconData? button1Icon; // OPTIONAL
  final String? button1Text; // OPTIONAL
  final VoidCallback? button1OnPressed; // OPTIONAL

  final IconData? button2Icon; // OPTIONAL
  final String? button2Text; // OPTIONAL
  final VoidCallback? button2OnPressed; // OPTIONAL

  final EdgeInsetsGeometry? padding; // OPTIONAL

  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.button1Icon,
    this.button1Text,
    this.button1OnPressed,
    this.button2Icon,
    this.button2Text,
    this.button2OnPressed,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMobile = AppResponsive.isMobile(context);
    final bool isTablet = AppResponsive.isTablet(context);

    final bool hasButton1 = button1Text != null && button1OnPressed != null;
    final bool hasButton2 = button2Text != null && button2OnPressed != null;

    // ------------------------------------------------------------
    // BUTTON BUILDER (ICON OPTIONAL)
    // ------------------------------------------------------------
    Widget buildCustomBtn(
      String text,
      VoidCallback onPressed, {
      IconData? icon,
    }) {
      if (isMobile || isTablet) {
        return SizedBox(
          height: 45,
          width: double.infinity,
          child: CustomButton(
            icon: icon, // icon optional
            text: text,
            onPressed: onPressed,
          ),
        );
      }

      // Desktop / Web auto width
      return IntrinsicWidth(
        child: SizedBox(
          height: 45,
          child: CustomButton(
            icon: icon, // icon optional
            text: text,
            onPressed: onPressed,
          ),
        ),
      );
    }

    // ------------------------------------------------------------
    // LAYOUT
    // ------------------------------------------------------------
    return Padding(
      padding: padding ?? EdgeInsets.only(bottom: AppResponsive.spaceXL),
      child: isMobile || isTablet
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TITLE
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppResponsive.fontXL(context),
                    fontWeight: AppResponsive.bold,
                  ),
                ),

                // SUBTITLE
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: AppResponsive.fontSM(context),
                      color: Colors.grey[600],
                    ),
                  ),
                ],

                // BUTTONS
                if (hasButton1 || hasButton2)
                  const SizedBox(height: AppResponsive.spaceLG),
                  Row(
                    children: [
                      if (hasButton1)
                        Expanded(
                          child: buildCustomBtn(
                            button1Text!,
                            button1OnPressed!,
                            icon: button1Icon,
                          ),
                        ),

                      if (hasButton1 && hasButton2)
                        const SizedBox(width: 12),

                      if (hasButton2)
                        Expanded(
                          child: buildCustomBtn(
                            button2Text!,
                            button2OnPressed!,
                            icon: button2Icon,
                          ),
                        ),
                    ],
                  ),
              ],
            )

          // DESKTOP/TABLET VIEW
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // LEFT
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: AppResponsive.fontXL(context),
                        fontWeight: AppResponsive.bold,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: AppResponsive.fontSM(context),
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),

                // RIGHT BUTTONS
                if (hasButton1 || hasButton2)
                  Row(
                    children: [
                      if (hasButton1)
                        buildCustomBtn(
                          button1Text!,
                          button1OnPressed!,
                          icon: button1Icon,
                        ),

                      if (hasButton1 && hasButton2)
                        const SizedBox(width: 12),

                      if (hasButton2)
                        buildCustomBtn(
                          button2Text!,
                          button2OnPressed!,
                          icon: button2Icon,
                        ),
                    ],
                  ),
              ],
            ),
    );
  }
}
