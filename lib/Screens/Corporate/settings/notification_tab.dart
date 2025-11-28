import 'package:flutter/material.dart';

class NotificationsTab extends StatelessWidget {
  const NotificationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.notifications_none, size: 20, color: Colors.grey[700]),
              const SizedBox(width: 10),
              const Text(
                "Notification Preferences",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 24),

          _buildDirectSwitch("Email Notifications", "Send notifications via email", true),
          _buildDirectSwitch("SMS Notifications", "Send notifications via SMS", false),
          _buildDirectSwitch("Push Notifications", "Send push notifications to mobile app", true),
          _buildDirectSwitch("Weekly Reports", "Receive weekly wellness reports", true),
          _buildDirectSwitch("Monthly Reports", "Receive monthly wellness reports", true),
          _buildDirectSwitch("Alert on Low Engagement", "Get notified when employee engagement drops", true),
          _buildDirectSwitch("Alert on High Risk Employees", "Get notified about employees with high health risks", true),

          const SizedBox(height: 16),
          // Dropdown
          SizedBox(
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Reminder Frequency", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: "Weekly",
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.all(12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  items: ["Daily", "Weekly", "Monthly"].map((String val) {
                    return DropdownMenuItem(value: val, child: Text(val));
                  }).toList(),
                  onChanged: (val) {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Save Notification Settings"),
          ),
        ],
      ),
    );
  }

  Widget _buildDirectSwitch(String title, String subtitle, bool value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: (val) {},
            activeColor: const Color(0xFF2563EB),
          ),
        ],
      ),
    );
  }
}