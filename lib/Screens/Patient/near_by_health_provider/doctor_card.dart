import 'package:flutter/material.dart';
import './booking_bottom_sheet.dart'; 

class DoctorCard extends StatelessWidget {
  final Map<String, dynamic> doctor;
  final String? patientUserKey;

  const DoctorCard({super.key, required this.doctor, required this.patientUserKey});

  @override
  Widget build(BuildContext context) {
    // Robust Data Extraction
    final String fullName = doctor['name'] ?? "Dr. ${doctor['firstName']} ${doctor['lastName']}";
    final String specialty = doctor['specialty'] ?? doctor['displaySpecialty'] ?? "Specialist";
    final String fee = doctor['price']?.toString() ?? doctor['consultationFee']?.toString() ?? "0";
    final String exp = doctor['experience']?.toString() ?? doctor['experienceYears']?.toString() ?? "0";
    
    final imgUrl = doctor['image'] ?? "";
    final ImageProvider imageProvider = (imgUrl.startsWith('http'))
        ? NetworkImage(imgUrl)
        : const NetworkImage("https://ui-avatars.com/api/?background=random");

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundImage: imageProvider,
                  backgroundColor: Colors.blue.shade100,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(fullName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(specialty, style: TextStyle(color: Colors.blue.shade700, fontSize: 13, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.work_outline, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text("$exp Years Exp", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      )
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("₹$fee", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
                    const Text("per session", style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Divider(height: 1),
            const SizedBox(height: 10),
            
            // --- BOOK BUTTON ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 1. Check if user is logged in
                  if (patientUserKey == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please login to book an appointment"))
                    );
                    return;
                  }

                  // 2. Open Sheet
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                    builder: (context) => BookingBottomSheet(
                      doctor: doctor, 
                      patientKey: patientUserKey! // Safe because of check above
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                child: const Text("Book Appointment", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}