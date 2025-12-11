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
app.use("/api/meeting", meetingRoutes);

const io = new Server(server, {
  cors: { origin: "*" }
});

// In-memory map for fast socket lookup during video routing
const socketUserMap = {}; 

io.on("connection", (socket) => {
  console.log("✅ Socket Connected:", socket.id);

  socket.on("join-meeting", async ({ meetingId, userId, name }) => {
    // 1. Store in Memory (Fast access for video routing)
    socketUserMap[socket.id] = { userId, name };

    // 2. STORE IN FIREBASE (Permanent Storage)
    const userRef = db.ref(`meetings/${meetingId}/participants/${userId}`);
    await userRef.set({
      name: name,
      userId: userId, // Acts as Device ID
      socketId: socket.id,
      joinedAt: Date.now(), // Timestamp
      isOnline: true
    });

    socket.join(meetingId);
    console.log(`👤 ${name} joined meeting ${meetingId}`);

    // 3. Notify OTHERS that I have joined
    socket.to(meetingId).emit("user-joined", { 
        userId, 
        name, 
        socketId: socket.id 
    });

    // 4. FETCH ALL USERS from Firebase to send to ME
    // This ensures we get names even if they joined hours ago
    const usersSnapshot = await db.ref(`meetings/${meetingId}/participants`).once('value');
    const participants = [];
    
    if (usersSnapshot.exists()) {
      usersSnapshot.forEach((child) => {
        const p = child.val();
        // Don't add myself to the list of people to call
        if (p.socketId !== socket.id && p.isOnline) {
          participants.push({ 
            socketId: p.socketId, 
            name: p.name, 
            userId: p.userId 
          });
        }
      });
    }

    console.log(`Sending ${participants.length} existing users to ${name}`);
    socket.emit("existing-users", participants);
  });

  // Handle Disconnect
  socket.on("disconnect", async () => {
    const user = socketUserMap[socket.id];
    
    if (user) {
      console.log(`❌ ${user.name} disconnected`);
      socket.broadcast.emit("user-left", { socketId: socket.id });
      
      // Optional: Mark as offline in Firebase
      // await db.ref(`meetings/${meetingId}/participants/${user.userId}`).update({ isOnline: false });
      
      delete socketUserMap[socket.id];
    }
  });

  // --- WebRTC Signaling (Unchanged) ---
  socket.on("offer", (payload) => {
    io.to(payload.targetSocketId).emit("offer-received", {
      sdp: payload.sdp,
      senderSocketId: socket.id,
      senderName: socketUserMap[socket.id]?.name // Send name with offer
    });
  });

  socket.on("answer", (payload) => {
    io.to(payload.targetSocketId).emit("answer-received", {
      sdp: payload.sdp,
      senderSocketId: socket.id
    });
  });

  socket.on("ice-candidate", (payload) => {
    io.to(payload.targetSocketId).emit("ice-candidate-received", {
      candidate: payload.candidate,
      senderSocketId: socket.id
    });
  });
});

const PORT = process.env.PORT || 4000;
server.listen(PORT, "0.0.0.0", () => {
  console.log(`🚀 Server running on port ${PORT}`);
});