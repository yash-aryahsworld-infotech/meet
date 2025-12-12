import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoGrid extends StatelessWidget {
  final Map<String, RTCVideoRenderer> remoteRenderers;
  final RTCVideoRenderer localRenderer;
  final String localParticipantName;
  final Map<String, String> participantNames;

  const VideoGrid({
    super.key,
    required this.remoteRenderers,
    required this.localRenderer,
    required this.localParticipantName,
    required this.participantNames,
  });

  @override
  Widget build(BuildContext context) {
    final totalParticipants = remoteRenderers.length + 1; // +1 for local
    
    // Determine grid layout based on participant count
    final gridConfig = _getGridConfig(totalParticipants);
    
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: gridConfig.columns,
        childAspectRatio: 3 / 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: totalParticipants,
      itemBuilder: (context, index) {
        if (index == 0) {
          // Local video always first
          return _buildVideoTile(
            renderer: localRenderer,
            participantName: localParticipantName,
            isLocal: true,
          );
        } else {
          // Remote videos
          final participantId = remoteRenderers.keys.elementAt(index - 1);
          final renderer = remoteRenderers[participantId]!;
          final name = participantNames[participantId] ?? 'Unknown';
          
          return _buildVideoTile(
            renderer: renderer,
            participantName: name,
            isLocal: false,
          );
        }
      },
    );
  }

  Widget _buildVideoTile({
    required RTCVideoRenderer renderer,
    required String participantName,
    required bool isLocal,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white24,
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            // Video stream
            RTCVideoView(
              renderer,
              mirror: isLocal,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            ),
            
            // Participant name overlay
            Positioned(
              bottom: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  participantName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _GridConfig _getGridConfig(int participantCount) {
    if (participantCount == 1) {
      return _GridConfig(columns: 1);
    } else if (participantCount == 2) {
      return _GridConfig(columns: 1);
    } else if (participantCount <= 4) {
      return _GridConfig(columns: 2);
    } else if (participantCount <= 9) {
      return _GridConfig(columns: 3);
    } else {
      return _GridConfig(columns: 4);
    }
  }
}

class _GridConfig {
  final int columns;
  
  _GridConfig({required this.columns});
}
