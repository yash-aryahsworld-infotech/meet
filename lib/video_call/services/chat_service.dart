import 'dart:async';
import 'dart:convert';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../models/chat_message.dart';
import 'socket_signaling_service.dart';
import '../utils/logger.dart';

class ChatService {
  RTCDataChannel? _dataChannel;
  final SocketSignalingService _socketService = SocketSignalingService();
  
  final StreamController<ChatMessage> _messageController = StreamController<ChatMessage>.broadcast();
  Stream<ChatMessage> get messageStream => _messageController.stream;
  
  // Store all messages in memory for the duration of the call
  final List<ChatMessage> _allMessages = [];
  List<ChatMessage> get allMessages => List.unmodifiable(_allMessages);

  String? _myParticipantId;
  String? _myParticipantName;
  String? _meetingId;
  bool _isInitialized = false;

  void initialize({
    required String participantId,
    required String participantName,
    required String meetingId,
  }) {
    if (_isInitialized) {
      Logger.log('⚠️ ChatService already initialized');
      return;
    }
    
    _myParticipantId = participantId;
    _myParticipantName = participantName;
    _meetingId = meetingId;
    _isInitialized = true;
    
    Logger.log('✅ ChatService initialized for $participantName in meeting $meetingId');
    
    // Listen for chat messages via Socket.IO
    _socketService.onChatMessage = (data) {
      Logger.log('📨 Received chat message from ${data['senderName']} (senderId: ${data['senderId']}, myId: $_myParticipantId)');
      
      // Only add messages from other participants (not from myself)
      // My messages are already added locally in sendMessage()
      if (data['senderId'] != _myParticipantId) {
        final message = ChatMessage.fromMap(
          data,
          isMe: false,
        );
        
        // Add to persistent storage
        _allMessages.add(message);
        
        // Broadcast to stream
        _messageController.add(message);
        Logger.log('✅ Message added to storage and stream. Total: ${_allMessages.length}');
      } else {
        Logger.log('⏭️ Skipping my own message (already in storage)');
      }
    };
  }

  // Create data channel for peer-to-peer chat
  Future<void> createDataChannel(RTCPeerConnection peerConnection) async {
    try {
      _dataChannel = await peerConnection.createDataChannel(
        'chat',
        RTCDataChannelInit()..ordered = true,
      );
      
      _setupDataChannelListeners();
      Logger.log('📡 Data channel created for chat');
    } catch (e) {
      Logger.error('Error creating data channel', e);
    }
  }

  // Set up data channel when receiving from peer
  void setDataChannel(RTCDataChannel dataChannel) {
    _dataChannel = dataChannel;
    _setupDataChannelListeners();
    Logger.log('📡 Data channel received for chat');
  }

  void _setupDataChannelListeners() {
    _dataChannel?.onMessage = (RTCDataChannelMessage message) {
      try {
        final data = jsonDecode(message.text);
        final chatMessage = ChatMessage.fromMap(
          data,
          isMe: data['senderId'] == _myParticipantId,
        );
        _messageController.add(chatMessage);
      } catch (e) {
        Logger.error('Error parsing chat message', e);
      }
    };

    _dataChannel?.onDataChannelState = (state) {
      Logger.log('Data channel state: $state');
      
      // If data channel closes, log it
      if (state == RTCDataChannelState.RTCDataChannelClosed) {
        Logger.log('⚠️ Data channel closed - falling back to Socket.IO');
      } else if (state == RTCDataChannelState.RTCDataChannelClosing) {
        Logger.log('⚠️ Data channel closing');
      } else if (state == RTCDataChannelState.RTCDataChannelOpen) {
        Logger.log('✅ Data channel open and ready');
      }
    };
  }

  // Send message via Socket.IO (most reliable)
  void sendMessage(String messageText) {
    if (messageText.trim().isEmpty) return;
    if (!_isInitialized) {
      Logger.log('⚠️ ChatService not initialized, cannot send message');
      return;
    }

    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: _myParticipantId!,
      senderName: _myParticipantName!,
      message: messageText.trim(),
      timestamp: DateTime.now(),
      isMe: true,
    );

    Logger.log('💬 Sending message: "${message.message}" from ${message.senderName} (${message.senderId})');
    
    // Add to persistent storage first
    _allMessages.add(message);
    
    // Add to local stream immediately so sender sees their own message
    _messageController.add(message);
    Logger.log('✅ Message added to storage and stream. Total: ${_allMessages.length}');

    // Always send via Socket.IO to ensure delivery to other participants
    // This is more reliable than WebRTC Data Channel
    if (_meetingId != null) {
      _socketService.sendChatMessage(
        meetingId: _meetingId!,
        message: message.toMap(),
      );
      Logger.log('📤 Message sent via Socket.IO to meeting: $_meetingId');
    }
  }

  void dispose() {
    Logger.log('🧹 Disposing ChatService. Total messages: ${_allMessages.length}');
    _dataChannel?.close();
    _messageController.close();
    _allMessages.clear();
    _isInitialized = false;
  }
}
