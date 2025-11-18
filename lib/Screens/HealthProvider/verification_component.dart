import 'package:flutter/material.dart';
import '../../widgets/custom_input_field.dart';
import '../../widgets/custom_button.dart';
import '../../utils/app_responsive.dart'; // ← Import your responsive system

class VerificationComponent extends StatefulWidget {
  const VerificationComponent({super.key});

  @override
  State<VerificationComponent> createState() => _VerificationComponentState();
}

class _VerificationComponentState extends State<VerificationComponent> {
  final TextEditingController nmrController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isMobile = AppResponsive.isMobile(context);
    bool isTablet = AppResponsive.isTablet(context);
    bool isDesktop = AppResponsive.isDesktop(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(26),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppResponsive.radiusMD),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 2,
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: MaxWidthContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title Row
                Row(
                  children: [
                    Icon(
                      Icons.verified_user_outlined,
                      size: 28,
                      color: Colors.blue.shade700,
                    ),
                    const SizedBox(width: AppResponsive.spaceSM),
                    Text(
                      "Doctor Verification Portal",
                      style: TextStyle(
                        fontSize: AppResponsive.fontXL(context),
                        fontWeight: AppResponsive.semiBold,
                      ),
                    )
                  ],
                ),

                const SizedBox(height: AppResponsive.spaceXS),

                Text(
                  "Verify doctor credentials using National Medical Register (NMR) ID",
                  style: TextStyle(
                    fontSize: AppResponsive.fontSM(context),
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: AppResponsive.spaceXL),

                Text(
                  "NMR ID / Registration Number",
                  style: TextStyle(
                    fontSize: AppResponsive.fontMD(context),
                    fontWeight: AppResponsive.medium,
                  ),
                ),

                const SizedBox(height: AppResponsive.spaceSM),

                /// ------------------------------------------------------------
                /// RESPONSIVE INPUT + BUTTON
                /// Mobile → Column
                /// Tablet → Row
                /// Desktop → Row
                /// ------------------------------------------------------------
                if (isMobile)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomInputField(
                        labelText: "Enter NMR ID (e.g., NMR12345678)",
                        icon: Icons.badge_outlined,
                        controller: nmrController,
                        inputType: TextInputType.text,
                      ),
                      const SizedBox(height: AppResponsive.spaceMD),
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          text: "Verify",
                          icon: Icons.search,
                          onPressed: () {
                            debugPrint("Entered: ${nmrController.text}");
                          },
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: CustomInputField(
                          labelText: "Enter NMR ID (e.g., NMR12345678)",
                          icon: Icons.badge_outlined,
                          controller: nmrController,
                          inputType: TextInputType.text,
                        ),
                      ),
                      const SizedBox(width: AppResponsive.spaceMD),
                      SizedBox(
                        width: isTablet ? 140 : 170, // Slightly bigger on desktop
                        child: CustomButton(
                          text: "Verify",
                          icon: Icons.search,
                          onPressed: () {
                            debugPrint("Entered: ${nmrController.text}");
                          },
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
