import 'package:flutter/material.dart';

// Wrapper Widget
class AppointmentList extends StatelessWidget {
  final List<Map<String, dynamic>> appointments;
  final String emptyMsg;

  const AppointmentList({
    super.key,
    required this.appointments,
    required this.emptyMsg,
  });

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Text(
            emptyMsg,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        return AppointmentCard(appointment: appointments[index]);
      },
    );
  }
}

// Single Card Widget
class AppointmentCard extends StatelessWidget {
  final Map<String, dynamic> appointment;

  const AppointmentCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final bool isUpcoming = appointment['isUpcoming'] ?? false;
    final String type = appointment['type'] ?? "Clinic"; // Default to Clinic if null
    final bool isOnline = type == "Online";
    final String? imagePath = appointment['image'];

    // Styling Logic
    Color typeColor = isOnline ? Colors.green.shade700 : Colors.purple.shade700;
    Color typeBg = isOnline ? Colors.green.shade50 : Colors.purple.shade50;
    IconData typeIcon = isOnline ? Icons.videocam : Icons.location_on;
    String typeText = isOnline ? "Online Consultant" : "Clinic Visit";

    // Image Provider Logic
    ImageProvider? imgProvider;
    if (imagePath != null && imagePath.isNotEmpty) {
      if (imagePath.startsWith('http')) {
        imgProvider = NetworkImage(imagePath);
      } else {
        imgProvider = AssetImage(imagePath);
      }
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
                // ⭐ Updated Avatar with Error Handling
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
                          Text(
                            appointment['name'] ?? "Unknown Doctor",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Divider(height: 1),
            ),

            // --- 2. Action Buttons Row ---
            if (isUpcoming)
              // ---------------- UPCOMING LAYOUT ----------------
              Row(
                children: [
                  // 1. Cancel
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
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

                  // 2. Reschedule
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
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

                  // 3. Join / Directions
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
                        isOnline ? "Join" : "Directions",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              )
            else
              // ---------------- PAST LAYOUT ----------------
              Row(
                children: [
                  // 1. Receipt
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black87,
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text("Receipt", style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // 2. Prescription
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue.shade700,
                        backgroundColor: Colors.blue.shade50,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text("Prescription", style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // 3. Book Again
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text("Book Again", style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}