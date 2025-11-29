import 'package:flutter/material.dart';
import 'package:healthcare_plus/Screens/Corporate/settings/company_info_tab.dart';
import 'package:healthcare_plus/Screens/Corporate/settings/healthwellness_tab.dart';
import 'package:healthcare_plus/Screens/Corporate/settings/notification_tab.dart';
import 'package:healthcare_plus/Screens/Corporate/settings/privacy_security_tab.dart';
import 'package:healthcare_plus/widgets/custom_support_tab_toggle.dart';
// Ensure you import the new TabToggle file

class CorporateSettingsPage extends StatefulWidget {
  const CorporateSettingsPage({super.key});

  @override
  State<CorporateSettingsPage> createState() => _CorporateSettingsPageState();
}

class _CorporateSettingsPageState extends State<CorporateSettingsPage> {
  int _selectedTab = 0;

  final List<String> _tabs = [
    "Company Info",
    "Health & Wellness",
    "Notifications",
    "Privacy & Security",
  ];

  @override
  Widget build(BuildContext context) {
    return Material(// Light gray background
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Corporate Settings",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 24),

            // Use the Reusable TabToggle
          SupportTabsToggle(
              tabs: _tabs,
              selectedIndex: _selectedTab,
              onSelected: (index) {
                setState(() {
                  _selectedTab = index;
                });
              },
            ),
            
            const SizedBox(height: 24),

            // Tab Content
            if (_selectedTab == 0) const CompanyInfoTab(),
            if (_selectedTab == 1) const HealthWellnessTab(),
            if (_selectedTab == 2) const NotificationsTab(),
            if (_selectedTab == 3) const PrivacySecurityTab(),
          ],
        ),
      ),
    );
  }
}