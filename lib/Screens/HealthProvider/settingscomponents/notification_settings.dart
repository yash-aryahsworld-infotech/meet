import 'package:flutter/material.dart';
import '../../../widgets/custom_button.dart';
class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool emailNotif = true;
  bool smsNotif = true;
  bool pushNotif = true;
  bool marketingNotif = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          // Title
          const Text(
            "Notification Preferences",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 6),

          // Subtitle
          Text(
            "Choose how you want to be notified",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 28),

          // -------------------------------
          // EMAIL NOTIFICATIONS
          // -------------------------------          
          _toggleRow(
            title: "Email Notifications",
            subtitle:
                "Receive appointment confirmations and updates via email",
            value: emailNotif,
            onChanged: (v) => setState(() => emailNotif = v),
          ),

          const SizedBox(height: 22),

          // -------------------------------
          // SMS REMINDERS
          // -------------------------------
          _toggleRow(
            title: "SMS Reminders",
            subtitle:
                "Get text message reminders for upcoming appointments",
            value: smsNotif,
            onChanged: (v) => setState(() => smsNotif = v),
          ),

          const SizedBox(height: 22),

          // -------------------------------
          // PUSH NOTIFICATIONS
          // -------------------------------
          _toggleRow(
            title: "Push Notifications",
            subtitle:
                "Receive push notifications on your devices",
            value: pushNotif,
            onChanged: (v) => setState(() => pushNotif = v),
          ),

          const SizedBox(height: 22),

          // -------------------------------
          // MARKETING EMAILS
          // -------------------------------
          _toggleRow(
            title: "Marketing Emails",
            subtitle:
                "Receive updates about new features and promotions",
            value: marketingNotif,
            onChanged: (v) => setState(() => marketingNotif = v),
          ),

          const SizedBox(height: 30),

          // SAVE BUTTON
    // SAVE BUTTON
Align(
  alignment: Alignment.centerLeft,
  child: CustomButton(
    text: "Save Preferences",
    icon: Icons.save, // optional
    onPressed: () {
      // Your save logic here
    },

    // Optional button styling
    height: 48,
    width: 200,
    textColor: Colors.white,
    buttonPadding: const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 12,
    ),

    colors: const [
      Color(0xFF2196F3),
      Color(0xFF1565C0),
    ],
  ),
),

        ],
      ),
    );
  }

  // ---------------------------------------------------------------
  // 🔹 Reusable toggle row widget (left text + right switch)
  // ---------------------------------------------------------------
  Widget _toggleRow({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LEFT SIDE TEXT
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 10),

        // RIGHT SIDE SWITCH
        Switch(
          activeThumbColor: Colors.white,
          activeTrackColor: Colors.blue,
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
