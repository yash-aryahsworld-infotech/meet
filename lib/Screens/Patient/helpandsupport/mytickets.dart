// my_tickets_section.dart
import 'package:flutter/material.dart';
import './ticket/support_ticket_model.dart';
import './ticket/ticket_card.dart';

class MyTicketsSection extends StatelessWidget {
  const MyTicketsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tickets = [
      SupportTicket(
        id: "TICK-001",
        title: "Unable to book appointment",
        description:
            "Getting an error when trying to book appointment with Dr. Smith",
        priority: "medium",
        status: "resolved",
        createdDate: "15/09/2024",
        updatedDate: "16/09/2024",
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "My Support Tickets",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E3A59),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Track your support requests",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 24),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tickets.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (_, index) => TicketCard(ticket: tickets[index]),
          ),
        ],
      ),
    );
  }
}
