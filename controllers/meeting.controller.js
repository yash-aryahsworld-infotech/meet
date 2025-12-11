const { db } = require("../config/firebase.js");

exports.startMeeting = async (req, res) => {
  try {
    const { hostId, hostName } = req.body;
    
    // ✅ FIX: Generate random 9-digit number
    const meetingId = Math.floor(100000000 + Math.random() * 900000000).toString();
    
    const meetingRef = db.ref(`meetings/${meetingId}`);

    const meetingData = {
      hostId: hostId,
      hostName: hostName,
      startTime: Date.now(),
      isActive: true,
      users: []
    };

    await meetingRef.set(meetingData);

    return res.status(200).json({
      message: "Meeting Created",
      data: { meetingId }
    });

  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

// ... keep other functions same ...
exports.checkMeetingExists = async (req, res) => {
  try {
    const { meetingId } = req.query;
    const meetingRef = db.ref(`meetings/${meetingId}`);
    const snapshot = await meetingRef.once("value");

    if (!snapshot.exists()) {
      return res.status(404).json({ message: "Meeting Not Found" });
    }
    return res.status(200).json({ message: "Success", data: snapshot.val() });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

exports.getAllMeetingUsers = async (req, res) => {
    try {
        const { meetingId } = req.query;
        const usersRef = db.ref(`meetings/${meetingId}/users`);
        const snapshot = await usersRef.once("value");
        return res.status(200).json({ message: "Success", data: snapshot.val() || [] });
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
}