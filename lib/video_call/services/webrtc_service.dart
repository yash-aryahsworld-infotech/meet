import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'signaling_service.dart';
import '../utils/logger.dart';

class WebRTCService {
  // Multiple peer connections - one per remote participant
  final Map<String, RTCPeerConnection> _peerConnections = {};
  MediaStream? _localStream;
  final SignalingService _signalingService = SignalingService();

  final RTCVideoRenderer localRenderer = RTCVideoRenderer();
  
  // Multiple remote renderers - one per remote participant
  final Map<String, RTCVideoRenderer> remoteRenderers = {};

  final Map<String, dynamic> _iceServers = {
    'iceServers': [
      {'urls': 'stun:stun.l.google.com:19302'},
      {'urls': 'stun:stun1.l.google.com:19302'},
      {'urls': 'stun:stun2.l.google.com:19302'},
    ]
  };

  final Map<String, dynamic> _mediaConstraints = {
    'audio': true,
    'video': {
      'mandatory': {
        'minWidth': '640',
        'minHeight': '480',
        'minFrameRate': '30',
      },
      'facingMode': 'user',
      'optional': [],
    }
  };

  Future<void> initialize() async {
    await localRenderer.initialize();
  }

  Future<void> startLocalStream() async {
    _localStream = await navigator.mediaDevices.getUserMedia(_mediaConstraints);
    localRenderer.srcObject = _localStream;
  }

  Function(RTCDataChannel)? onDataChannel;
  Function(String participantId)? onRemoteStreamAdded;
  Function(String participantId)? onRemoteStreamRemoved;

  Future<RTCPeerConnection> _createPeerConnection(String participantId) async {
    final peerConnection = await createPeerConnection(_iceServers);

    peerConnection.onIceCandidate = (RTCIceCandidate candidate) {
      // Will be handled by caller
    };

    peerConnection.onTrack = (RTCTrackEvent event) async {
      if (event.streams.isNotEmpty) {
        Logger.log('📹 Received remote stream from $participantId');
        
        // Create renderer for this participant if not exists
        if (!remoteRenderers.containsKey(participantId)) {
          final renderer = RTCVideoRenderer();
          await renderer.initialize();
          remoteRenderers[participantId] = renderer;
        }
        
        // Set the remote stream
        remoteRenderers[participantId]!.srcObject = event.streams[0];
        
        // Notify that stream was added
        if (onRemoteStreamAdded != null) {
          onRemoteStreamAdded!(participantId);
        }
      }
    };

    peerConnection.onIceConnectionState = (RTCIceConnectionState state) {
      Logger.log('ICE Connection State for $participantId: $state');
      
      if (state == RTCIceConnectionState.RTCIceConnectionStateClosed ||
          state == RTCIceConnectionState.RTCIceConnectionStateFailed) {
        _removePeerConnection(participantId);
      }
    };

    peerConnection.onDataChannel = (RTCDataChannel channel) {
      Logger.log('📡 Data channel received: ${channel.label}');
      if (onDataChannel != null) {
        onDataChannel!(channel);
      }
    };

    if (_localStream != null) {
      _localStream!.getTracks().forEach((track) {
        peerConnection.addTrack(track, _localStream!);
      });
    }

    _peerConnections[participantId] = peerConnection;
    return peerConnection;
  }

  RTCPeerConnection? getPeerConnection(String participantId) {
    return _peerConnections[participantId];
  }

  Future<void> _removePeerConnection(String participantId) async {
    final peerConnection = _peerConnections.remove(participantId);
    await peerConnection?.close();
    
    final renderer = remoteRenderers.remove(participantId);
    await renderer?.dispose();
    
    if (onRemoteStreamRemoved != null) {
      onRemoteStreamRemoved!(participantId);
    }
  }

  Future<Map<String, dynamic>> createOffer(String participantId) async {
    final peerConnection = await _createPeerConnection(participantId);

    RTCSessionDescription offer = await peerConnection.createOffer();
    await peerConnection.setLocalDescription(offer);

    return {
      'sdp': offer.sdp,
      'type': offer.type,
    };
  }

  Future<Map<String, dynamic>> createAnswer(String participantId) async {
    final peerConnection = _peerConnections[participantId];
    if (peerConnection == null) {
      throw Exception('No peer connection found for $participantId');
    }

    RTCSessionDescription answer = await peerConnection.createAnswer();
    await peerConnection.setLocalDescription(answer);

    return {
      'sdp': answer.sdp,
      'type': answer.type,
    };
  }

  void setOnIceCandidate(String participantId, Function(Map<String, dynamic>) callback) {
    _peerConnections[participantId]?.onIceCandidate = (RTCIceCandidate candidate) {
      if (candidate.candidate != null) {
        callback({
          'candidate': candidate.candidate,
          'sdpMid': candidate.sdpMid,
          'sdpMLineIndex': candidate.sdpMLineIndex,
        });
      }
    };
  }

  Future<void> setRemoteDescription(String participantId, Map<String, dynamic> description) async {
    final peerConnection = _peerConnections[participantId] ?? await _createPeerConnection(participantId);
    
    await peerConnection.setRemoteDescription(
      RTCSessionDescription(description['sdp'], description['type']),
    );
  }

  Future<void> addIceCandidate(String participantId, Map<String, dynamic> candidate) async {
    await _peerConnections[participantId]?.addCandidate(
      RTCIceCandidate(
        candidate['candidate'],
        candidate['sdpMid'],
        candidate['sdpMLineIndex'],
      ),
    );
  }

  Future<void> removeParticipant(String participantId) async {
    await _removePeerConnection(participantId);
  }

  void toggleAudio() {
    if (_localStream != null) {
      final audioTrack = _localStream!.getAudioTracks().first;
      audioTrack.enabled = !audioTrack.enabled;
    }
  }

  void toggleVideo() {
    if (_localStream != null) {
      final videoTrack = _localStream!.getVideoTracks().first;
      videoTrack.enabled = !videoTrack.enabled;
    }
  }

  void switchCamera() {
    if (_localStream != null) {
      Helper.switchCamera(_localStream!.getVideoTracks().first);
    }
  }

  Future<void> dispose() async {
    await _localStream?.dispose();
    
    // Close all peer connections
    for (var peerConnection in _peerConnections.values) {
      await peerConnection.close();
    }
    _peerConnections.clear();
    
    // Dispose all remote renderers
    for (var renderer in remoteRenderers.values) {
      await renderer.dispose();
    }
    remoteRenderers.clear();
    
    await localRenderer.dispose();
    _signalingService.dispose();
  }
}
