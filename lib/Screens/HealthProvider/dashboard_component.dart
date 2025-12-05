import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart'; // Import Firebase
import 'package:healthcare_plus/utils/app_responsive.dart';

import "../../widgets/header_section.dart";
import "./stats_section.dart";
import "../../widgets/schedule_section.dart";
import "../../widgets/earnings_section.dart";
import "../../widgets/quick_actions_section.dart";
import "../../widgets/patient_overview_section.dart";

class HealthProviderDashboard extends StatefulWidget {
  const HealthProviderDashboard({super.key});

  @override
  State<HealthProviderDashboard> createState() => _HealthProviderDashboardState();
}

class _HealthProviderDashboardState extends State<HealthProviderDashboard> {
  // 1. Variable to store the fetched name
  String _doctorName = "Loading..."; 
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _loadDoctorProfile();
  }

  /// 2. Fetch UserKey from Prefs -> Then Fetch Name from Firebase
  Future<void> _loadDoctorProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Get the keys saved during login
      final String? userKey = prefs.getString("userKey");
      final String? userRole = prefs.getString("userRole") ?? "providers"; // Default to providers

      if (userKey == null || userKey.isEmpty) {
        if (mounted) setState(() => _doctorName = "Dr. Guest");
        return;
      }

      // 3. Query Firebase: healthcare/users/providers/{userKey}
      final snapshot = await _dbRef.child("healthcare/users/$userRole/$userKey").get();

      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        
        // Handle potential different key names (camelCase vs snake_case) based on your data
        final String fName = data["firstName"] ?? data["first_name"] ?? "Doctor";
        final String lName = data["lastName"] ?? data["last_name"] ?? "";

        if (mounted) {
          setState(() {
            _doctorName = "Dr. $fName $lName"; // e.g., "Dr. Amit Pandey"
          });
        }
      }
    } catch (e) {
      debugPrint("Error loading name: $e");
      if (mounted) setState(() => _doctorName = "Dr. Unknown");
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = AppResponsive.isMobile(context);
    final bool isTablet = AppResponsive.isTablet(context);
    final bool isDesktop = AppResponsive.isDesktop(context);

    // 4. Wrapped in SingleChildScrollView for Mobile Responsiveness
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
      child: MaxWidthContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 5. Pass the fetched name to the Header
            HeaderSection(
              doctorName: _doctorName, 
              appointmentsToday: 12,
              isOnline: true,
            ),

            const SizedBox(height: 20),

            const StatsSection(),
            const SizedBox(height: 20),

            /// --------------------------------------------------------
            /// RESPONSIVE LAYOUT
            /// --------------------------------------------------------
            if (isMobile) ...[
              /// ---------------------- MOBILE ----------------------
              const ScheduleSection(),
              const SizedBox(height: 16),
              const EarningsSection(),
              const SizedBox(height: 16),
              const QuickActionsSection(),
              const SizedBox(height: 16),
              const PatientOverviewSection(),
              // Bottom padding for mobile scrolling
              const SizedBox(height: 80), 
            ]

            else if (isTablet) ...[
              /// ---------------------- TABLET ----------------------
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Expanded(child: ScheduleSection()),
                  SizedBox(width: 20),
                  Expanded(child: EarningsSection()),
                ],
              ),
              const SizedBox(height: 20),
              const QuickActionsSection(),
              const SizedBox(height: 20),
              const PatientOverviewSection(),
            ]

            else if (isDesktop) ...[
              /// ---------------------- DESKTOP ----------------------
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Expanded(flex: 7, child: ScheduleSection()),
                  SizedBox(width: 20),
                  Expanded(flex: 5, child: EarningsSection()),
                ],
              ),

              const SizedBox(height: 25),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  // Improved Desktop layout
                  Spacer(flex: 7),
                
                  Expanded(flex: 5, child: QuickActionsSection()),
                ],
              ),  
              const SizedBox(height: 20),
              const PatientOverviewSection()
            ],
          ],
        ),
      ),
    );
  }
}