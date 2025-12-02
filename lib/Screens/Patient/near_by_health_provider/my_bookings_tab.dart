import 'package:flutter/material.dart';

class MyBookingsTab extends StatelessWidget {
  const MyBookingsTab({super.key});

  // --- MOCK DATA FOR HISTORY ---
  static final List<Map<String, dynamic>> _pastAppointments = [
    {
      "name": "Dr. Raj Patel",
      "specialty": "Cardiologist",
      "image": "https://i.pravatar.cc/300?img=11",
      "status": "Completed",
      "date": "Oct 24, 2023",
      "time": "10:00 AM"
    },
    {
      "name": "Dr. Sarah Wilson",
      "specialty": "General Physician",
      "image": "images/female.jpg", // Local asset example
      "status": "Cancelled",
      "date": "Sep 10, 2023",
      "time": "02:30 PM"
    },
    {
      "name": "Dr. Emily Chen",
      "specialty": "Dermatologist",
      "image": "https://i.pravatar.cc/300?img=9",
      "status": "Completed",
      "date": "Aug 15, 2023",
      "time": "11:15 AM"
    },
  ];

  // Helper to safely load images (Network vs Asset)
  ImageProvider _getImageProvider(String imagePath) {
    if (imagePath.startsWith('http')) {
      return NetworkImage(imagePath);
    } else {
      return AssetImage(imagePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_pastAppointments.isEmpty) {
      return const Center(child: Text("No booking history available"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _pastAppointments.length,
      itemBuilder: (context, index) {
        final appointment = _pastAppointments[index];
        final isCompleted = appointment['status'] == "Completed";

        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    // Doctor Image
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.blue.shade50,
                      backgroundImage: _getImageProvider(appointment['image']),
                    ),
                    const SizedBox(width: 15),
                    
                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment['name'], 
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                          ),
                          Text(
                            appointment['specialty'], 
                            style: TextStyle(color: Colors.grey[600], fontSize: 13)
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 12, color: Colors.blue.shade700),
                              const SizedBox(width: 4),
                              Text(
                                "${appointment['date']} at ${appointment['time']}", 
                                style: TextStyle(fontSize: 12, color: Colors.blue.shade700, fontWeight: FontWeight.w500)
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isCompleted ? Colors.green.shade50 : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isCompleted ? Colors.green.shade200 : Colors.red.shade200
                        )
                      ),
                      child: Text(
                        appointment['status'],
                        style: TextStyle(
                          color: isCompleted ? Colors.green.shade700 : Colors.red.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    )
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(),
                ),
                
                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                         // Open receipt logic
                      },
                      icon: const Icon(Icons.receipt_long, size: 16, color: Colors.grey),
                      label: const Text("View Receipt", style: TextStyle(color: Colors.grey)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Re-booking ${appointment['name']}..."))
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        visualDensity: VisualDensity.compact,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                      ),
                      child: const Text("Book Again"),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}