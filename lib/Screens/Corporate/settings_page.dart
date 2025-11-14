import 'package:flutter/material.dart';

class CorporateSettingsPage extends StatelessWidget {
  const CorporateSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Settings",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          _settingTile("Enable Notifications", Icons.notifications),
          _settingTile("Security Settings", Icons.security),
          _settingTile("Team Permissions", Icons.group),
        ],
      ),
    );
  }

  Widget _settingTile(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: _box(),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 30),
          const SizedBox(width: 16),
          Text(title, style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  BoxDecoration _box() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: const [
      BoxShadow(color: Colors.black12, blurRadius: 10)
    ],
  );
}

