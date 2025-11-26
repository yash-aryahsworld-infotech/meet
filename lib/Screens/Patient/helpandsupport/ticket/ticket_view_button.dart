// ticket_view_button.dart
import 'package:flutter/material.dart';

class TicketViewButton extends StatelessWidget {
  const TicketViewButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF2E3A59),
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: const Text("View Details", style: TextStyle(fontSize: 13)),
    );
  }
}
