import 'package:flutter/material.dart';
import './doctor_details_page.dart'; // Import the new page
import './booking_bottom_sheet.dart'; 

class DoctorCard extends StatelessWidget {
  final Map<String, dynamic> doctor;

  const DoctorCard({super.key, required this.doctor});

  ImageProvider _getImageProvider(String imagePath) {
    if (imagePath.startsWith('http')) {
      return NetworkImage(imagePath);
    } else {
      return AssetImage(imagePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- CLICKABLE PROFILE SECTION ---
            GestureDetector(
              onTap: () {
                // Navigate to Details Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DoctorDetailsPage(doctor: doctor)),
                );
              },
              child: Container(
                color: Colors.transparent, // Ensures click area covers empty space
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Image
                    Hero(
                      tag: 'doctor_${doctor['userKey'] ?? doctor['id'] ?? doctor['name']}_${doctor['image']}', // Unique Animation Tag
                      child: CircleAvatar(
                        radius: 32,
                        backgroundImage: _getImageProvider(doctor['image']),
                        backgroundColor: Colors.blue.shade100,
                      ),
                    ),
                    const SizedBox(width: 15),
                    
                    // Info Section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(doctor['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          
                          // --- ADDED DEGREE HERE ---
                          Text(
                            doctor['degree'], 
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)
                          ),

                          Text(doctor['specialty'], style: TextStyle(color: Colors.blue.shade700, fontSize: 13, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.work_outline, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text("${doctor['experience']} Exp", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              const Padding(padding: EdgeInsets.symmetric(horizontal: 6.0), child: Icon(Icons.circle, size: 4, color: Colors.grey)),
                              const Icon(Icons.star, color: Colors.amber, size: 14),
                              const SizedBox(width: 2),
                              Text("${doctor['rating']}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.language, size: 14, color: Colors.blue.shade600),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Builder(
                                  builder: (context) {
                                    final languages = doctor['languages'];
                                    if (languages == null || (languages is List && languages.isEmpty)) {
                                      return const Text(
                                        'Languages not specified',
                                        style: TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic),
                                      );
                                    }
                                    final langList = languages as List;
                                    final displayText = langList.take(3).join(', ') + 
                                      (langList.length > 3 ? ' +${langList.length - 3}' : '');
                                    return Text(
                                      displayText,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 11, color: Colors.blue.shade700, fontWeight: FontWeight.w600),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Price Section (Not clickable for details, just visual)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("₹${doctor['price']}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
                        const Text("per session", style: TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Divider(height: 1),
            const SizedBox(height: 10),
            
            // --- BOOK BUTTON ---
            SizedBox(
              width: double.infinity,
              height: 42,
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                    builder: (context) => BookingBottomSheet(doctor: doctor),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Book Appointment", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}