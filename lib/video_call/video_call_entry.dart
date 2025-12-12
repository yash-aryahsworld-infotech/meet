import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

/// Entry point for the video call feature
/// This can be called from anywhere in the app (Patient or Doctor screens)
class VideoCallEntry {
  /// Navigate to video call home screen
  static void navigateToVideoCall(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  /// Create a floating action button for video call
  static Widget createVideoCallButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => navigateToVideoCall(context),
      icon: const Icon(Icons.video_call),
      label: const Text('Video Call'),
      backgroundColor: Colors.blue,
    );
  }

  /// Create a card widget for video call feature
  static Widget createVideoCallCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => navigateToVideoCall(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.video_call,
                  size: 48,
                  color: Colors.blue.shade700,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Video Consultation',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Start or join a video call',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Create a list tile for video call feature
  static Widget createVideoCallListTile(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.video_call,
          color: Colors.blue.shade700,
        ),
      ),
      title: const Text(
        'Video Consultation',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: const Text('Start or join a video call with doctor/patient'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => navigateToVideoCall(context),
    );
  }
}
