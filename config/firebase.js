const admin = require("firebase-admin");
const dotenv = require("dotenv");

dotenv.config();

// You must download this file from Firebase Console -> Project Settings -> Service Accounts
const serviceAccount = JSON.parse(process.env.SERVICE_ACCOUNT_KEY);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: process.env.FIREBASE_DB_URL // Required for Realtime DB
});

const db = admin.database(); // Using Realtime Database, not Firestore

console.log("🔥 Firebase Admin (Realtime DB) Connected");

module.exports = { db };