
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:healthcare_plus/Screens/HealthProvider/documents/doctor_documents_viewer.dart';
import 'package:healthcare_plus/video_call/video_call_helper.dart';

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
  final String? bookingFor; // Family member info (e.g., "John (Father)")
  final String? consultationType; // Online or Clinic
  final int duration; // Appointment duration in minutes
  final String? date; // Appointment date
  final String? appointmentTime; // Appointment time (HH:MM AM/PM)

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
    this.bookingFor,
    this.consultationType,
    this.duration = 30, // Default 30 minutes
    this.date,
    this.appointmentTime,
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

  Future<void> _cancelAppointment(BuildContext context, AppointmentModel data) async {
    final TextEditingController reasonController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    // Show dialog to get cancellation reason
    final String? cancellationReason = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Appointment'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Are you sure you want to cancel the appointment with ${data.name}?',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Reason for cancellation *',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: reasonController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Please provide a reason for cancellation',
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.blue, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Cancellation reason is required';
                      }
                      if (value.trim().length < 10) {
                        return 'Please provide a detailed reason (min 10 characters)';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('Go Back'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(context).pop(reasonController.text.trim());
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Cancel Appointment'),
            ),
          ],
        );
      },
    );

    // If user didn't provide a reason, exit
    if (cancellationReason == null || cancellationReason.isEmpty) {
      reasonController.dispose();
      return;
    }

    try {
      final appointmentId = data.appointmentId;
      if (appointmentId == null || appointmentId.isEmpty) {
        throw Exception('Appointment ID not found');
      }

      // Update appointment status to 'cancelled' in Firebase with reason
      await FirebaseDatabase.instance
          .ref('healthcare/all_appointments/$appointmentId')
          .update({
        'status': 'cancelled',
        'cancelledAt': DateTime.now().toIso8601String(),
        'cancelledBy': 'doctor',
        'cancellationReason': cancellationReason,
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Appointment cancelled successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to cancel appointment: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      reasonController.dispose();
    }
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
                  backgroundImage: data.image.isNotEmpty ? AssetImage(data.image) : null,
                  child: data.image.isEmpty 
                    ? Text(data.name.isNotEmpty ? data.name[0] : '?', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue))
                    : null,
                ),
                const SizedBox(width: 16),
                
                // Info Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              data.name,
                              style: const TextStyle(
                                fontSize: 16, 
                                fontWeight: FontWeight.w700,
                                color: Colors.black87
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
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
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          // Booking For Info
                          if (data.bookingFor != null && data.bookingFor!.isNotEmpty) ...[
                            Text(
                              data.bookingFor!,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue.shade700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (data.consultationType != null && data.consultationType!.isNotEmpty) ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Icon(Icons.circle, size: 4, color: Colors.grey.shade400),
                              ),
                            ],
                          ],
                          // Consultation Type Indicator
                          if (data.consultationType != null && data.consultationType!.isNotEmpty) ...[
                            Icon(
                              data.consultationType == 'Online' ? Icons.videocam : Icons.location_on,
                              size: 12,
                              color: data.consultationType == 'Online' ? Colors.green.shade600 : Colors.purple.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              data.consultationType!,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: data.consultationType == 'Online' ? Colors.green.shade700 : Colors.purple.shade700,
                              ),
                            ),
                          ] else ...[
                            // Show "Type Unknown" for old appointments without type field
                            Icon(Icons.help_outline, size: 12, color: Colors.grey.shade400),
                            const SizedBox(width: 4),
                            Text(
                              'Type Unknown',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ---------------- Divider ----------------
          Divider(height: 1, color: Colors.grey.shade100),

          // ---------------- Bottom Section: Time & Action Buttons ----------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Booking Time
                Icon(Icons.calendar_today_outlined, size: 16, color: Colors.blue.shade400),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    data.time,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                
                // Documents Button
                SizedBox(
                  height: 36,
                  width: 36,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorDocumentsViewer(
                            appointmentId: data.appointmentId ?? '',
                            patientName: data.name,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade50,
                      foregroundColor: Colors.orange,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Icon(Icons.folder_open, size: 18),
                  ),
                ),
                const SizedBox(width: 8),

                // Cancel Button
                SizedBox(
                  height: 36,
                  width: 36,
                  child: ElevatedButton(
                    onPressed: () => _cancelAppointment(context, data),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade50,
                      foregroundColor: Colors.red,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Icon(Icons.cancel_outlined, size: 18),
                  ),
                ),
              ],
            ),
          ),

          // ---------------- Video Call Button (Full Width) - Only for Online Consultations ----------------
          if (data.consultationType == 'Online')
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (data.appointmentId == null || data.appointmentId!.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Appointment ID not found"),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    
                    // Calculate end time based on WHEN DOCTOR STARTS THE CALL
                    // If slot is 50 minutes, timer shows exactly 50 minutes from NOW
                    final now = DateTime.now();
                    final scheduledEndTime = now.add(Duration(minutes: data.duration));
                    
                    debugPrint('🔍 DOCTOR STARTING CALL:');
                    debugPrint('   Duration: ${data.duration} minutes');
                    debugPrint('   Start time (NOW): $now');
                    debugPrint('   End time (NOW + duration): $scheduledEndTime');
                    debugPrint('   Timer will show: ${data.duration} minutes');
                    
                    await VideoCallHelper.startCallAsDoctor(
                      context: context,
                      appointmentId: data.appointmentId!,
                      patientName: data.name,
                      duration: data.duration,
                      scheduledEndTime: scheduledEndTime,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.videocam, size: 20),
                  label: const Text(
                    "Start Video Call",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
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