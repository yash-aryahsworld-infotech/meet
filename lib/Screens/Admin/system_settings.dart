import 'package:flutter/material.dart';
import 'package:healthcare_plus/Screens/Admin/settings/backup_tab.dart';
import 'package:healthcare_plus/Screens/Admin/settings/general_tab.dart';
import 'package:healthcare_plus/Screens/Admin/settings/security_tab.dart';
import 'package:healthcare_plus/Screens/Admin/settings/users_tab.dart';

// Adjust these import paths to match where you saved your files
import 'package:healthcare_plus/widgets/custom_header.dart'; // Your PageHeader
import 'package:healthcare_plus/widgets/custom_support_tab_toggle.dart';
import '../../widgets/switch_on_off.dart'; // Your Switch Component

class SystemSettingsPage extends StatefulWidget {
  const SystemSettingsPage({super.key});

  @override
  State<SystemSettingsPage> createState() => _SystemSettingsPageState();
}

class _SystemSettingsPageState extends State<SystemSettingsPage> {
  int _currentTabIndex = 0;

  final List<String> _tabs = [
    "General",
    "Security",
    "Notifications",
    "Backup & Maintenance",
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          children: [
            // 1. Header
            PageHeader(
              title: "System Settings",
              button1OnPressed: () {},
              button1Text: "Reset to Default",
              button2OnPressed: () {},
              button2Text: "Save Changes",
            ),

            const SizedBox(height: 20),

            // 2. Tabs Toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SupportTabsToggle(
                tabs: _tabs,
                selectedIndex: _currentTabIndex,
                onSelected: (index) {
                  setState(() {
                    _currentTabIndex = index;
                  });
                },
              ),
            ),

            const SizedBox(height: 24),

            // 3. Dynamic Content Area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildCurrentTabContent(),
            ),

            const SizedBox(height: 50), // Bottom padding
          ],
        ),
      );
  }

  Widget _buildCurrentTabContent() {
    switch (_currentTabIndex) {
      case 0:
        return GeneralConfigurationCard();
      case 1:
        return SecuritySettingsCard();
      case 2:
        return NotificationSettingsCard();
      case 3:
        return BackupMaintenanceCard();
      default:
        return GeneralConfigurationCard();
    }
  }
}
