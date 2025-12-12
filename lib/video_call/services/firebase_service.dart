import 'dart:math';
import '../models/user_model.dart';
import '../models/call_model.dart';
import '../utils/logger.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  // Generate random meeting ID (like Zoom: 123-456-789)
  String generateMeetingId() {
    final random = Random();
    final part1 = random.nextInt(900) + 100; // 100-999
    final part2 = random.nextInt(900) + 100;
    final part3 = random.nextInt(900) + 100;
    return '$part1-$part2-$part3';
  }

  // Meeting Management (No DB - just in-memory)
  Future<Meeting> createMeeting(String hostName) async {
    final meetingId = generateMeetingId();
    final hostId = DateTime.now().millisecondsSinceEpoch.toString();
    
    final meeting = Meeting(
      meetingId: meetingId,
      hostId: hostId,
      hostName: hostName,
      createdAt: DateTime.now(),
      status: MeetingStatus.waiting,
      participantIds: [hostId],
    );
    
    Logger.log('✅ Meeting created: $meetingId (No DB)');
    return meeting;
  }

  Future<Meeting?> getMeeting(String meetingId) async {
    Logger.log('⚠️ getMeeting called but no DB configured');
    // Return a dummy meeting for now
    return Meeting(
      meetingId: meetingId,
      hostId: 'host_$meetingId',
      hostName: 'Host',
      createdAt: DateTime.now(),
      status: MeetingStatus.active,
      participantIds: [],
    );
  }

  Future<void> updateMeetingStatus(String meetingId, MeetingStatus status) async {
    Logger.log('✅ Meeting status updated to ${status.name} (No DB)');
  }

  Future<void> endMeeting(String meetingId) async {
    Logger.log('✅ Meeting ended: $meetingId (No DB)');
  }

  // Participant Management (No DB)
  Future<void> addParticipant(String meetingId, String participantId, String name, bool isHost) async {
    Logger.log('✅ Participant added: $name (No DB)');
  }

  Future<void> removeParticipant(String meetingId, String participantId) async {
    Logger.log('✅ Participant removed (No DB)');
  }

  Stream<List<Participant>> getParticipants(String meetingId) {
    // Return empty stream for now
    return Stream.value([]);
  }

  Stream<List<Participant>> watchParticipants(String meetingId) {
    return getParticipants(meetingId);
  }
}
