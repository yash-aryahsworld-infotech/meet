class ParticipantState {
  final String participantId;
  final String participantName;
  final bool isHost;
  final bool isAudioMuted;
  final bool isVideoOff;
  final DateTime joinedAt;

  ParticipantState({
    required this.participantId,
    required this.participantName,
    required this.isHost,
    this.isAudioMuted = false,
    this.isVideoOff = false,
    required this.joinedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'participantId': participantId,
      'participantName': participantName,
      'isHost': isHost,
      'isAudioMuted': isAudioMuted,
      'isVideoOff': isVideoOff,
      'joinedAt': joinedAt.millisecondsSinceEpoch,
    };
  }

  factory ParticipantState.fromMap(Map<String, dynamic> map) {
    return ParticipantState(
      participantId: map['participantId'] ?? '',
      participantName: map['participantName'] ?? '',
      isHost: map['isHost'] ?? false,
      isAudioMuted: map['isAudioMuted'] ?? false,
      isVideoOff: map['isVideoOff'] ?? false,
      joinedAt: DateTime.fromMillisecondsSinceEpoch(map['joinedAt'] ?? 0),
    );
  }

  ParticipantState copyWith({
    String? participantId,
    String? participantName,
    bool? isHost,
    bool? isAudioMuted,
    bool? isVideoOff,
    DateTime? joinedAt,
  }) {
    return ParticipantState(
      participantId: participantId ?? this.participantId,
      participantName: participantName ?? this.participantName,
      isHost: isHost ?? this.isHost,
      isAudioMuted: isAudioMuted ?? this.isAudioMuted,
      isVideoOff: isVideoOff ?? this.isVideoOff,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}
