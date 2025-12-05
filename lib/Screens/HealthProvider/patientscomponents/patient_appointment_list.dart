
import 'package:flutter/material.dart';

class AppointmentModel {
  final String name;
  final String image;
  final String history; // Diagnosis/Reason
  final String time;
  final String gender;
  final int age;
  final String status;
  final String? appointmentId;
  final String? patientId;

  AppointmentModel({
    required this.name,
    required this.image,
    required this.history,
    required this.time,
    required this.gender,
    required this.age,
    required this.status,
    this.appointmentId,
    this.patientId,
  });
}

// =============================================================================
// ⭐ REUSABLE COMPONENT (The "One Component")
// =============================================================================
class PatientAppointmentList extends StatelessWidget {
  final List<AppointmentModel> appointments;

  const PatientAppointmentList({super.key, required this.appointments});

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return _emptyState();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // Main page scrolls
      itemCount: appointments.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final data = appointments[index];
        return _buildBookingCard(context, data);
      },
    );
  }

  Widget _buildBookingCard(BuildContext context, AppointmentModel data) {
    return Container(
      width: double.infinity,
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
      child: Column(
        children: [
          // ---------------- Top Section: Profile & Details ----------------
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.blue.shade50,
                  backgroundImage: AssetImage(data.image), // Use NetworkImage if URL
                  child: data.image.isEmpty 
                    ? Text(data.name[0], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue))
                    : null,
                ),
                const SizedBox(width: 16),
                
                // Info Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data.name,
                            style: const TextStyle(
                              fontSize: 16, 
                              fontWeight: FontWeight.w700,
                              color: Colors.black87
                            ),
                          ),
                          // Gender/Age Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "${data.gender}, ${data.age} yrs",
                              style: TextStyle(
                                fontSize: 11, 
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.history,
                        style: TextStyle(
                          fontSize: 13, 
                          color: Colors.grey.shade600,
                          height: 1.4
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ---------------- Divider ----------------
          Divider(height: 1, color: Colors.grey.shade100),

          // ---------------- Bottom Section: Time & Action ----------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Booking Time
                Icon(Icons.calendar_today_outlined, size: 16, color: Colors.blue.shade400),
                const SizedBox(width: 8),
                Text(
                  data.time,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                
                const Spacer(),

                // Video Call Button
                SizedBox(
                  height: 36,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Handle video call action
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Starting video call with ${data.name}...")),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Primary color
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    icon: const Icon(Icons.videocam_outlined, size: 18),
                    label: const Text(
                      "Video Call",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- Empty State Helper ----------------
  Widget _emptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.calendar_month_outlined, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            "No Bookings Found",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          Text(
            "No appointments scheduled in this category.",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}