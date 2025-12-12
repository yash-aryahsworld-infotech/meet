import 'dart:async';
import 'package:flutter/material.dart';
import '../models/call_model.dart';
import '../models/participant_state.dart';
import '../services/webrtc_service.dart';
import '../services/socket_signaling_service.dart';
import '../services/chat_service.dart';
import '../widgets/chat_panel.dart';
import '../widgets/participants_panel.dart';
import '../widgets/video_grid.dart';
import '../utils/logger.dart';

class CallScreen extends StatefulWidget {
  final Meeting meeting;
  final String participantId;
  final String participantName;
  final bool isHost;
  final String? appointmentId;
  final DateTime? scheduledEndTime;

  const CallScreen({
    super.key,
    required this.meeting,
    required this.participantId,
    required this.participantName,
    required this.isHost,
    this.appointmentId,
    this.scheduledEndTime,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final WebRTCService _webrtcService = WebRTCService();
  final SocketSignalingService _socketService = SocketSignalingService();
  final ChatService _chatService = ChatService();

  bool _isAudioOn = true;
  bool _isVideoOn = true;
  bool _isConnecting = true;
  bool _isChatOpen = false;
  int _unreadMessages = 0;
  Timer? _callTimer;
  int _callDuration = 0;
  bool _isEndingCall = false;
  bool _isParticipantsPanelOpen = false;
  int _remainingSeconds = 0;
  bool _showTimeWarning = false;
  
  final Map<String, ParticipantState> _participants = {};

  @override
  void initState() {
    super.initState();
    _initializeCall();
  }

  Future<void> _initializeCall() async {
    try {
      Logger.log('🚀 Initializing call...');
      
      // Initialize WebRTC
      await _webrtcService.initialize();
      await _webrtcService.startLocalStream();
      
      // No DB - skip meeting status update
      Logger.log('✅ Skipping meeting status update (No DB)');
      
      // Set up WebRTC callbacks
      _webrtcService.onRemoteStreamAdded = (participantId) {
        Logger.log('🎥 Remote stream added for $participantId');
        if (mounted) setState(() {});
      };
      
      _webrtcService.onRemoteStreamRemoved = (participantId) {
        Logger.log('🎥 Remote stream removed for $participantId');
        if (mounted) setState(() {});
      };
      
      // Initialize chat service
      _chatService.initialize(
        participantId: widget.participantId,
        participantName: widget.participantName,
        meetingId: widget.meeting.meetingId,
      );
      
      // Listen for new messages to update unread count
      _chatService.messageStream.listen((message) {
        if (!message.isMe && !_isChatOpen && mounted) {
          setState(() => _unreadMessages++);
        }
      });
      
      // Connect to Socket.IO server
      Logger.log('🔌 Connecting to signaling server...');
      await _socketService.connect();
      
      // Wait for connection with timeout
      int attempts = 0;
      while (!_socketService.isConnected && attempts < 10) {
        await Future.delayed(const Duration(milliseconds: 500));
        attempts++;
      }
      
      if (!_socketService.isConnected) {
        Logger.log('⚠️ Failed to connect to signaling server');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to connect to server. Please check your connection.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 5),
            ),
          );
        }
        return;
      }
      
      Logger.log('✅ Connected to signaling server');
      
      // If doctor (host) and has appointment ID, notify server that call started
      if (widget.isHost && widget.appointmentId != null) {
        _socketService.startCall(
          appointmentId: widget.appointmentId!,
          meetingId: widget.meeting.meetingId,
          doctorName: widget.participantName,
        );
      }
      
      // Join the meeting room
      _socketService.joinMeeting(
        meetingId: widget.meeting.meetingId,
        participantId: widget.participantId,
        participantName: widget.participantName,
        isHost: widget.isHost,
        appointmentId: widget.appointmentId,
      );
      
      await _setupWebRTC();
      _startCallTimer();
      
