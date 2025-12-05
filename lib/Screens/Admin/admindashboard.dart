import 'package:flutter/material.dart';

// Ensure these imports point to where you actually saved the files
import 'package:healthcare_plus/Screens/Admin/dashboard/data_populate_widget.dart';
import 'package:healthcare_plus/Screens/Admin/dashboard/quick_actions_widget.dart';
import 'package:healthcare_plus/Screens/Admin/dashboard/recent_activities_widget.dart';
import 'package:healthcare_plus/Screens/Admin/dashboard/security_monitor.dart';
import 'package:healthcare_plus/Screens/Admin/dashboard/system_metrics_widget.dart';
import 'package:healthcare_plus/Screens/Admin/dashboard/user_growth_line_chart.dart';
import 'package:healthcare_plus/Screens/Admin/dashboard/weekly_appointment_chart.dart';
import 'package:healthcare_plus/widgets/custom_header.dart';
import './dashboard/stats_section.dart';

class AdminDashboard extends StatelessWidget {
  AdminDashboard({super.key});

  // --- 1. CHARTS DATA ---
  final List<LineDataPoint> lineData = [
    LineDataPoint(0, 1200, 50),
    LineDataPoint(1, 1450, 60),
    LineDataPoint(2, 1700, 70),
    LineDataPoint(3, 1950, 80),
    LineDataPoint(4, 2200, 90),
    LineDataPoint(5, 2400, 95),
  ];

  final List<BarDataPoint> barData = [
    BarDataPoint(0, 45, 38), // Mon
    BarDataPoint(1, 52, 45), // Tue
    BarDataPoint(2, 48, 41), // Wed
    BarDataPoint(3, 61, 54), // Thu
    BarDataPoint(4, 55, 49), // Fri
    BarDataPoint(5, 35, 30), // Sat
    BarDataPoint(6, 28, 25), // Sun
  ];

  // --- 2. SECURITY LOGS DATA ---
  final List<SecurityLog> demoLogs = [
    SecurityLog(
      level: "INFO",
      title: "Sign In Success",
      timestamp: DateTime.now(),
      ipAddress: "110.226.181.10",
      jsonDetails: {
        "email": "ch***@gmail.com",
        "event": "SIGNED_IN",
        "success": true,
        "timestamp": DateTime.now().toIso8601String(),
      },
    ),
    SecurityLog(
      level: "INFO",
      title: "Sign In Success",
      timestamp: DateTime.now().subtract(const Duration(seconds: 1)),
      ipAddress: "110.226.181.10",
      jsonDetails: {
        "email": "user2@gmail.com",
        "event": "SIGNED_IN",
        "success": true,
      },
    ),
    SecurityLog(
      level: "INFO",
      title: "Role Switch Success",
      timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
      jsonDetails: {
        "oldRole": "USER",
        "newRole": "ADMIN",
      },
    ),
    SecurityLog(
      level: "LOW",
      title: "Role Switch Attempt",
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      jsonDetails: {
        "user": "unknown",
        "reason": "unauthorized",
      },
    ),
  ];

  // --- 3. METRICS DATA ---
  final List<SystemMetric> metrics = [
    SystemMetric(
      label: "Server Uptime",
      value: "99.9%",
      valueColor: Colors.green.shade700,
      valueBgColor: Colors.green.shade50,
      icon: Icons.dns_outlined,
    ),
    SystemMetric(
      label: "DB Connections",
      value: "15/50",
      valueColor: Colors.grey.shade800,
      valueBgColor: Colors.grey.shade200,
      icon: Icons.storage_outlined,
    ),
    SystemMetric(
      label: "Security Status",
      value: "Secure",
      valueColor: Colors.green.shade700,
      valueBgColor: Colors.green.shade50,
      icon: Icons.shield_outlined,
    ),
  ];

  final List<SecurityCheckItem> securityChecks = [
    SecurityCheckItem("RLS Policies Active", true),
    SecurityCheckItem("Audit Logging Enabled", true),
    SecurityCheckItem("Rate Limiting Active", true),
    SecurityCheckItem("Password Protection Pending", false),
  ];

