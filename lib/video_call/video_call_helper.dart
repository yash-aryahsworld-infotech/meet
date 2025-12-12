import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'screens/home_screen.dart';
import 'screens/call_screen.dart';
import 'screens/waiting_room_screen.dart';
import 'models/call_model.dart';
import 'config/app_config.dart';
import 'utils/logger.dart';

/// Helper class for starting video calls from appointments
class VideoCallHelper {
  /// Generate secure meeting ID from appointment ID using backend HMAC hashing
  static Future<String?> _generateSecureMeetingId(String appointmentId) async {
    try {
      Logger.log('🔐 Requesting secure meeting ID for appointment: $appointmentId');
      
      final response = await http.post(
        Uri.parse('${AppConfig.serverUrl}/generate-meeting-id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'appointmentId': appointmentId}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final meetingId = data['meetingId'];
        Logger.log('✅ Secure meeting ID generated: $meetingId');
        return meetingId;
      } else {
        Logger.error('Failed to generate meeting ID', 'Status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      Logger.error('Error generating meeting ID', e);
      return null;
    }
  }

  /// Start a video call as a doctor
  static Future<void> startCallAsDoctor({
    required BuildContext context,
    required String appointmentId,
    required String patientName,
    DateTime? scheduledEndTime,
    int duration = 30,
  }) async {
    try {
      // Show loading indicator
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      // Generate secure meeting ID from backend
      final meetingId = await _generateSecureMeetingId(appointmentId);
      
      // Close loading indicator
      if (context.mounted) {
        Navigator.pop(context);
      }

      if (meetingId == null) {
        throw Exception('Failed to generate secure meeting ID');
      }
      
      // Create meeting object (No DB)
      final meeting = Meeting(
        meetingId: meetingId,
        hostId: 'doctor_$appointmentId',
        hostName: 'Doctor',
        createdAt: DateTime.now(),
        status: MeetingStatus.active,
        participantIds: ['doctor_$appointmentId'],
      );

      if (context.mounted) {
        // Calculate end time if not provided
        final endTime = scheduledEndTime ?? DateTime.now().add(Duration(minutes: duration));
        
        // Navigate to call screen with appointment ID and timing
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallScreen(
              meeting: meeting,
              participantId: 'doctor_$appointmentId',
              participantName: 'Doctor',
              isHost: true,
              appointmentId: appointmentId,
              scheduledEndTime: endTime,
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to start call: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Start a video call as a patient
  static Future<void> startCallAsPatient({
    required BuildContext context,
    required String appointmentId,
    required String doctorName,
    int duration = 30,
    DateTime? scheduledEndTime,
  }) async {
    try {
      // Show loading indicator
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      // Generate secure meeting ID from backend (same as doctor)
      final meetingId = await _generateSecureMeetingId(appointmentId);
      
      // Close loading indicator
      if (context.mounted) {
        Navigator.pop(context);
      }

      if (meetingId == null) {
        throw Exception('Failed to generate secure meeting ID');
      }

      // Create meeting object (No DB)
      final meeting = Meeting(
        meetingId: meetingId,
        hostId: 'doctor_$appointmentId',
        hostName: doctorName,
        createdAt: DateTime.now(),
        status: MeetingStatus.active,
        participantIds: ['doctor_$appointmentId', 'patient_$appointmentId'],
      );

      if (context.mounted) {
        // Calculate end time if not provided
        final endTime = scheduledEndTime ?? DateTime.now().add(Duration(minutes: duration));
        
        // Navigate to waiting room - patient waits for doctor
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WaitingRoomScreen(
              meeting: meeting,
              participantId: 'patient_$appointmentId',
              participantName: 'Patient',
              appointmentId: appointmentId,
              scheduledEndTime: endTime,
              duration: duration,
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to join call: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Navigate to video call home screen (for general video calls)
  static void navigateToVideoCall(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }
}
