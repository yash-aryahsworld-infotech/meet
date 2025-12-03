import 'package:flutter/material.dart';


// ==========================================
// 2. Notification Settings Component
// ==========================================
class NotificationSettingsCard extends StatefulWidget {
  const NotificationSettingsCard({super.key});

  @override
  State<NotificationSettingsCard> createState() => _NotificationSettingsCardState();
}

class _NotificationSettingsCardState extends State<NotificationSettingsCard> {
  bool _enableSystemNotifications = true;
  final List<String> _channels = ["Email", "SMS", "Push Notifications", "In-App"];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Notification Settings",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 24),

            // Toggle Switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Enable System Notifications", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                Switch(
                  value: _enableSystemNotifications,
                  onChanged: (v) => setState(() => _enableSystemNotifications = v),
                  activeColor: Colors.blue,
                  activeTrackColor: Colors.blue.withOpacity(0.4),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Chips Section
            const Text("Active Notification Channels", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _channels.map((channel) => _buildChip(channel)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200], // Light grey background for chips
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.grey[800], fontSize: 13, fontWeight: FontWeight.w500),
      ),
    );
  }
}