  // --- 4. QUICK ACTIONS DATA (Fixed Initialization) ---
  final List<QuickActionItem> actions = [
    QuickActionItem("Manage Users", Icons.people_outline, () {}),
    QuickActionItem("Review Providers", Icons.assignment_ind_outlined, () {}),
    QuickActionItem("Security Scan", Icons.security_outlined, () {}),
    QuickActionItem("Database Backup", Icons.backup_outlined, () {}),
    QuickActionItem("System Health Check", Icons.monitor_heart_outlined, () {}),
  ];

  // --- 5. ACTIVITIES DATA ---
  final List<ActivityItem> activities = [
    ActivityItem(
      title: "New patient registered",
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      icon: Icons.person_add_outlined,
      iconColor: Colors.blue,
      iconBgColor: Colors.blue.shade50,
    ),
    ActivityItem(
      title: "Provider verification completed",
      timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
      icon: Icons.verified_user_outlined,
      iconColor: Colors.green,
      iconBgColor: Colors.green.shade50,
    ),
    ActivityItem(
      title: "High database load detected",
      timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
      icon: Icons.warning_amber_rounded,
      iconColor: Colors.orange,
      iconBgColor: Colors.orange.shade50,
    ),
    ActivityItem(
      title: "Appointment booking surge detected",
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      icon: Icons.trending_up,
      iconColor: Colors.blue,
      iconBgColor: Colors.blue.shade50,
    ),
    ActivityItem(
      title: "Security scan completed successfully",
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      icon: Icons.check_circle_outline,
      iconColor: Colors.green,
      iconBgColor: Colors.green.shade50,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
        // Wraps everything in a scroll view
        child: Column(
          children: [
            const PageHeader(
              title: "System Administrator",
              subtitle: "Monitor and manage the healthcare platform",
            ),
            const SizedBox(height: 20),

            const StatsSection(),
            const SizedBox(height: 20),

            // --- SECTION 1: CHARTS ---
            LayoutBuilder(
              builder: (context, constraints) {
                // Stack on mobile (< 800), Row on desktop
                if (constraints.maxWidth < 800) {
                  return Column(
                    children: [
                      UserGrowthLineChart(data: lineData),
                      const SizedBox(height: 16),
                      WeeklyAppointmentBarChart(data: barData),
                    ],
                  );
                } else {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: UserGrowthLineChart(data: lineData)),
                      const SizedBox(width: 16),
                      Expanded(child: WeeklyAppointmentBarChart(data: barData)),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 20),

            // --- SECTION 2: SECURITY & POPULATOR ---
            LayoutBuilder(
              builder: (context, constraints) {
                // Stack on mobile (< 900), Row on desktop
                if (constraints.maxWidth < 900) {
                  return Column(
                    children: [
                      SecurityMonitorWidget(logs: demoLogs),
                      const SizedBox(height: 16),
                      const DemoDataPopulatorWidget(),
                    ],
                  );
                } else {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: SecurityMonitorWidget(logs: demoLogs),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        flex: 2,
                        child: DemoDataPopulatorWidget(),
                      ),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 20),

            // --- SECTION 3: METRICS, ACTIONS, ACTIVITIES ---
          // --- SECTION 3: METRICS, ACTIONS, ACTIVITIES ---
            LayoutBuilder(
              builder: (context, constraints) {
                // Stack on mobile (< 1100), Row on desktop
                if (constraints.maxWidth < 1100) {
                  return Column(
                    children: [
                      SystemMetricsWidget(
                          metrics: metrics, checklist: securityChecks),
                      const SizedBox(height: 16),
                      QuickActionsWidget(actions: actions),
                      const SizedBox(height: 16),
                      RecentActivitiesWidget(activities: activities),
                    ],
                  );
                } else {
                  return Row(
                    // Changed from stretch to start to prevent height calculation errors
                    crossAxisAlignment: CrossAxisAlignment.start, 
                    children: [
                      Expanded(
                        child: SystemMetricsWidget(
                            metrics: metrics, checklist: securityChecks),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: QuickActionsWidget(actions: actions),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: RecentActivitiesWidget(activities: activities),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      );
  }
}