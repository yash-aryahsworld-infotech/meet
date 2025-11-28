import 'package:flutter/material.dart';
import 'package:healthcare_plus/Screens/Corporate/dashboard/analytics_card.dart';
import 'package:healthcare_plus/Screens/Corporate/dashboard/gradient_header_card.dart';
import 'package:healthcare_plus/Screens/Corporate/dashboard/insights_card.dart';
import 'package:healthcare_plus/Screens/Corporate/dashboard/quick_actions_card.dart';
import 'package:healthcare_plus/Screens/Corporate/dashboard/roi_card.dart';
import 'package:healthcare_plus/Screens/Corporate/dashboard/wellness_list_section.dart';
import './dashboard/stats_section.dart';
class CorporateDashboard extends StatelessWidget {
  const CorporateDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // --- DYNAMIC DATA CONFIGURATION ---
    final dashboardData = {
      "companyName": "TechCorp India",
      "totalEmployees": "250",
      "stats": [
        {
          "title": "Enrolled",
          "value": "238",
          "subtitle": "95% of workforce",
          "icon": Icons.people_outline,
          "color": Colors.blue,
        },
        {
          "title": "Cost Savings",
          "value": "₹4.2L",
          "subtitle": "vs last quarter",
          "icon": Icons.currency_rupee,
          "color": Colors.green,
        },
        {
          "title": "Active Programs",
          "value": "8",
          "subtitle": "2 launching soon",
          "icon": Icons.monitor_heart_outlined,
          "color": Colors.orange,
        },
        {
          "title": "Engagement",
          "value": "78%",
          "subtitle": "monthly average",
          "icon": Icons.donut_large,
          "color": Colors.purple,
        },
      ],
      "programs": [
        {
          "name": "Annual Health Checkups",
          "enrolled": "145",
          "total": "250",
          "progress": 0.58,
          "status": "active",
          "statusColor": Colors.blue,
          "showButton": true,
          "completion": "58%",
        },
        {
          "name": "Mental Health Workshop",
          "enrolled": "87",
          "total": "250",
          "progress": 0.35,
          "status": "scheduled",
          "statusColor": Colors.grey,
          "showButton": false,
          "completion": "35%",
        },
        {
          "name": "Fitness Challenge Q1",
          "enrolled": "203",
          "total": "250",
          "progress": 0.81,
          "status": "completed",
          "statusColor": Colors.grey,
          "showButton": false,
          "completion": "81%",
        },
      ],
      "analytics": [
        {
          "label": "Healthcare Utilization",
          "value": "67%",
          "change": "+12%",
          "isPositive": true,
        },
        {
          "label": "Avg. Claims per Employee",
          "value": "₹18,500",
          "change": "-8%",
          "isPositive": true,
        },
        {
          "label": "Preventive Care Adoption",
          "value": "84%",
          "change": "+15%",
          "isPositive": true,
        },
        {
          "label": "Employee Satisfaction",
          "value": "4.2/5",
          "change": "+0.3",
          "isPositive": true,
        },
      ],
      "roi": {
        "investment": "₹12,50,000",
        "savings": "₹18,75,000",
        "gains": "₹8,25,000",
        "net": "116%",
      },
      "insights": [
        {
          "title": "High Engagement",
          "subtitle": "Mental health programs show 89% participation",
          "color": Colors.blue,
        },
        {
          "title": "Cost Reduction",
          "subtitle": "Preventive care reduced claims by 23%",
          "color": Colors.green,
        },
        {
          "title": "Action Needed",
          "subtitle": "Low participation in fitness programs",
          "color": Colors.orange,
        },
      ],
    };

    return Material(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // -------------------------------
            // HEADER SECTION (Only this part)
            // -------------------------------
            GradientHeaderCard(
              title: "TechCorp India - HR Dashboard",
              subtitle: "Employee wellness program overview and analytics",
              rightLabel: "Total Employees",
              rightValue: "250",
            ),



             
            const SizedBox(height: 20),
             const StatsSection(),

             const SizedBox(height: 20),
             

               LayoutBuilder(
                    builder: (context, constraints) {
                      // Desktop View (> 1100px)
                      bool isDesktop = constraints.maxWidth > 800;

                      if (isDesktop) {
                         return Column(
                          children: [
                            // Middle Row: Wellness (Left) + Analytics & Actions (Right)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: WellnessListSection(),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      AnalyticsCard(
                                        analytics:
                                            dashboardData['analytics'] as List,
                                      ),
                                      const SizedBox(height: 24),
                                      const QuickActionsCard(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            // Bottom Row: ROI + Insights (Side-by-side)
                            IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: ROICard(
                                      data: dashboardData['roi']
                                          as Map<String, dynamic>,
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  Expanded(
                                    child: InsightsCard(
                                      insights: dashboardData['insights'] as List,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        // MOBILE/TABLET VIEW (Stacked)
                        // Correct Order: Wellness -> Analytics -> Actions -> ROI -> Insights
                        return Column(
                          children: [
                            WellnessListSection(),
                            const SizedBox(height: 24),
                            AnalyticsCard(
                              analytics: dashboardData['analytics'] as List,
                            ),
                            const SizedBox(height: 24),
                            const QuickActionsCard(),
                            const SizedBox(height: 24),
                            ROICard(
                              data: dashboardData['roi']
                                  as Map<String, dynamic>,
                            ),
                            const SizedBox(height: 24),
                            InsightsCard(
                              insights: dashboardData['insights'] as List,
                            ),
                          ],
                        );
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
