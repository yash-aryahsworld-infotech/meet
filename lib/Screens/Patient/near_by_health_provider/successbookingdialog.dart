import 'package:flutter/material.dart';

class SuccessBookingDialog extends StatelessWidget {
  final VoidCallback onOkPressed;

  const SuccessBookingDialog({super.key, required this.onOkPressed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      contentPadding: const EdgeInsets.all(20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 60),
          const SizedBox(height: 20),
          const Text("Booking Confirmed!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text("Your appointment has been booked successfully.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onOkPressed,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("OK", style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}