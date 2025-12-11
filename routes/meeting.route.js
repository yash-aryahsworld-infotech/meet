const express = require("express");
const router = express.Router();
const meetingController = require("../controllers/meeting.controller.js");

router.post("/start", meetingController.startMeeting);
router.get("/join", meetingController.checkMeetingExists);
router.get("/users", meetingController.getAllMeetingUsers);

module.exports = router;