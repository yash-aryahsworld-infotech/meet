import 'package:socket_io_client/socket_io_client.dart' as io;
import '../config/app_config.dart';
import '../utils/logger.dart';

class SocketSignalingService {
  static final SocketSignalingService _instance = SocketSignalingService._internal();
  factory SocketSignalingService() => _instance;
  SocketSignalingService._internal();

  io.Socket? _socket;
  bool _isConnected = false;

  // Server URL is now managed in lib/config/app_config.dart
  // This allows easy switching between development and production
  String get serverUrl => AppConfig.serverUrl;

  // Callbacks
  Function(Map<String, dynamic>)? onOffer;
  Function(Map<String, dynamic>)? onAnswer;
  Function(Map<String, dynamic>)? onIceCandidate;
  Function(Map<String, dynamic>)? onParticipantJoined;
  Function(Map<String, dynamic>)? onParticipantLeft;
  Function(List<dynamic>)? onExistingParticipants;
  Function(Map<String, dynamic>)? onChatMessage;
  Function(Map<String, dynamic>)? onParticipantStateChanged;
  Function()? onMutedByHost;
  Function()? onUnmutedByHost;
  Function()? onRemovedByHost;

  Future<void> connect() async {
    if (_isConnected) return;

    Logger.log('🌐 Environment: ${AppConfig.environment}');
    Logger.log('🔗 Connecting to signaling server: $serverUrl');

    _socket = io.io(serverUrl, <String, dynamic>{
      'transports': ['websocket', 'polling'], // Try both transports
      'autoConnect': false,
      'timeout': 10000, // 10 second timeout
      'reconnection': true,
      'reconnectionAttempts': 5,
      'reconnectionDelay': 1000,
    });

    _socket!.connect();

    _socket!.onConnect((_) {
      Logger.log('✅ Connected to signaling server successfully!');
      _isConnected = true;
    });

    _socket!.onDisconnect((reason) {
      Logger.log('❌ Disconnected from signaling server. Reason: $reason');
      _isConnected = false;
    });

    _socket!.onConnectError((error) {
      Logger.error('❌ Connection error', error);
      Logger.log('💡 Troubleshooting:');
      Logger.log('   1. Is server running? Check terminal');
      Logger.log('   2. Server URL: $serverUrl');
      Logger.log('   3. For emulator, use: http://10.0.2.2:3001');
      Logger.log('   4. For physical device, use your PC IP');
    });

    _socket!.onError((error) {
      Logger.error('❌ Socket error', error);
    });
    
    _socket!.on('connect_timeout', (_) {
      Logger.log('⏱️ Connection timeout - server not responding');
    });
    
    _socket!.on('reconnect_attempt', (attempt) {
      Logger.log('🔄 Reconnection attempt #$attempt');
    });
    
    _socket!.on('reconnect_failed', (_) {
      Logger.log('❌ Reconnection failed after all attempts');
    });

    // Listen for WebRTC signaling events
    _socket!.on('offer', (data) {
      Logger.log('Received offer from ${data['fromParticipantName']}');
      if (onOffer != null) {
        onOffer!(Map<String, dynamic>.from(data));
      }
    });

    _socket!.on('answer', (data) {
      Logger.log('Received answer from ${data['fromParticipantId']}');
      if (onAnswer != null) {
        onAnswer!(Map<String, dynamic>.from(data));
      }
    });

    _socket!.on('ice-candidate', (data) {
      Logger.log('Received ICE candidate from ${data['fromParticipantId']}');
      if (onIceCandidate != null) {
        onIceCandidate!(Map<String, dynamic>.from(data));
      }
    });

    _socket!.on('participant-joined', (data) {
      Logger.log('Participant joined: ${data['participantName']}');
      if (onParticipantJoined != null) {
        onParticipantJoined!(Map<String, dynamic>.from(data));
      }
    });

    _socket!.on('participant-left', (data) {
      Logger.log('Participant left: ${data['participantName']}');
      if (onParticipantLeft != null) {
        onParticipantLeft!(Map<String, dynamic>.from(data));
      }
    });

    _socket!.on('existing-participants', (data) {
      Logger.log('Existing participants: ${data.length}');
      if (onExistingParticipants != null) {
        onExistingParticipants!(data);
      }
    });

    _socket!.on('chat-message', (data) {
      Logger.log('Received chat message from ${data['senderName']}');
      if (onChatMessage != null) {
        onChatMessage!(Map<String, dynamic>.from(data));
      }
    });

    _socket!.on('participant-state-changed', (data) {
      Logger.log('Participant state changed: ${data['participantId']}');
      if (onParticipantStateChanged != null) {
        onParticipantStateChanged!(Map<String, dynamic>.from(data));
      }
    });

    _socket!.on('muted-by-host', (_) {
      Logger.log('You were muted by the host');
      if (onMutedByHost != null) {
        onMutedByHost!();
      }
    });

    _socket!.on('unmuted-by-host', (_) {
      Logger.log('You were unmuted by the host');
      if (onUnmutedByHost != null) {
        onUnmutedByHost!();
      }
    });

    _socket!.on('removed-by-host', (_) {
      Logger.log('You were removed by the host');
      if (onRemovedByHost != null) {
        onRemovedByHost!();
      }
    });
  }

