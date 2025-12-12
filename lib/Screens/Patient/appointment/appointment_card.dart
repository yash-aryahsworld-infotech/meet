import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:healthcare_plus/Screens/Patient/appointment/reschedule_appoinment.dart';
import 'package:healthcare_plus/video_call/video_call_helper.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:healthcare_plus/video_call/config/app_config.dart';

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

  Future<void> _cancelAppointment(BuildContext context) async {
    final TextEditingController reasonController = TextEditingController();

    // Show dialog to get cancellation reason (optional for patients)
    final String? cancellationReason = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Appointment'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Are you sure you want to cancel this appointment?',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Reason for cancellation (optional)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: reasonController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'e.g., Personal emergency, Schedule conflict',
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
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('Go Back'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(reasonController.text.trim());
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

    // If user cancelled the dialog, exit
    if (cancellationReason == null) {
      reasonController.dispose();
      return;
    }

    try {
      final appointmentId = appointment['appointmentId'];
      if (appointmentId == null || appointmentId.isEmpty) {
        throw Exception('Appointment ID not found');
      }

      // Update appointment status to 'cancelled' in Firebase
      final updateData = {
        'status': 'cancelled',
        'cancelledAt': DateTime.now().toIso8601String(),
        'cancelledBy': 'patient',
      };

      // Add reason if provided
      if (cancellationReason.isNotEmpty) {
        updateData['cancellationReason'] = cancellationReason;
      }

      await FirebaseDatabase.instance
          .ref('healthcare/all_appointments/$appointmentId')
          .update(updateData);

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

  @override
  Widget build(BuildContext context) {
    final bool isUpcoming = appointment['isUpcoming'] ?? false;
    final String type = appointment['type'] ?? ""; // No default - show what's in database
    final bool isOnline = type == "Online";
    final String? imagePath = appointment['image'];
    final String? cancellationReason = appointment['cancellationReason'];
    final String? cancelledBy = appointment['cancelledBy'];
    final bool isCancelled = appointment['status'] == 'cancelled';

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
        color: isCancelled ? Colors.grey.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCancelled ? Colors.red.shade200 : Colors.grey.shade200,
          width: isCancelled ? 2 : 1,
        ),
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
                // Avatar with proper null handling
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue.shade50,
                  backgroundImage: imgProvider,
                  onBackgroundImageError: imgProvider != null ? (exception, stackTrace) {
                    // Error handler for image loading failures
                  } : null,
                  child: imgProvider == null 
                    ? const Icon(Icons.person, color: Colors.blue, size: 30)
                    : null,
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
                              appointment['name'] ?? "Unknown Doctor",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (isCancelled)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.red.shade300),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.cancel, size: 14, color: Colors.red.shade700),
                                  const SizedBox(width: 6),
                                  Text(
                                    "CANCELLED",
                                    style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w700, fontSize: 12),
                                  ),
                                ],
                              ),
                            )
                          else if (type.isNotEmpty)
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
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.help_outline, size: 14, color: Colors.grey.shade500),
                                  const SizedBox(width: 6),
                                  Text(
                                    "Type Unknown",
                                    style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600, fontSize: 12),
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

            // --- Cancellation Reason Display ---
            if (isCancelled && cancellationReason != null && cancellationReason.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.cancel_outlined, size: 16, color: Colors.red.shade700),
                        const SizedBox(width: 6),
                        Text(
                          'Cancelled by ${cancelledBy == 'doctor' ? 'Doctor' : 'You'}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Reason: $cancellationReason',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.red.shade900,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // --- 2. Action Buttons Row ---
            if (isUpcoming && !isCancelled)
              // ---------------- UPCOMING LAYOUT ----------------
              Column(
                children: [
                  // Video Call Button (Only for Online consultations)
                  if (type == 'Online')
                    _buildVideoCallButton(context, appointment)
                  else
                    const SizedBox.shrink(),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // 1. Cancel
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _cancelAppointment(context),
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
                    ],
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

  Widget _buildVideoCallButton(BuildContext context, Map<String, dynamic> appointment) {
    final appointmentId = appointment['appointmentId'];
    final appointmentDate = appointment['date'];
    final appointmentTime = appointment['time'];
    final duration = appointment['duration'] ?? 30;
    
    // Create socket connection to listen for doctor starting call
    final socket = io.io(AppConfig.serverUrl, <String, dynamic>{
      'transports': ['websocket', 'polling'],
      'autoConnect': true,
    });
    
    // Parse appointment date and time
    DateTime? appointmentDateTime;
    try {
      if (appointmentDate != null && appointmentTime != null) {
        final dateStr = appointmentDate.toString();
        final timeStr = appointmentTime.toString();
        
        // Parse date
        DateTime parsedDate;
        if (dateStr.contains('-')) {
          parsedDate = DateTime.parse(dateStr);
        } else {
          parsedDate = DateTime.now();
        }
        
        // Parse time (format: "HH:MM AM/PM")
        final timeParts = timeStr.replaceAll(RegExp(r'\s+'), ' ').trim().split(' ');
        if (timeParts.isNotEmpty) {
          final hourMinute = timeParts[0].split(':');
          int hour = int.parse(hourMinute[0]);
          final minute = int.parse(hourMinute[1]);
          
          if (timeParts.length > 1 && timeParts[1].toUpperCase() == 'PM' && hour != 12) {
            hour += 12;
          } else if (timeParts.length > 1 && timeParts[1].toUpperCase() == 'AM' && hour == 12) {
            hour = 0;
          }
          
          appointmentDateTime = DateTime(
            parsedDate.year,
            parsedDate.month,
            parsedDate.day,
            hour,
            minute,
          );
        }
      }
    } catch (e) {
      // Error parsing date/time
    }
    
    // Listen for doctor starting the call
    return StreamBuilder<bool>(
      stream: _listenForCallStart(socket, appointmentId),
      builder: (context, snapshot) {
        final doctorStartedCall = snapshot.data ?? false;
        final now = DateTime.now();
        final canJoinByTime = appointmentDateTime != null && 
                        now.isAfter(appointmentDateTime.subtract(const Duration(minutes: 5)));
        final isExpired = appointmentDateTime != null && 
                          now.isAfter(appointmentDateTime.add(Duration(minutes: duration)));
        
        String buttonText = "Join Video Call";
        Color buttonColor = Colors.purple;
        bool isEnabled = (doctorStartedCall || canJoinByTime) && !isExpired;
        
        if (isExpired) {
          buttonText = "Call Ended";
          buttonColor = Colors.grey;
          isEnabled = false;
        } else if (doctorStartedCall && !canJoinByTime) {
          buttonText = "Doctor is waiting! Join now";
          buttonColor = Colors.green;
          isEnabled = true;
        } else if (!canJoinByTime && appointmentDateTime != null) {
          final minutesUntil = appointmentDateTime.difference(now).inMinutes;
          buttonText = "Available in $minutesUntil min";
          buttonColor = Colors.orange;
          isEnabled = false;
        }
        
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: isEnabled ? () async {
              if (appointmentId == null || appointmentId.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Appointment ID not found"),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              
              socket.dispose(); // Clean up socket
              
              // Calculate end time based on WHEN PATIENT JOINS THE CALL
              // If slot is 50 minutes, timer shows exactly 50 minutes from NOW
              final now = DateTime.now();
              final scheduledEndTime = now.add(Duration(minutes: duration));
              
              debugPrint('🔍 PATIENT JOINING CALL:');
              debugPrint('   Duration: $duration minutes');
              debugPrint('   Join time (NOW): $now');
              debugPrint('   End time (NOW + duration): $scheduledEndTime');
              debugPrint('   Timer will show: $duration minutes');
              
              await VideoCallHelper.startCallAsPatient(
                context: context,
                appointmentId: appointmentId,
                doctorName: appointment['name'] ?? 'Doctor',
                duration: duration,
                scheduledEndTime: scheduledEndTime,
              );
            } : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(vertical: 12),
              disabledBackgroundColor: Colors.grey.shade300,
              disabledForegroundColor: Colors.grey.shade600,
            ),
            icon: Icon(
              isExpired ? Icons.videocam_off : (doctorStartedCall ? Icons.notifications_active : Icons.videocam),
              size: 16,
            ),
            label: Text(
              buttonText,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        );
      },
    );
  }
  
  Stream<bool> _listenForCallStart(io.Socket socket, String? appointmentId) {
    if (appointmentId == null) return Stream.value(false);
    
    final controller = StreamController<bool>();
    bool callActive = false;
    
    // Listen for call-started event
    socket.on('call-started', (data) {
      if (data['appointmentId'] == appointmentId) {
        callActive = true;
        controller.add(true);
      }
    });
    
    // Listen for call-ended event
    socket.on('call-ended', (data) {
      if (data['appointmentId'] == appointmentId) {
        callActive = false;
        controller.add(false);
      }
    });
    
    // Check current status on connect
    socket.on('connect', (_) {
      socket.emit('check-call-status', {'appointmentId': appointmentId});
    });
    
    socket.on('call-status-response', (data) {
      if (data['appointmentId'] == appointmentId) {
        callActive = data['isActive'] ?? false;
        controller.add(callActive);
      }
    });
    
    return controller.stream;
  }
}