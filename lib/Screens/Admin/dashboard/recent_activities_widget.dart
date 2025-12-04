import 'package:flutter/material.dart';

// --- DATA MODEL ---
class ActivityItem {
  final String title;
  final DateTime timestamp;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;

  ActivityItem({
    required this.title,
    required this.timestamp,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
  });
}

// --- WIDGET ---
class RecentActivitiesWidget extends StatelessWidget {
  final List<ActivityItem> activities;

  const RecentActivitiesWidget({super.key, required this.activities});

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
          children: [
            const Text(
              "Recent Activities",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "Latest system events and alerts",
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
            ),
            const SizedBox(height: 24),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activities.length,
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final activity = activities[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: activity.iconBgColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(activity.icon, size: 16, color: activity.iconColor),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${activity.timestamp.hour}:${activity.timestamp.minute}:${activity.timestamp.second}",
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}