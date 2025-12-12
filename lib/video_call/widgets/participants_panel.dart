import 'package:flutter/material.dart';
import '../models/participant_state.dart';

class ParticipantsPanel extends StatelessWidget {
  final List<ParticipantState> participants;
  final String myParticipantId;
  final bool isHost;
  final Function(String participantId) onMuteParticipant;
  final Function(String participantId) onUnmuteParticipant;
  final Function(String participantId) onRemoveParticipant;

  const ParticipantsPanel({
    super.key,
    required this.participants,
    required this.myParticipantId,
    required this.isHost,
    required this.onMuteParticipant,
    required this.onUnmuteParticipant,
    required this.onRemoveParticipant,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.people, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Participants (${participants.length})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Participants list
          Expanded(
            child: participants.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No participants',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: participants.length,
                    itemBuilder: (context, index) {
                      final participant = participants[index];
                      final isMe = participant.participantId == myParticipantId;
                      return _buildParticipantTile(context, participant, isMe);
                    },
                  ),
          ),

          // Host info banner
          if (isHost)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                border: Border(
                  top: BorderSide(color: Colors.blue.shade100),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.blue, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'As host, you can mute participants and remove them from the meeting',
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontSize: 12,
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

  Widget _buildParticipantTile(
    BuildContext context,
    ParticipantState participant,
    bool isMe,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isMe ? Colors.blue.shade50 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isMe ? Colors.blue.shade200 : Colors.grey.shade200,
        ),
      ),
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor:
                  participant.isHost ? Colors.orange : Colors.blue.shade100,
              child: Text(
                participant.participantName[0].toUpperCase(),
                style: TextStyle(
                  color: participant.isHost ? Colors.white : Colors.blue.shade900,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            if (participant.isHost)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.star,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                participant.participantName,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            if (isMe)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'You',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (participant.isHost && !isMe)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Host',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Row(
          children: [
            Icon(
              participant.isAudioMuted ? Icons.mic_off : Icons.mic,
              size: 16,
              color: participant.isAudioMuted ? Colors.red : Colors.green,
            ),
            const SizedBox(width: 4),
            Text(
              participant.isAudioMuted ? 'Muted' : 'Unmuted',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(width: 12),
            Icon(
              participant.isVideoOff ? Icons.videocam_off : Icons.videocam,
              size: 16,
              color: participant.isVideoOff ? Colors.red : Colors.green,
            ),
            const SizedBox(width: 4),
            Text(
              participant.isVideoOff ? 'Camera off' : 'Camera on',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: isHost && !isMe
            ? PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  switch (value) {
                    case 'mute':
                      if (participant.isAudioMuted) {
                        onUnmuteParticipant(participant.participantId);
                      } else {
                        onMuteParticipant(participant.participantId);
                      }
                      break;
                    case 'remove':
                      _showRemoveConfirmation(
                        context,
                        participant.participantName,
                        () => onRemoveParticipant(participant.participantId),
                      );
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'mute',
                    child: Row(
                      children: [
                        Icon(
                          participant.isAudioMuted ? Icons.mic : Icons.mic_off,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(participant.isAudioMuted ? 'Unmute' : 'Mute'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'remove',
                    child: Row(
                      children: [
                        Icon(Icons.remove_circle_outline,
                            size: 20, color: Colors.red),
                        SizedBox(width: 12),
                        Text('Remove', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              )
            : null,
      ),
    );
  }

  void _showRemoveConfirmation(
    BuildContext context,
    String participantName,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Participant'),
        content: Text(
          'Are you sure you want to remove $participantName from the meeting?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
