import 'package:flutter/material.dart';
import './booking_bottom_sheet.dart'; 

class DoctorDetailsPage extends StatelessWidget {
  final Map<String, dynamic> doctor;
  final String? patientUserKey; // Accepts key to pass to booking

  const DoctorDetailsPage({super.key, required this.doctor, required this.patientUserKey});

  ImageProvider _getImageProvider(String imagePath) {
    if (imagePath.startsWith('http')) {
      return NetworkImage(imagePath);
    } else {
      return const NetworkImage("https://ui-avatars.com/api/?background=random"); 
    }
  }

  @override
  Widget build(BuildContext context) {
    final String fullName = doctor['name'] ?? "Dr. ${doctor['firstName']} ${doctor['lastName']}";
    final String specialty = doctor['specialty'] ?? doctor['displaySpecialty'] ?? "Specialist";
    final String fee = doctor['price']?.toString() ?? doctor['consultationFee']?.toString() ?? "0";

    // Use Material + SafeArea because we removed Scaffold
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // --- 1. Custom Header (Instead of AppBar) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Row(
                children: [
                  const BackButton(),
                  const Text("Doctor Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            // --- 2. Scrollable Body ---
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Hero(
                            tag: doctor['image'] ?? "hero_tag",
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: _getImageProvider(doctor['image'] ?? ""),
                              backgroundColor: Colors.blue.shade50,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(fullName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          Text(specialty, style: TextStyle(color: Colors.grey[700], fontSize: 16)),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),

                    // Stats
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatItem("Experience", "${doctor['experienceYears'] ?? doctor['experience'] ?? '5+'} Yrs"),
                          _buildStatItem("Rating", "${doctor['rating'] ?? 4.5}"),
                          _buildStatItem("Patients", "100+"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),

                    // About
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("About Doctor", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Text(
                            doctor['about'] ?? "Experienced specialist dedicated to patient care.",
                            style: TextStyle(color: Colors.grey[600], height: 1.5, fontSize: 15),
                          ),
                          const SizedBox(height: 25),
                          const Text("Working Hours", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Text("Mon - Fri: 09:00 AM - 08:00 PM", style: TextStyle(color: Colors.grey[600])),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- 3. Bottom Action Bar (Fixed) ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -5))],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (patientUserKey == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please login to book")));
                      return;
                    }
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                      builder: (context) => BookingBottomSheet(doctor: doctor, patientKey: patientUserKey!),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text("Book Appointment (₹$fee)", style: const TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}