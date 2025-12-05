import 'package:flutter/material.dart';
import 'package:healthcare_plus/utils/app_responsive.dart';
import 'package:healthcare_plus/widgets/custom_button.dart';
import '../../../widgets/switch_on_off.dart';

class NotificationsTab extends StatefulWidget {
  const NotificationsTab({super.key});

  @override
  State<NotificationsTab> createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab> {
  // State variables for notifications
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _pushNotifications = true;
  bool _weeklyReports = true;
  bool _monthlyReports = true;
  bool _alertLowEngagement = true;
  bool _alertHighRisk = true;

  // State variable for dropdown
  String _reminderFrequency = "Weekly";

  @override
  Widget build(BuildContext context) {
    final bool isMobile = AppResponsive.isMobile(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.notifications_none, size: 24, color: Colors.grey[700]),
              const SizedBox(width: 10),
              const Text(
                "Notification Preferences",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          _buildDirectSwitch(
            "Email Notifications",
            "Send notifications via email",
            _emailNotifications,
            (val) => setState(() => _emailNotifications = val),
          ),
          _buildDirectSwitch(
            "SMS Notifications",
            "Send notifications via SMS",
            _smsNotifications,
            (val) => setState(() => _smsNotifications = val),
          ),
          _buildDirectSwitch(
            "Push Notifications",
            "Send push notifications to mobile app",
            _pushNotifications,
            (val) => setState(() => _pushNotifications = val),
          ),
          _buildDirectSwitch(
            "Weekly Reports",
            "Receive weekly wellness reports",
            _weeklyReports,
            (val) => setState(() => _weeklyReports = val),
          ),
          _buildDirectSwitch(
            "Monthly Reports",
            "Receive monthly wellness reports",
            _monthlyReports,
            (val) => setState(() => _monthlyReports = val),
          ),
          _buildDirectSwitch(
            "Alert on Low Engagement",
            "Get notified when employee engagement drops",
            _alertLowEngagement,
            (val) => setState(() => _alertLowEngagement = val),
          ),
          _buildDirectSwitch(
            "Alert on High Risk Employees",
            "Get notified about employees with high health risks",
            _alertHighRisk,
            (val) => setState(() => _alertHighRisk = val),
          ),

          const SizedBox(height: 16),
          // Dropdown
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Reminder Frequency",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _reminderFrequency,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFF2563EB),
                        width: 2,
                      ),
                    ),
                  ),
                  items: ["Daily", "Weekly", "Monthly"].map((String val) {
                    return DropdownMenuItem(value: val, child: Text(val));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _reminderFrequency = val);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
          CustomButton(
            text: "Save Notification",
            width: isMobile ? double.infinity : 200,
            onPressed: () => {},
          ),
        ],
      ),
    );
  }

  Widget _buildDirectSwitch(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Reusing the custom On/Off toggle
          OnOffSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
