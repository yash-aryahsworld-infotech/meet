import 'package:flutter/material.dart';

class DoctorHeader extends StatelessWidget {
  final Map<String, dynamic> doctor;

  const DoctorHeader({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final imgUrl = doctor['image'] ?? "";
    final imgProvider = (imgUrl.startsWith('http')) 
        ? NetworkImage(imgUrl) 
        : const NetworkImage("https://ui-avatars.com/api/?background=random");

    return Row(
      children: [
        CircleAvatar(radius: 28, backgroundImage: imgProvider),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Booking: ${doctor['name'] ?? doctor['firstName']}", 
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                maxLines: 1, overflow: TextOverflow.ellipsis
              ),
              Text(
                doctor['specialty'] ?? doctor['displaySpecialty'] ?? "Specialist", 
                style: const TextStyle(color: Colors.grey, fontSize: 13)
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.grey), 
          onPressed: () => Navigator.pop(context)
        ),
      ],
    );
  }
}