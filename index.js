require("dotenv").config();
const express = require("express");
const http = require("http");
const cors = require("cors");
const { Server } = require("socket.io");
const { db } = require("./config/firebase.js"); // Import Firebase DB
const meetingRoutes = require("./routes/meeting.route.js");

const app = express();
const server = http.createServer(app);

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.send("Server is working!");
});

app.use("/api/meeting", meetingRoutes);

const io = new Server(server, {
  cors: { origin: "*" }
});

// In-memory map for fast socket lookup during video routing
const socketUserMap = {}; 

io.on("connection", (socket) => {
  console.log("✅ Socket Connected:", socket.id);

  socket.on("join-meeting", async ({ meetingId, participantId, participantName, isHost }) => {
    // Support both old and new parameter names
    const userId = participantId;
    const name = participantName;
    
    // 1. Store in Memory (Fast access for video routing)
    socketUserMap[socket.id] = { userId, name, isHost };

    // 2. STORE IN FIREBASE (Permanent Storage)
    const userRef = db.ref(`meetings/${meetingId}/participants/${userId}`);
    await userRef.set({
      name: name,
      userId: userId,
      participantId: participantId,
      socketId: socket.id,
      joinedAt: Date.now(),
      isOnline: true,
      isHost: isHost || false
    });

    socket.join(meetingId);
    console.log(`👤 ${name} (${isHost ? 'Host' : 'Participant'}) joined meeting ${meetingId}`);

    // 3. Notify OTHERS that I have joined
    socket.to(meetingId).emit("participant-joined", { 
        participantId: userId,
        participantName: name,
        isHost: isHost || false
    });

    // 4. FETCH ALL USERS from Firebase to send to ME
    const usersSnapshot = await db.ref(`meetings/${meetingId}/participants`).once('value');
    const participants = [];
    
    if (usersSnapshot.exists()) {
      usersSnapshot.forEach((child) => {
        const p = child.val();
        // Don't add myself to the list of people to call
        if (p.socketId !== socket.id && p.isOnline) {
          participants.push({ 
            participantId: p.userId,
            participantName: p.name,
            isHost: p.isHost || false
          });
        }
      });
    }

    console.log(`Sending ${participants.length} existing participants to ${name}`);
    socket.emit("existing-participants", participants);
  });

  // Handle leave meeting
  socket.on("leave-meeting", async ({ meetingId, participantId }) => {
    const user = socketUserMap[socket.id];
    
    if (user) {
      console.log(`👋 ${user.name} left meeting ${meetingId}`);
      socket.to(meetingId).emit("participant-left", { 
        participantId: participantId,
        participantName: user.name
      });
      
      // Mark as offline in Firebase
      if (participantId) {
        await db.ref(`meetings/${meetingId}/participants/${participantId}`).update({ isOnline: false });
      }
      
      socket.leave(meetingId);
      delete socketUserMap[socket.id];
    }
  });

  // Handle Disconnect
  socket.on("disconnect", async () => {
    const user = socketUserMap[socket.id];
    
    if (user) {
      console.log(`❌ ${user.name} disconnected`);
      socket.broadcast.emit("participant-left", { 
        participantId: user.userId,
        participantName: user.name
      });
      
      delete socketUserMap[socket.id];
    }
  });

  // --- WebRTC Signaling ---
  socket.on("offer", ({ meetingId, toParticipantId, offer }) => {
    // Find the socket ID for the target participant
    const targetSocket = Object.keys(socketUserMap).find(
      sid => socketUserMap[sid].userId === toParticipantId
    );
    
    if (targetSocket) {
      io.to(targetSocket).emit("offer", {
        offer: offer,
        fromParticipantId: socketUserMap[socket.id]?.userId,
        fromParticipantName: socketUserMap[socket.id]?.name
      });
      console.log(`📤 Offer sent from ${socket.id} to ${targetSocket}`);
    } else {
      console.log(`⚠️ Target participant ${toParticipantId} not found`);
    }
  });

  socket.on("answer", ({ meetingId, toParticipantId, answer }) => {
    const targetSocket = Object.keys(socketUserMap).find(
      sid => socketUserMap[sid].userId === toParticipantId
    );
    
    if (targetSocket) {
      io.to(targetSocket).emit("answer", {
        answer: answer,
        fromParticipantId: socketUserMap[socket.id]?.userId
      });
      console.log(`📤 Answer sent from ${socket.id} to ${targetSocket}`);
    }
  });

  socket.on("ice-candidate", ({ meetingId, toParticipantId, candidate }) => {
    const targetSocket = Object.keys(socketUserMap).find(
      sid => socketUserMap[sid].userId === toParticipantId
    );
    
    if (targetSocket) {
      io.to(targetSocket).emit("ice-candidate", {
        candidate: candidate,
        fromParticipantId: socketUserMap[socket.id]?.userId
      });
    }
  });

  // Handle participant state changes (mute/unmute, video on/off)
  socket.on("update-participant-state", ({ meetingId, participantId, isAudioMuted, isVideoOff }) => {
    socket.to(meetingId).emit("participant-state-changed", {
      participantId,
      isAudioMuted,
      isVideoOff
    });
  });
});

const PORT = process.env.PORT || 4000;
server.listen(PORT, "0.0.0.0", () => {
  console.log(`🚀 Server running on port ${PORT}`);
});
