import 'package:flutter/material.dart';
import 'package:healthcare_plus/Screens/Patient/near_by_healthcare.dart';
import 'package:healthcare_plus/utils/app_responsive.dart';
 // Ensure this path is correct
import './quick_action_card.dart';

class OverviewSection extends StatelessWidget {
  const OverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = AppResponsive.isMobile(context);

    // Quick action list data
    final List<Map<String, dynamic>> quickActions = [
      {"title": "Complete Health Setup", "icon": Icons.shield_outlined, "bg": const Color(0xFFE0EDFF), "text": const Color(0xFF1E40AF)},
      {"title": "Book Video Consultation", "icon": Icons.video_call_outlined, "bg": const Color(0xFFEFF6FF), "text": const Color(0xFF1D4ED8)},
      {"title": "AI Symptom Check", "icon": Icons.psychology_alt_outlined, "bg": const Color(0xFFE7FFF3), "text": const Color(0xFF0F9D58)},
      {"title": "Order Medicines", "icon": Icons.local_pharmacy_outlined, "bg": const Color(0xFFE7FBFF), "text": const Color(0xFF0891B2)},
      {"title": "Lab Tests", "icon": Icons.monitor_heart_outlined, "bg": const Color(0xFFF3E8FF), "text": const Color(0xFF6D28D9)},
      {"title": "Emergency Care", "icon": Icons.emergency_outlined, "bg": const Color(0xFFFFE4E4), "text": const Color(0xFFB91C1C)},
      {"title": "Maternal Care", "icon": Icons.favorite_border, "bg": const Color(0xFFFFE6F3), "text": const Color(0xFFD946EF)},
      {"title": "Child Health", "icon": Icons.child_care_outlined, "bg": const Color(0xFFE7EEFF), "text": const Color(0xFF1A56DB)},
      {"title": "Insurance", "icon": Icons.verified_user_outlined, "bg": const Color(0xFFFFF7E6), "text": const Color(0xFFCA8A04)},
      {"title": "Community", "icon": Icons.people_alt_outlined, "bg": const Color(0xFFF9FAFB), "text": const Color(0xFF374151)},
    ];

    return Column(
      children: [
        // ------------------------------------------
        // 1. QUICK ACTIONS CARD
        // ------------------------------------------
        Container(
          padding: EdgeInsets.all(isMobile ? 8 : 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.local_hospital_outlined, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    "Quick Actions",
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 20,
                      fontWeight: isMobile ? FontWeight.w500 : FontWeight.w700,
                      color: Colors.grey.shade900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: quickActions.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: AppResponsive.isMobile(context)
                      ? 2
                      : AppResponsive.isTablet(context)
                          ? 3
                          : 4,
                  mainAxisSpacing: 18,
                  crossAxisSpacing: 18,
                  childAspectRatio: AppResponsive.isMobile(context) ? 1.9 : 2.4,
                ),
                itemBuilder: (context, index) {
                  final item = quickActions[index];
                  return QuickActionCard(
                    title: item["title"],
                    icon: item["icon"],
                    bgColor: item["bg"],
                    textColor: item["text"],
                    onTap: () {},
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // ------------------------------------------
        // 2. INSIGHTS & ACTIVITY
        // ------------------------------------------
        if (isMobile) ...[
          // Mobile: Stacked vertically
          _buildHealthInsights(),
          const SizedBox(height: 24),
          // We pass 'true' so it gets a fixed height on mobile to prevent crash
          _buildRecentActivity(true), 
        ] else ...[
          // Desktop: Side-by-side equal height
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _buildHealthInsights()),
                const SizedBox(width: 24),
                // We pass 'false' so it has no fixed height and stretches with parent
                Expanded(child: _buildRecentActivity(false)), 
              ],
            ),
          ),
        ],

        const SizedBox(height: 30),

        // ------------------------------------------
        // 3. NEARBY PROVIDERS (Top 3)
        // ------------------------------------------
        NearbyHealthcare(),
      ],
    );
  }

  // ------------------------------------------
  // WIDGET: AI Health Insights
  // ------------------------------------------
  Widget _buildHealthInsights() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.psychology_outlined, size: 22),
              const SizedBox(width: 8),
              Text(
                "AI Health Insights",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInsightItem(
            title: "Excellent Progress",
            description: "Your vital signs are stable and within healthy ranges.",
            icon: Icons.check_circle_outline,
            bgColor: const Color(0xFFF0FDF4),
            borderColor: const Color(0xFFDCFCE7),
            textColor: const Color(0xFF16A34A),
          ),
          const SizedBox(height: 16),
          _buildInsightItem(
            title: "Preventive Care Due",
            description: "Schedule your annual health checkup.",
            icon: Icons.warning_amber_rounded,
            bgColor: const Color(0xFFFFFBEB),
            borderColor: const Color(0xFFFEF3C7),
            textColor: const Color(0xFFD97706),
          ),
          const SizedBox(height: 16),
          _buildInsightItem(
            title: "Wellness Opportunity",
            description: "Join our stress management program.",
            icon: Icons.trending_up,
            bgColor: const Color(0xFFEFF6FF),
            borderColor: const Color(0xFFDBEAFE),
            textColor: const Color(0xFF2563EB),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------
  // WIDGET: Recent Activity
  // ------------------------------------------
  Widget _buildRecentActivity(bool isMobile) {
    return Container(
      // CRITICAL FIX: Give fixed height on mobile, flexible on desktop
      height: isMobile ? 400 : null,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.access_time, size: 22),
              const SizedBox(width: 8),
              Text(
                "Recent Activity",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade900,
                ),
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.description_outlined, size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text("No recent activity", style: TextStyle(color: Colors.grey.shade500, fontSize: 16)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1D4ED8),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Start Health Check", style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem({
    required String title,
    required String description,
    required IconData icon,
    required Color bgColor,
    required Color borderColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: textColor),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 28.0),
            child: Text(description, style: TextStyle(color: Colors.grey.shade600, height: 1.5, fontSize: 14)),
          ),
        ],
      ),
    );
  }
}