import 'dart:async';
import 'package:flutter/material.dart';
import '../models/call_model.dart';
import '../services/socket_signaling_service.dart';
import '../utils/logger.dart';
import 'call_screen.dart';

class WaitingRoomScreen extends StatefulWidget {
  final Meeting meeting;
  final String participantId;
  final String participantName;
  final String? appointmentId;
  final DateTime? scheduledEndTime;
  final int duration;

  const WaitingRoomScreen({
    super.key,
    required this.meeting,
    required this.participantId,
    required this.participantName,
    this.appointmentId,
    this.scheduledEndTime,
    this.duration = 30,
  });

  @override
  State<WaitingRoomScreen> createState() => _WaitingRoomScreenState();
}

class _WaitingRoomScreenState extends State<WaitingRoomScreen>
    with SingleTickerProviderStateMixin {
  final SocketSignalingService _socketService = SocketSignalingService();
  late AnimationController _pulseController;
  Timer? _waitingTimer;
  int _waitingSeconds = 0;
  bool _isConnecting = true;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _initializeWaitingRoom();
    _startWaitingTimer();
  }

  Future<void> _initializeWaitingRoom() async {
    try {
      Logger.log('🚪 Patient entering waiting room...');
      
      // Connect to Socket.IO server
      await _socketService.connect();
      
      // Wait for connection
      int attempts = 0;
      while (!_socketService.isConnected && attempts < 10) {
        await Future.delayed(const Duration(milliseconds: 500));
        attempts++;
      }
      
      if (!_socketService.isConnected) {
        Logger.log('⚠️ Failed to connect to server');
        if (mounted) {
          setState(() => _isConnecting = false);
          _showError('Failed to connect to server');
        }
        return;
      }
      
      if (mounted) {
        setState(() => _isConnecting = false);
      }
      Logger.log('✅ Connected to server - waiting for doctor');
      Logger.log('📡 Setting up event listeners...');
      
      // Listen for ANY participant joining
      _socketService.onParticipantJoined = (data) {
        Logger.log('🔔 Participant joined event received: $data');
        
        final isHost = data['isHost'] ?? false;
        final participantName = data['participantName'] ?? '';
        
        Logger.log('👤 Participant: $participantName, isHost: $isHost');
        
        // If a host (doctor) joins, automatically enter the meeting
        if (isHost) {
          Logger.log('👨‍⚕️ DOCTOR DETECTED! Joining meeting now...');
          if (mounted) {
            _joinMeeting();
          } else {
            Logger.log('⚠️ Widget not mounted, cannot join');
          }
        } else {
          Logger.log('ℹ️ Not a host, continuing to wait...');
        }
      };
      
      // Join the meeting room (but stay in waiting room UI)
      Logger.log('📞 Joining meeting room: ${widget.meeting.meetingId}');
      Logger.log('   Participant: ${widget.participantName} (${widget.participantId})');
      Logger.log('   isHost: false');
      
      _socketService.joinMeeting(
        meetingId: widget.meeting.meetingId,
        participantId: widget.participantId,
        participantName: widget.participantName,
        isHost: false,
        appointmentId: widget.appointmentId,
      );
      
      Logger.log('✅ Join meeting request sent');
      
      // Check if doctor is already in the meeting
      _socketService.onExistingParticipants = (participants) {
        Logger.log('📋 Received existing participants: ${participants.length}');
        
        // Log all participants
        for (var i = 0; i < participants.length; i++) {
          final p = participants[i];
          Logger.log('   Participant $i: ${p['participantName']} (isHost: ${p['isHost']})');
        }
        
        // Check if any existing participant is a host (doctor)
        for (var p in participants) {
          final isHost = p['isHost'] ?? false;
          if (isHost) {
            Logger.log('👨‍⚕️ DOCTOR ALREADY IN MEETING! Joining now...');
            if (mounted) {
              // Small delay to show the UI briefly
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted) {
                  _joinMeeting();
                } else {
                  Logger.log('⚠️ Widget not mounted after delay');
                }
              });
            } else {
              Logger.log('⚠️ Widget not mounted, cannot join');
            }
            break;
          }
        }
      };
      
    } catch (e) {
      Logger.error('Error initializing waiting room', e);
      if (mounted) {
        _showError('Failed to initialize waiting room: $e');
      }
    }
  }

  void _startWaitingTimer() {
    _waitingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() => _waitingSeconds++);
      }
    });
  }

  String _formatWaitingTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _joinMeeting() {
    Logger.log('🚀 Transitioning from waiting room to call screen...');
    
    if (!mounted) {
      Logger.log('⚠️ Cannot join - widget not mounted');
      return;
    }
    
    // Navigate to call screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CallScreen(
          meeting: widget.meeting,
          participantId: widget.participantId,
          participantName: widget.participantName,
          isHost: false,
          appointmentId: widget.appointmentId,
          scheduledEndTime: widget.scheduledEndTime,
        ),
      ),
    );
    
    Logger.log('✅ Navigation to call screen initiated');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void _leaveWaitingRoom() {
    _socketService.leaveMeeting(
      meetingId: widget.meeting.meetingId,
      participantId: widget.participantId,
    );
    _socketService.disconnect();
    
    // Navigate back
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          _leaveWaitingRoom();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A2E),
        body: SafeArea(
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: _leaveWaitingRoom,
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: Colors.white70,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatWaitingTime(_waitingSeconds),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Main content
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Animated icon
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: 1.0 + (_pulseController.value * 0.1),
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue.withValues(alpha: 0.2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.withValues(
                                        alpha: 0.3 * _pulseController.value,
                                      ),
                                      blurRadius: 40,
                                      spreadRadius: 20,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.video_call,
                                  size: 60,
                                  color: Colors.blue,
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 40),

                        // Status text
                        if (_isConnecting) ...[
                          const Text(
                            'Connecting...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Please wait while we connect you',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ] else ...[
                          const Text(
                            'Waiting for Doctor',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'The doctor will join shortly',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],

                        const SizedBox(height: 40),

                        // Meeting info card
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Column(
                            children: [
                              _buildInfoRow(
                                Icons.meeting_room,
                                'Meeting ID',
                                widget.meeting.meetingId,
                              ),
                              const SizedBox(height: 16),
                              _buildInfoRow(
                                Icons.person,
                                'Your Name',
                                widget.participantName,
                              ),
                              if (widget.duration > 0) ...[
                                const SizedBox(height: 16),
                                _buildInfoRow(
                                  Icons.timer,
                                  'Duration',
                                  '${widget.duration} minutes',
                                ),
                              ],
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Tips section
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.blue.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.lightbulb_outline,
                                    color: Colors.blue.shade300,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'While you wait',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _buildTip('Ensure you\'re in a quiet environment'),
                              _buildTip('Check your internet connection'),
                              _buildTip('Have your medical records ready'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom status bar
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  border: Border(
                    top: BorderSide(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _isConnecting ? Colors.orange : Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _isConnecting
                          ? 'Connecting to server...'
                          : 'Connected • Waiting for doctor',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue.shade300, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.blue.shade300,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waitingTimer?.cancel();
    super.dispose();
  }
}
