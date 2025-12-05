import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class ChatScreen extends StatefulWidget {
  final String appointmentId;
  final String patientId;
  final String patientName;
  final String doctorId;
  final String doctorName;
  final bool isDoctor;

  const ChatScreen({
    super.key,
    required this.appointmentId,
    required this.patientId,
    required this.patientName,
    required this.doctorId,
    required this.doctorName,
    required this.isDoctor,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
  
  List<ChatMessage> _messages = [];
  bool _isDoctorOnline = false;
  bool _isLoading = true;
  bool _isRecording = false;
  bool _recorderInitialized = false;
  String? _currentUserId;
  String? _recordingPath;
  List<double> _audioLevels = List.filled(20, 0.0);

  @override
  void initState() {
    super.initState();
    _initChat();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    if (_recorderInitialized) {
      _audioRecorder.closeRecorder();
    }
    _updateUserStatus(false);
    super.dispose();
  }

  Future<void> _initChat() async {
    final prefs = await SharedPreferences.getInstance();
    _currentUserId = prefs.getString("userKey");
    
    // Initialize chat room if it doesn't exist
    await _initializeChatRoom();
    
    // Update user status to online
    await _updateUserStatus(true);
    
    // Listen to messages
    _listenToMessages();
    
    // Listen to doctor status
    _listenToDoctorStatus();
    
    // Send notification if patient initiated chat
    if (!widget.isDoctor) {
      await _sendChatNotification();
    }
    
    setState(() => _isLoading = false);
  }

  Future<void> _initializeChatRoom() async {
    final chatRef = _database.child('healthcare/chats/${widget.appointmentId}');
    final snapshot = await chatRef.get();
    
    if (!snapshot.exists) {
      await chatRef.set({
        'appointmentId': widget.appointmentId,
        'patientId': widget.patientId,
        'patientName': widget.patientName,
        'doctorId': widget.doctorId,
        'doctorName': widget.doctorName,
        'createdAt': ServerValue.timestamp,
        'doctorOnline': false,
        'patientOnline': false,
      });
    }
  }

  Future<void> _updateUserStatus(bool isOnline) async {
    final statusPath = widget.isDoctor 
        ? 'healthcare/chats/${widget.appointmentId}/doctorOnline'
        : 'healthcare/chats/${widget.appointmentId}/patientOnline';
    
    await _database.child(statusPath).set(isOnline);
    
    if (widget.isDoctor && isOnline) {
      // Send system message when doctor joins
      await _sendSystemMessage("Dr. ${widget.doctorName} has joined the chat");
    }
  }

  void _listenToDoctorStatus() {
    _database.child('healthcare/chats/${widget.appointmentId}/doctorOnline').onValue.listen((event) {
      if (mounted && event.snapshot.exists) {
        setState(() {
          _isDoctorOnline = event.snapshot.value as bool? ?? false;
        });
      }
    });
  }

  void _listenToMessages() {
    _database.child('healthcare/chats/${widget.appointmentId}/messages').onValue.listen((event) {
      if (!mounted) return;
      
      if (event.snapshot.exists) {
        final messagesData = event.snapshot.value as Map<dynamic, dynamic>;
        final messages = <ChatMessage>[];
        
        messagesData.forEach((key, value) {
          final messageMap = value as Map<dynamic, dynamic>;
          messages.add(ChatMessage.fromMap(key, messageMap));
        });
        
        messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        
        setState(() {
          _messages = messages;
        });
        
        // Scroll to bottom
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    
    final messageRef = _database.child('healthcare/chats/${widget.appointmentId}/messages').push();
    
    await messageRef.set({
      'senderId': _currentUserId,
      'senderName': widget.isDoctor ? widget.doctorName : widget.patientName,
      'message': text,
      'timestamp': ServerValue.timestamp,
      'type': 'text',
      'isDoctor': widget.isDoctor,
    });
    
    // Update last message info
    await _database.child('healthcare/chats/${widget.appointmentId}/lastMessage').set({
      'text': text,
      'timestamp': ServerValue.timestamp,
      'senderId': _currentUserId,
    });
    
    _messageController.clear();
  }

  Future<void> _recordVoiceNote() async {
    if (_isRecording) {
      // Stop recording and send
      await _stopRecordingAndSend();
    } else {
      // Start recording
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    try {
      // Request permission
      final status = await Permission.microphone.request();
      if (!status.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Microphone permission required")),
          );
        }
        return;
      }

      // Initialize recorder if not already
      if (!_recorderInitialized) {
        await _audioRecorder.openRecorder();
        _recorderInitialized = true;
      }

      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/voice_${DateTime.now().millisecondsSinceEpoch}.aac';
      
      await _audioRecorder.startRecorder(
        toFile: path,
        codec: Codec.aacADTS,
      );
      
      // Start listening to audio levels
      _audioRecorder.onProgress!.listen((event) {
        if (mounted && _isRecording) {
          final decibels = event.decibels ?? 0.0;
          setState(() {
            // Shift levels and add new one
            _audioLevels.removeAt(0);
            // Normalize decibels to 0-1 range (typical range is -160 to 0)
            final normalized = ((decibels + 160) / 160).clamp(0.0, 1.0);
            _audioLevels.add(normalized);
          });
        }
      });
      
      setState(() {
        _isRecording = true;
        _recordingPath = path;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to start recording: $e")),
        );
      }
    }
  }

  Future<void> _stopRecordingAndSend() async {
    try {
      await _audioRecorder.stopRecorder();
      
      setState(() {
        _isRecording = false;
        _audioLevels = List.filled(20, 0.0);
      });
      
      if (_recordingPath != null) {
        // Upload to Firebase Storage
        final file = File(_recordingPath!);
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('healthcare/voice_notes/${widget.appointmentId}/${DateTime.now().millisecondsSinceEpoch}.aac');
        
        await storageRef.putFile(file);
        final downloadUrl = await storageRef.getDownloadURL();
        
        // Send voice note message
        final messageRef = _database.child('healthcare/chats/${widget.appointmentId}/messages').push();
        
        await messageRef.set({
          'senderId': _currentUserId,
          'senderName': widget.isDoctor ? widget.doctorName : widget.patientName,
          'message': downloadUrl,
          'timestamp': ServerValue.timestamp,
          'type': 'voice',
          'isDoctor': widget.isDoctor,
        });
        
        // Update last message info
        await _database.child('healthcare/chats/${widget.appointmentId}/lastMessage').set({
          'text': '🎤 Voice message',
          'timestamp': ServerValue.timestamp,
          'senderId': _currentUserId,
        });
        
        // Delete temporary file
        await file.delete();
        _recordingPath = null;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to send voice note: $e")),
        );
      }
    }
  }

  Future<void> _sendSystemMessage(String message) async {
    final messageRef = _database.child('healthcare/chats/${widget.appointmentId}/messages').push();
    
    await messageRef.set({
      'senderId': 'system',
      'senderName': 'System',
      'message': message,
      'timestamp': ServerValue.timestamp,
      'type': 'system',
      'isDoctor': false,
    });
  }

  Future<void> _sendChatNotification() async {
    final notificationRef = _database.child('healthcare/notifications/${widget.doctorId}').push();
    
    await notificationRef.set({
      'type': 'chat_request',
      'title': 'New Chat Request',
      'message': '${widget.patientName} wants to chat',
      'appointmentId': widget.appointmentId,
      'patientId': widget.patientId,
      'patientName': widget.patientName,
      'timestamp': ServerValue.timestamp,
      'read': false,
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.isDoctor ? widget.patientName : widget.doctorName),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.isDoctor ? widget.patientName : "Dr. ${widget.doctorName}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (!widget.isDoctor)
              Text(
                _isDoctorOnline ? "Online" : "Offline",
                style: TextStyle(
                  fontSize: 12,
                  color: _isDoctorOnline ? Colors.green : Colors.grey,
                ),
              ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Waiting message for patient
          if (!widget.isDoctor && !_isDoctorOnline)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.orange.shade50,
              child: Row(
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Waiting for doctor to join...",
                    style: TextStyle(color: Colors.orange.shade900, fontSize: 13),
                  ),
                ],
              ),
            ),
          
          // Messages list
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Text(
                      "No messages yet. Start the conversation!",
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return _buildMessageBubble(message);
                    },
                  ),
          ),
          
          // Message input
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: _isRecording
                ? _buildRecordingUI()
                : Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: "Type a message...",
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          maxLines: null,
                          textCapitalization: TextCapitalization.sentences,
                          onSubmitted: (_) => _sendMessage(),
                          textInputAction: TextInputAction.send,
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: Colors.green,
                        child: IconButton(
                          icon: const Icon(Icons.mic, color: Colors.white, size: 20),
                          onPressed: _recordVoiceNote,
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: IconButton(
                          icon: const Icon(Icons.send, color: Colors.white, size: 20),
                          onPressed: () {
                            if (_isRecording) {
                              _stopRecordingAndSend();
                            } else {
                              _sendMessage();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isMe = message.senderId == _currentUserId;
    final isSystem = message.type == 'system';
    final isVoice = message.type == 'voice';
    
    if (isSystem) {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            message.message,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
        ),
      );
    }
    
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Text(
                message.senderName,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            if (!isMe) const SizedBox(height: 4),
            if (isVoice)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.play_circle_filled,
                    color: isMe ? Colors.white : Colors.blue,
                    size: 32,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Voice message",
                    style: TextStyle(
                      fontSize: 14,
                      color: isMe ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              )
            else
              Text(
                message.message,
                style: TextStyle(
                  fontSize: 14,
                  color: isMe ? Colors.white : Colors.black87,
                ),
              ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                fontSize: 10,
                color: isMe ? Colors.white70 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    
    if (date.day == now.day && date.month == now.month && date.year == now.year) {
      return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    } else {
      return "${date.day}/${date.month} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    }
  }

  Widget _buildRecordingUI() {
    return Row(
      children: [
        const SizedBox(width: 8),
        Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          "Recording...",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.red,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(
              20,
              (index) {
                final level = _audioLevels[index];
                final height = 8 + (level * 32); // Min 8, max 40
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.5),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    width: 3,
                    height: height,
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () async {
            await _audioRecorder.stopRecorder();
            setState(() {
              _isRecording = false;
              _recordingPath = null;
              _audioLevels = List.filled(20, 0.0);
            });
          },
        ),
        const SizedBox(width: 8),
        CircleAvatar(
          backgroundColor: Colors.blue,
          child: IconButton(
            icon: const Icon(Icons.send, color: Colors.white, size: 20),
            onPressed: _stopRecordingAndSend,
          ),
        ),
      ],
    );
  }
}

class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String message;
  final int timestamp;
  final String type;
  final bool isDoctor;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.timestamp,
    required this.type,
    required this.isDoctor,
  });

  factory ChatMessage.fromMap(String id, Map<dynamic, dynamic> map) {
    return ChatMessage(
      id: id,
      senderId: map['senderId']?.toString() ?? '',
      senderName: map['senderName']?.toString() ?? '',
      message: map['message']?.toString() ?? '',
      timestamp: map['timestamp'] as int? ?? 0,
      type: map['type']?.toString() ?? 'text',
      isDoctor: map['isDoctor'] as bool? ?? false,
    );
  }
}
