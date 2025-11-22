import 'package:flutter/material.dart';
import '../../widgets/custom_header.dart';
import '../../utils/app_responsive.dart';

// Import the new component
import '../../widgets/custom_support_tab_toggle.dart';

// Import your setting screens
import 'settingscomponents/profile_settings.dart';
import 'settingscomponents/availability_settings.dart';
import 'settingscomponents/notification_settings.dart';
import 'settingscomponents/billing_settings.dart';
import 'settingscomponents/security_settings.dart';

class SettingsComponent extends StatefulWidget {
  const SettingsComponent({super.key});

  @override
  State<SettingsComponent> createState() => _SettingsComponentState();
}

class _SettingsComponentState extends State<SettingsComponent> {
  int selectedTab = 0;

  final List<String> tabs = [
    "Profile",
    "Availability",
    "Notifications",
    "Billing",
    "Security",
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppResponsive.pagePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            title: "Provider Settings",
            subtitle: "Manage your professional profile and preferences",
          ),


          /// ⭐ THE NEW TAB COMPONENT
          SupportTabsToggle(
            tabs: tabs,
            selectedIndex: selectedTab,
            onSelected: (index) {
              setState(() => selectedTab = index);
            },
          ),

          const SizedBox(height: 28),

          /// ⭐ SWITCHING SCREENS
          // Using IndexedStack or a simple switch preserves state better,
          // but your current if-statement approach works fine too.
          _buildSelectedSettings(),
        ],
      ),
    );
  }

  // Helper widget to keep the build method clean
  Widget _buildSelectedSettings() {
    switch (selectedTab) {
      case 0: return const ProfileSettings();
      case 1: return const AvailabilitySettings();
      case 2: return const NotificationSettings();
      case 3: return const BillingSettings();
      case 4: return const SecuritySettings();
      default: return const ProfileSettings();
    }
  }
}