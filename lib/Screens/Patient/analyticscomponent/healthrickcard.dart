import 'package:flutter/material.dart';
import 'package:healthcare_plus/utils/app_responsive.dart';

// ... (Include your AppResponsive class here if in the same file, 
// or import it if it is in a separate file)

class HealthRiskCard extends StatelessWidget {
  const HealthRiskCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = AppResponsive.isDesktop(context);
    final isMobile = AppResponsive.isMobile(context);

    return Container(
      width: double.infinity,
      // Use dynamic padding based on screen size
      padding: EdgeInsets.all(
        isMobile ? AppResponsive.spaceMD : AppResponsive.spaceLG,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        // Use defined radius
        borderRadius: BorderRadius.circular(AppResponsive.radiusMD),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Header ---
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded, 
                color: Colors.grey.shade800, 
                // Slightly larger icon on desktop
                size: isDesktop ? 26 : 22,
              ),
              const SizedBox(width: AppResponsive.spaceSM),
              Text(
                "Health Risk Predictions",
                style: TextStyle(
                  // Dynamic Font Size
                  fontSize: AppResponsive.fontLG(context),
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppResponsive.spaceXS),
          Text(
            "AI-powered predictions based on your health data",
            style: TextStyle(
              fontSize: AppResponsive.fontXS(context),
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: AppResponsive.spaceLG),

          // --- Content Layout ---
          // Use ResponsiveBuilder or simple if-check to change layout direction
          if (isDesktop)
            _buildDesktopLayout(context)
          else
            _buildMobileLayout(context),
        ],
      ),
    );
  }

  /// Layout for Mobile and Tablet (Vertical Stack)
  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        _buildCardioItem(context),
        const SizedBox(height: AppResponsive.spaceMD),
        _buildDiabetesItem(context),
      ],
    );
  }

  /// Layout for Desktop (Side-by-Side)
  Widget _buildDesktopLayout(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildCardioItem(context)),
          const SizedBox(width: AppResponsive.spaceMD),
          Expanded(child: _buildDiabetesItem(context)),
        ],
      ),
    );
  }

  // Extracted specific items to keep build clean
  Widget _buildCardioItem(BuildContext context) {
    return _buildRiskItem(
      context: context,
      title: "Cardiovascular Risk",
      description: "Based on your current health metrics, you have a low risk of cardiovascular issues.",
      riskLabel: "low risk (15%)",
      isLowRisk: true,
      recommendations: [
        "Maintain regular exercise",
        "Continue healthy diet",
        "Monitor blood pressure",
      ],
    );
  }

  Widget _buildDiabetesItem(BuildContext context) {
    return _buildRiskItem(
      context: context,
      title: "Diabetes Risk",
      description: "Your family history and BMI indicate moderate diabetes risk.",
      riskLabel: "medium risk (35%)",
      isLowRisk: false,
      recommendations: [
        "Reduce sugar intake",
        "Increase physical activity",
        "Regular blood sugar monitoring",
      ],
    );
  }

  Widget _buildRiskItem({
    required BuildContext context,
    required String title,
    required String description,
    required String riskLabel,
    required bool isLowRisk,
    required List<String> recommendations,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppResponsive.spaceMD),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(AppResponsive.radiusSM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Row with Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start, // Align top for multiline titles
            children: [
              // Wrapped in Expanded to prevent overflow on small mobile screens
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: AppResponsive.fontMD(context),
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: AppResponsive.spaceSM),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isLowRisk ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  riskLabel,
                  style: TextStyle(
                    fontSize: AppResponsive.fontXS(context),
                    fontWeight: FontWeight.bold,
                    color: isLowRisk ? const Color(0xFF16A34A) : const Color(0xFFD97706),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppResponsive.spaceSM),
          
          // Description
          Text(
            description,
            style: TextStyle(
              fontSize: AppResponsive.fontSM(context),
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
          
          const SizedBox(height: AppResponsive.spaceMD),
          
          // Recommendations Header
          Text(
            "Recommendations:",
            style: TextStyle(
              fontSize: AppResponsive.fontSM(context),
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: AppResponsive.spaceSM),
          
          // Recommendations List
          ...recommendations.map((rec) => Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("• ", style: TextStyle(color: Colors.grey, fontSize: AppResponsive.fontSM(context))),
                Expanded(
                  child: Text(
                    rec,
                    style: TextStyle(
                      fontSize: AppResponsive.fontSM(context),
                      color: Colors.grey.shade600
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}