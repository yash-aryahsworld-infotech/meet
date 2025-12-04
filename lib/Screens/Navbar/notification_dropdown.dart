import 'package:flutter/material.dart';

// TODO: Import your Profile Settings Page here
import '../../Screens/HealthProvider/settingscomponents/profile_settings.dart';

class NotificationDropdown extends StatelessWidget {
  const NotificationDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      child: Container(
        width: 320, 
        constraints: const BoxConstraints(maxHeight: 400),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header ---
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Notifications",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text("Mark all as read", style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1),

            // --- List of Notifications ---
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: [
                  _buildNotificationItem(
                    title: "Appointment Confirmed",
                    body: "Your check-up with Dr. Smith is set for 10:00 AM.",
                    time: "2 min ago",
                    isUnread: true,
                    icon: Icons.calendar_today,
                    color: Colors.blue,
                    onTap: () {
                       // Handle click for appointment
                    },
                  ),
                  _buildNotificationItem(
                    title: "Lab Results Ready",
                    body: "Your blood test results are now available.",
                    time: "1 hour ago",
                    isUnread: true,
                    icon: Icons.science,
                    color: Colors.purple,
                    onTap: () {},
                  ),
                  
                  // -------------------------------------------------------
                  // CHANGED: System Update -> Complete Your Profile
                  // -------------------------------------------------------
                  _buildNotificationItem(
                    title: "Complete Your Profile",
                    body: "Finish setting up your account to unlock full features.",
                    time: "1 day ago",
                    isUnread: false, // Usually false if it's a reminder
                    icon: Icons.person_outline, // Changed icon to Person
                    color: Colors.orange,
                    onTap: () {
                      // 1. Close the dropdown overlay first (optional)
                      // Navigator.of(context).pop(); 

                      // 2. Navigate to Profile Settings Page
                      // REPLACE 'ProfileSettingsPage()' with your actual page widget
                   
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfileSettings()),
                      );
                    
                      // print("Navigating to Profile Settings..."); // Debug print
                    },
                  ),
                ],
              ),
            ),
            
            // --- Footer ---
            const Divider(height: 1, thickness: 1),
            InkWell(
              onTap: () {},
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                alignment: Alignment.center,
                child: const Text(
                  "View All Notifications",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.blue),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Updated to include onTap
  Widget _buildNotificationItem({
    required String title,
    required String body,
    required String time,
    required bool isUnread,
    required IconData icon,
    required Color color,
    required VoidCallback onTap, // Added callback
  }) {
    return InkWell(
      onTap: onTap, // Handle the tap
      child: Container(
        color: isUnread ? Colors.blue.withValues(alpha: 0.05) : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isUnread ? FontWeight.w700 : FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    body,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isUnread)
              Container(
                margin: const EdgeInsets.only(left: 8, top: 4),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}