      Logger.log('✅ Call initialized successfully');
    } catch (e) {
      Logger.error('Error initializing call', e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to initialize call: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _setupWebRTC() async {
    // Add myself to participants list
    _participants[widget.participantId] = ParticipantState(
      participantId: widget.participantId,
      participantName: widget.participantName,
      isHost: widget.isHost,
      joinedAt: DateTime.now(),
    );
    
    // Set up Socket.IO event listeners
    _socketService.onParticipantJoined = (data) async {
      final participantId = data['participantId'];
      final participantName = data['participantName'];
      final isHost = data['isHost'] ?? false;
      
      Logger.log('✅ Participant joined: $participantName ($participantId)');
      
      // Add to participants list
      setState(() {
        _participants[participantId] = ParticipantState(
          participantId: participantId,
          participantName: participantName,
          isHost: isHost,
          joinedAt: DateTime.now(),
        );
      });
      
      // Send offer to new participant (mesh networking - everyone connects to everyone)
      // Only send if I joined before them (to avoid duplicate connections)
      if (widget.participantId.compareTo(participantId) < 0) {
        await _sendOfferToParticipant(participantId);
      }
    };

    _socketService.onExistingParticipants = (participants) async {
      Logger.log('📋 Existing participants: ${participants.length}');
      
      // Add existing participants to list
      setState(() {
        for (var p in participants) {
          _participants[p['participantId']] = ParticipantState(
            participantId: p['participantId'],
            participantName: p['participantName'],
            isHost: p['isHost'] ?? false,
            joinedAt: DateTime.now(),
          );
        }
      });
      
      // Connect to all existing participants who joined before me
      for (var p in participants) {
        final theirId = p['participantId'];
        // Only connect if they joined before me (to avoid duplicate connections)
        if (widget.participantId.compareTo(theirId) > 0) {
          Logger.log('🎯 Will receive offer from: ${p['participantName']}');
        }
      }
    };

    _socketService.onOffer = (data) async {
      Logger.log('📨 Received offer from ${data['fromParticipantName']}');
      final offer = data['offer'];
      final fromParticipantId = data['fromParticipantId'];
      
      await _webrtcService.setRemoteDescription(fromParticipantId, offer);
      
      // Set up data channel callback (joiner receives it)
      _webrtcService.onDataChannel = (dataChannel) {
        if (dataChannel.label == 'chat') {
          _chatService.setDataChannel(dataChannel);
        }
      };
      
      // Set up ICE candidate callback
      _webrtcService.setOnIceCandidate(fromParticipantId, (candidate) {
        _socketService.sendIceCandidate(
          meetingId: widget.meeting.meetingId,
          toParticipantId: fromParticipantId,
          candidate: candidate,
        );
      });
      
      final answer = await _webrtcService.createAnswer(fromParticipantId);
      _socketService.sendAnswer(
        meetingId: widget.meeting.meetingId,
        toParticipantId: fromParticipantId,
        answer: answer,
      );
      
      if (mounted) {
        setState(() => _isConnecting = false);
      }
    };

    _socketService.onAnswer = (data) async {
      Logger.log('✅ Received answer from ${data['fromParticipantId']}');
      final answer = data['answer'];
      final fromParticipantId = data['fromParticipantId'];
      
      await _webrtcService.setRemoteDescription(fromParticipantId, answer);
      
      if (mounted) {
        setState(() => _isConnecting = false);
      }
    };

    _socketService.onIceCandidate = (data) async {
      Logger.log('🧊 Received ICE candidate from ${data['fromParticipantId']}');
      final candidate = data['candidate'];
      final fromParticipantId = data['fromParticipantId'];
      await _webrtcService.addIceCandidate(fromParticipantId, candidate);
    };

    _socketService.onParticipantLeft = (data) {
      Logger.log('👋 Participant left: ${data['participantName']}');
      final participantId = data['participantId'];
      
      // Remove peer connection and renderer
      _webrtcService.removeParticipant(participantId);
      
      setState(() {
        _participants.remove(participantId);
      });
    };

    _socketService.onParticipantStateChanged = (data) {
      final participantId = data['participantId'];
      if (_participants.containsKey(participantId)) {
        setState(() {
          _participants[participantId] = _participants[participantId]!.copyWith(
            isAudioMuted: data['isAudioMuted'],
            isVideoOff: data['isVideoOff'],
          );
        });
      }
    };

    _socketService.onMutedByHost = () {
      _isAudioOn = false;
      _webrtcService.toggleAudio();
      setState(() {});
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have been muted by the host'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
        ),
      );
    };

    _socketService.onUnmutedByHost = () {
      _isAudioOn = true;
      _webrtcService.toggleAudio();
      setState(() {});
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have been unmuted by the host'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    };

    _socketService.onRemovedByHost = () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have been removed from the meeting by the host'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      });
    };
  }

  Future<void> _sendOfferToParticipant(String participantId) async {
    Logger.log('📤 Sending offer to participant: $participantId');
    
    // Set up ICE candidate callback
    _webrtcService.setOnIceCandidate(participantId, (candidate) {
      _socketService.sendIceCandidate(
        meetingId: widget.meeting.meetingId,
        toParticipantId: participantId,
        candidate: candidate,
      );
    });
    
    // Set up data channel callback (for joiner)
    _webrtcService.onDataChannel = (dataChannel) {
      if (dataChannel.label == 'chat') {
        _chatService.setDataChannel(dataChannel);
      }
    };
    
    final offer = await _webrtcService.createOffer(participantId);
    
    // Set up data channel for chat (host creates it)
    final peerConnection = _webrtcService.getPeerConnection(participantId);
    if (peerConnection != null) {
      await _chatService.createDataChannel(peerConnection);
    }
    
    _socketService.sendOffer(
      meetingId: widget.meeting.meetingId,
      toParticipantId: participantId,
      offer: offer,
    );
  }

  void _startCallTimer() {
    // Calculate initial remaining time if scheduled end time exists
    if (widget.scheduledEndTime != null) {
      final now = DateTime.now();
      _remainingSeconds = widget.scheduledEndTime!.difference(now).inSeconds;
      if (_remainingSeconds < 0) _remainingSeconds = 0;
      
      Logger.log('⏱️ ========== CALL TIMER STARTED ==========');
      Logger.log('   Current time: $now');
      Logger.log('   Scheduled end time: ${widget.scheduledEndTime}');
      Logger.log('   Difference (seconds): $_remainingSeconds');
      Logger.log('   Difference (minutes): ${(_remainingSeconds / 60).toStringAsFixed(2)}');
      Logger.log('   Difference (hours): ${(_remainingSeconds / 3600).toStringAsFixed(2)}');
      Logger.log('   Is Host: ${widget.isHost}');
      Logger.log('   Appointment ID: ${widget.appointmentId}');
      Logger.log('==========================================');
    } else {
      Logger.log('⚠️ No scheduled end time provided - timer will not show countdown');
    }
    
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _callDuration++;
          
          // Update countdown if scheduled end time exists
          if (widget.scheduledEndTime != null) {
            _remainingSeconds = widget.scheduledEndTime!.difference(DateTime.now()).inSeconds;
            
            if (_remainingSeconds < 0) {
              _remainingSeconds = 0;
            }
            
            // Show warning when 5 minutes remaining
            if (_remainingSeconds <= 300 && _remainingSeconds > 0) {
              _showTimeWarning = true;
            }
            
            // Auto-end call when time is up
            if (_remainingSeconds <= 0) {
              Logger.log('⏰ Scheduled time ended - auto-ending call');
              _autoEndCall();
            }
          }
        });
      }
    });
  }
  
  Future<void> _autoEndCall() async {
    if (_isEndingCall) return;
    
    // Show notification
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Appointment time has ended'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
    }
    
    // Wait a moment for user to see the message
    await Future.delayed(const Duration(seconds: 2));
    
    // End the call
    await _endCall();
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }
  
  String _formatRemainingTime(int seconds) {
    if (seconds <= 0) return '00:00';
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _toggleAudio() {
    _webrtcService.toggleAudio();
    setState(() => _isAudioOn = !_isAudioOn);
    
    // Update state on server
    _socketService.updateParticipantState(
      meetingId: widget.meeting.meetingId,
      participantId: widget.participantId,
      isAudioMuted: !_isAudioOn,
    );
  }

  void _toggleVideo() {
    _webrtcService.toggleVideo();
    setState(() => _isVideoOn = !_isVideoOn);
    
    // Update state on server
    _socketService.updateParticipantState(
      meetingId: widget.meeting.meetingId,
      participantId: widget.participantId,
      isVideoOff: !_isVideoOn,
    );
  }

  void _switchCamera() {
    _webrtcService.switchCamera();
  }

  void _toggleChat() {
    setState(() {
      _isChatOpen = !_isChatOpen;
      if (_isChatOpen) {
        _unreadMessages = 0;
      }
    });

    if (_isChatOpen) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        isDismissible: true,
        enableDrag: true,
        useSafeArea: true,
        builder: (context) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            expand: false,
            builder: (context, scrollController) => ChatPanel(
              chatService: _chatService,
            ),
          ),
        ),
      ).then((_) {
        setState(() => _isChatOpen = false);
      });
    }
  }

  void _showParticipants() {
    // Prevent opening multiple panels
    if (_isParticipantsPanelOpen) return;
    
    setState(() => _isParticipantsPanelOpen = true);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => ParticipantsPanel(
          participants: _participants.values.toList(),
          myParticipantId: widget.participantId,
          isHost: widget.isHost,
          onMuteParticipant: (participantId) {
            _socketService.muteParticipant(
              meetingId: widget.meeting.meetingId,
              participantId: participantId,
            );
          },
          onUnmuteParticipant: (participantId) {
            _socketService.unmuteParticipant(
              meetingId: widget.meeting.meetingId,
              participantId: participantId,
            );
          },
          onRemoveParticipant: (participantId) {
            _socketService.removeParticipant(
              meetingId: widget.meeting.meetingId,
              participantId: participantId,
            );
          },
        ),
      ),
    ).then((_) {
      setState(() => _isParticipantsPanelOpen = false);
    });
  }

  Future<void> _endCall() async {
    // Prevent multiple clicks
    if (_isEndingCall) {
      Logger.log('⚠️ Already ending call, ignoring...');
      return;
    }
    
    setState(() => _isEndingCall = true);
    
    try {
      Logger.log('🔴 Ending call...');
      
      // Cancel timer first
      _callTimer?.cancel();
      
      // Leave Socket.IO room (only if connected)
      if (_socketService.isConnected) {
        _socketService.leaveMeeting(
          meetingId: widget.meeting.meetingId,
          participantId: widget.participantId,
        );
        // Wait a bit for socket message to send
        await Future.delayed(const Duration(milliseconds: 300));
      } else {
        Logger.log('⚠️ Socket not connected, skipping leave meeting');
      }
      
      // Dispose services first (don't wait for Firebase)
      try {
        _chatService.dispose();
      } catch (e) {
        Logger.error('Error disposing chat service', e);
      }
      
      try {
        await _webrtcService.dispose();
      } catch (e) {
        Logger.error('Error disposing WebRTC service', e);
      }
      
      // If doctor (host) and has appointment ID, notify server that call ended
      if (widget.isHost && widget.appointmentId != null) {
        try {
          _socketService.endCall(appointmentId: widget.appointmentId!);
        } catch (e) {
          Logger.error('Error ending call on server', e);
        }
      }
      
      // Disconnect socket
      try {
        _socketService.disconnect();
      } catch (e) {
        Logger.error('Error disconnecting socket', e);
      }
      
      Logger.log('✅ Call ended successfully');
      
      // Navigate back immediately
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
      
      // Update Firebase in background (don't block navigation)
      _updateFirebaseInBackground();
      
    } catch (e) {
      Logger.error('Error ending call', e);
      // Still try to navigate back even if there's an error
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }
  }
  
  void _updateFirebaseInBackground() {
    // No DB - skip background update
    Logger.log('✅ Skipping Firebase update (No DB)');
  }

  @override
  Widget build(BuildContext context) {
    // Build participant names map for video grid
    final participantNames = <String, String>{};
    for (var participant in _participants.values) {
      participantNames[participant.participantId] = participant.participantName;
    }
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Video grid - centered with proper padding
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(top: 140, bottom: 180),
              child: VideoGrid(
                remoteRenderers: _webrtcService.remoteRenderers,
                localRenderer: _webrtcService.localRenderer,
                localParticipantName: widget.participantName,
                participantNames: participantNames,
              ),
            ),
          ),

          // Top gradient overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.8),
                    Colors.black.withValues(alpha: 0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Bottom gradient overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 220,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.8),
                    Colors.black.withValues(alpha: 0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Top Left - Participants button
          Positioned(
            top: 50,
            left: 20,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _showParticipants,
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white24, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.people, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '${_participants.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Top Right - Switch Camera button
          Positioned(
            top: 50,
            right: 20,
            child: _buildFloatingButton(
              icon: Icons.cameraswitch,
              onPressed: _switchCamera,
              tooltip: 'Switch Camera',
            ),
          ),

          // Top Center - Meeting Info
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(
                        widget.meeting.meetingId,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _isConnecting ? Colors.orange : Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isConnecting ? 'Connecting...' : _formatDuration(_callDuration),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      // Show countdown timer if scheduled end time exists
                      if (widget.scheduledEndTime != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _showTimeWarning 
                                ? Colors.orange.withValues(alpha: 0.9)
                                : Colors.blue.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _showTimeWarning ? Icons.warning_amber : Icons.timer,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Time Remaining: ${_formatRemainingTime(_remainingSeconds)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Right - Chat button with badge
          Positioned(
            bottom: 200,
            right: 20,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                _buildFloatingButton(
                  icon: Icons.chat_bubble,
                  onPressed: _toggleChat,
                  tooltip: 'Chat',
                ),
                if (_unreadMessages > 0)
                  Positioned(
                    top: -5,
                    right: -5,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Text(
                        _unreadMessages > 9 ? '9+' : '$_unreadMessages',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Bottom controls bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMainControlButton(
                    icon: _isAudioOn ? Icons.mic : Icons.mic_off,
                    label: _isAudioOn ? 'Mute' : 'Unmute',
                    onPressed: _toggleAudio,
                    isActive: _isAudioOn,
                  ),
                  _buildMainControlButton(
                    icon: _isVideoOn ? Icons.videocam : Icons.videocam_off,
                    label: _isVideoOn ? 'Stop Video' : 'Start Video',
                    onPressed: _toggleVideo,
                    isActive: _isVideoOn,
                  ),
                  _buildEndCallButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Material(
      color: Colors.transparent,
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24, width: 1),
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
        ),
      ),
    );
  }

  Widget _buildMainControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required bool isActive,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 90,
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: isActive 
                ? Colors.white.withValues(alpha: 0.2) 
                : Colors.red.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive ? Colors.white24 : Colors.red.shade700,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEndCallButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _endCall,
        borderRadius: BorderRadius.circular(35),
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.red.withValues(alpha: 0.5),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.call_end,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),
    );
  }



  @override
  void dispose() {
    _callTimer?.cancel();
    _webrtcService.dispose();
    super.dispose();
  }
}
