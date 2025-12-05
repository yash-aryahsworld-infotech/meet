
import 'package:flutter/material.dart';
import './reschedule_appoinment.dart';
class AppointmentCard extends StatelessWidget {
  final Map<String, dynamic> appointment;
  final VoidCallback? onCancel; 

  const AppointmentCard({super.key, required this.appointment, this.onCancel});

  @override
  Widget build(BuildContext context) {
    final bool isUpcoming = appointment['isUpcoming'] ?? false;
    final String type = appointment['type'] ?? "Clinic";
    final bool isOnline = type == "Online";
    final String? imagePath = appointment['image'];
    final String name = appointment['name'] ?? "Unknown";

    // Styling
    Color typeColor = isOnline ? Colors.green.shade700 : Colors.purple.shade700;
    Color typeBg = isOnline ? Colors.green.shade50 : Colors.purple.shade50;
    IconData typeIcon = isOnline ? Icons.videocam : Icons.location_on;
    String typeText = isOnline ? "Online Consultant" : "Clinic Visit";

    // Fallback Image
    ImageProvider imgProvider;
    if (imagePath != null && imagePath.isNotEmpty) {
      imgProvider = NetworkImage(imagePath);
    } else {
      // Generate UI Avatar
      final safeName = Uri.encodeComponent(name);
      imgProvider = NetworkImage("https://ui-avatars.com/api/?name=$safeName&background=random");
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- 1. Top Section (Image & Details) ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue.shade50,
                  // foregroundImage sits on top of child.
                  foregroundImage: imgProvider,
                  onForegroundImageError: (exception, stackTrace) {
                    // This callback catches 404s or invalid assets, 
                    // preventing the app from crashing and letting the child Icon show.
                  },
                  // The child (Icon) shows if image is null or fails to load
                  child: const Icon(Icons.person, color: Colors.blue, size: 30),
                ),
                
                const SizedBox(width: 16),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: typeBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(typeIcon, size: 14, color: typeColor),
                                const SizedBox(width: 6),
                                Text(
                                  typeText,
                                  style: TextStyle(color: typeColor, fontWeight: FontWeight.w600, fontSize: 12),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Text(
                        appointment['specialty'] ?? "Specialist", 
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13)
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.calendar_today, size: 14, color: Colors.blue.shade700),
                            const SizedBox(width: 8),
                            Text(
                              "${appointment['date']}  •  ${appointment['time']}",
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),

            // --- 2. Action Buttons Row (Only for Upcoming) ---
            if (isUpcoming) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Divider(height: 1),
              ),
              Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onCancel, // Trigger Callback
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: BorderSide(color: Colors.red.shade100),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text("Cancel", style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Reschedule (Visual only for now)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true, // Allow sheet to take up more height
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) => SizedBox(
                            // Limit height to 85% of screen
                            height: MediaQuery.of(context).size.height * 0.85,
                            child: RescheduleBottomSheet(appointment: appointment),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey.shade700,
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text("Reschedule", style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Join/Directions
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isOnline ? Colors.green.shade600 : Colors.blue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        isOnline ? "Join" : "Join",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              )
            ]
          ],
        ),
      ),
    );
  }
}