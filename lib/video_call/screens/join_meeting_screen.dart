import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/call_model.dart';
import 'call_screen.dart';
import '../utils/logger.dart';

class JoinMeetingScreen extends StatefulWidget {
  final String participantName;

  const JoinMeetingScreen({
    super.key,
    required this.participantName,
  });

  @override
  State<JoinMeetingScreen> createState() => _JoinMeetingScreenState();
}

class _JoinMeetingScreenState extends State<JoinMeetingScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _meetingIdController = TextEditingController();
  bool _isJoining = false;

  Future<void> _joinMeeting() async {
    final meetingId = _meetingIdController.text.trim();
    
    if (meetingId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter meeting ID')),
      );
      return;
    }

    setState(() => _isJoining = true);

    try {
      Logger.log('Attempting to join meeting: $meetingId');
      final meeting = await _firebaseService.getMeeting(meetingId);

      if (meeting == null) {
        Logger.log('Meeting not found in database: $meetingId');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Meeting not found. Please check the ID.')),
          );
        }
        setState(() => _isJoining = false);
        return;
      }

      Logger.log('Meeting found: ${meeting.meetingId}, Status: ${meeting.status}');

      if (meeting.status == MeetingStatus.ended) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('This meeting has ended')),
          );
        }
        setState(() => _isJoining = false);
        return;
      }

      final participantId = DateTime.now().millisecondsSinceEpoch.toString();
      Logger.log('Joining as participant: $participantId');

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CallScreen(
              meeting: meeting,
              participantName: widget.participantName,
              participantId: participantId,
              isHost: false,
            ),
          ),
        );
      }
    } catch (e, stackTrace) {
      Logger.error('Error joining meeting', e);
      Logger.error('Stack trace', null, stackTrace);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to join meeting: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isJoining = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Meeting'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.meeting_room,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 32),
            const Text(
              'Enter Meeting ID',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Joining as: ${widget.participantName}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 48),
            TextField(
              controller: _meetingIdController,
              decoration: InputDecoration(
                labelText: 'Meeting ID',
                hintText: '123-456-789',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.tag),
              ),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isJoining ? null : _joinMeeting,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isJoining
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Join Meeting',
                      style: TextStyle(fontSize: 18),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _meetingIdController.dispose();
    super.dispose();
  }
}
