import 'package:flutter/material.dart';
import 'package:healthcare_plus/Screens/Patient/dashboardcomponent/ai_triage_section.dart';
import 'package:healthcare_plus/Screens/Patient/dashboardcomponent/community_section.dart';
import 'package:healthcare_plus/Screens/Patient/dashboardcomponent/healthsummarysection.dart';
import 'package:healthcare_plus/Screens/Patient/dashboardcomponent/maternal_section.dart';
import 'package:healthcare_plus/Screens/Patient/dashboardcomponent/overview_section.dart';
import 'package:healthcare_plus/Screens/Patient/dashboardcomponent/pediatric_section.dart';
import '../Patient/dashboardcomponent/healthwelcomecard.dart';
import '../../widgets/custom_support_tab_toggle.dart';
import '../../utils/app_responsive.dart';

class PatientDashboard extends StatefulWidget {
  const PatientDashboard({super.key});

  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  int selectedTab = 0;

  final List<String> patientTabs = [
    "Overview",
    "Ai triage",
    "Maternal",
    "pediatric",
    "community",
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: MaxWidthContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HealthWelcomeCard(),
            const SizedBox(height: 20),

            const HealthSummarySection(),
            const SizedBox(height: 20),

            /// ⭐ Your New Support Toggle
            SupportTabsToggle(
              tabs: patientTabs,
              selectedIndex: selectedTab,
              onSelected: (index) {
                setState(() => selectedTab = index);
              },
            ),

            const SizedBox(height: 25),

            _buildPatientScreen(),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientScreen() {
    switch (selectedTab) {
      case 0:
        return const OverviewSection();
      case 1:
        return const AiTriageSection();
      case 2:
        return const MaternalSection();
      case 3:
        return const PediatricSection();
      case 4:
        return  CommunitySection();
      default:
        return const OverviewSection();
    }
  }
}