  void joinMeeting({
    required String meetingId,
    required String participantId,
    required String participantName,
    required bool isHost,
    String? appointmentId,
  }) {
    if (!_isConnected || _socket == null) {
      Logger.log('⚠️ Not connected to server, cannot join meeting');
      return;
    }

    Logger.log('✅ Joining meeting: $meetingId as $participantName');
    if (appointmentId != null) {
      Logger.log('   📋 Appointment ID: $appointmentId');
    }
    try {
      _socket!.emit('join-meeting', {
        'meetingId': meetingId,
        'participantId': participantId,
        'participantName': participantName,
        'isHost': isHost,
        'appointmentId': appointmentId,
      });
    } catch (e) {
      Logger.error('Error joining meeting', e);
    }
  }

  void sendOffer({
    required String meetingId,
    required String toParticipantId,
    required Map<String, dynamic> offer,
  }) {
    if (_socket == null || !_isConnected) {
      Logger.log('⚠️ Cannot send offer - not connected');
      return;
    }
    
    Logger.log('📤 Sending offer to $toParticipantId');
    try {
      _socket!.emit('offer', {
        'meetingId': meetingId,
        'toParticipantId': toParticipantId,
        'offer': offer,
      });
    } catch (e) {
      Logger.error('Error sending offer', e);
    }
  }

  void sendAnswer({
    required String meetingId,
    required String toParticipantId,
    required Map<String, dynamic> answer,
  }) {
    if (_socket == null || !_isConnected) {
      Logger.log('⚠️ Cannot send answer - not connected');
      return;
    }
    
    Logger.log('📤 Sending answer to $toParticipantId');
    try {
      _socket!.emit('answer', {
        'meetingId': meetingId,
        'toParticipantId': toParticipantId,
        'answer': answer,
      });
    } catch (e) {
      Logger.error('Error sending answer', e);
    }
  }

  void sendIceCandidate({
    required String meetingId,
    required String toParticipantId,
    required Map<String, dynamic> candidate,
  }) {
    if (_socket == null || !_isConnected) {
      return; // ICE candidates can fail silently
    }
    
    try {
      _socket!.emit('ice-candidate', {
        'meetingId': meetingId,
        'toParticipantId': toParticipantId,
        'candidate': candidate,
      });
    } catch (e) {
      Logger.error('Error sending ICE candidate', e);
    }
  }

  void sendChatMessage({
    required String meetingId,
    required Map<String, dynamic> message,
  }) {
    _socket!.emit('chat-message', {
      'meetingId': meetingId,
      'message': message,
    });
  }

  void updateParticipantState({
    required String meetingId,
    required String participantId,
    bool? isAudioMuted,
    bool? isVideoOff,
  }) {
    _socket!.emit('update-participant-state', {
      'meetingId': meetingId,
      'participantId': participantId,
      'isAudioMuted': isAudioMuted,
      'isVideoOff': isVideoOff,
    });
  }

  void muteParticipant({
    required String meetingId,
    required String participantId,
  }) {
    _socket!.emit('mute-participant', {
      'meetingId': meetingId,
      'participantId': participantId,
    });
  }

  void unmuteParticipant({
    required String meetingId,
    required String participantId,
  }) {
    _socket!.emit('unmute-participant', {
      'meetingId': meetingId,
      'participantId': participantId,
    });
  }

  void removeParticipant({
    required String meetingId,
    required String participantId,
  }) {
    _socket!.emit('remove-participant', {
      'meetingId': meetingId,
      'participantId': participantId,
    });
  }

  void startCall({
    required String appointmentId,
    required String meetingId,
    required String doctorName,
  }) {
    if (_socket == null || !_isConnected) {
      Logger.log('⚠️ Cannot start call - not connected');
      return;
    }
    
    Logger.log('📞 Starting call for appointment: $appointmentId');
    try {
      _socket!.emit('start-call', {
        'appointmentId': appointmentId,
        'meetingId': meetingId,
        'doctorName': doctorName,
      });
    } catch (e) {
      Logger.error('Error starting call', e);
    }
  }

  void endCall({required String appointmentId}) {
    if (_socket == null || !_isConnected) {
      Logger.log('⚠️ Cannot end call - not connected');
      return;
    }
    
    Logger.log('📞 Ending call for appointment: $appointmentId');
    try {
      _socket!.emit('end-call', {
        'appointmentId': appointmentId,
      });
    } catch (e) {
      Logger.error('Error ending call', e);
    }
  }

  void leaveMeeting({
    required String meetingId,
    required String participantId,
  }) {
    if (_socket == null || !_isConnected) {
      Logger.log('⚠️ Cannot leave meeting - not connected');
      return;
    }
    
    Logger.log('👋 Leaving meeting: $meetingId');
    try {
      _socket!.emit('leave-meeting', {
        'meetingId': meetingId,
        'participantId': participantId,
      });
    } catch (e) {
      Logger.error('Error leaving meeting', e);
    }
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _isConnected = false;
  }

  bool get isConnected => _isConnected;
}
