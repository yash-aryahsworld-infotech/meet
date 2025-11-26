// ticket_card.dart
import 'package:flutter/material.dart';
import './support_ticket_model.dart';
import './ticket_badge.dart';
import './ticket_view_button.dart';

class TicketCard extends StatelessWidget {
  final SupportTicket ticket;

  const TicketCard({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final textDark = const Color(0xFF2E3A59);
    final textLight = const Color(0xFF8F9BB3);
    final borderGrey = const Color(0xFFE4E9F2);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderGrey),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 500;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Content left
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              ticket.title,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: textDark,
                              ),
                            ),
                            TicketBadge(text: ticket.priority),
                            TicketBadge(text: ticket.status),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Text(
                          ticket.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Wrap(
                          spacing: 16,
                          runSpacing: 4,
                          children: [
                            Text("ID: ${ticket.id}",
                                style:
                                    TextStyle(fontSize: 12, color: textLight)),
                            Text("Created: ${ticket.createdDate}",
                                style:
                                    TextStyle(fontSize: 12, color: textLight)),
                            Text("Updated: ${ticket.updatedDate}",
                                style:
                                    TextStyle(fontSize: 12, color: textLight)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Desktop button
                  if (!isMobile) ...[
                    const SizedBox(width: 16),
                    const TicketViewButton(),
                  ]
                ],
              ),

              // Button on bottom for mobile
              if (isMobile) ...[
                const SizedBox(height: 16),
                const SizedBox(width: double.infinity, child: TicketViewButton())
              ]
            ],
          );
        },
      ),
    );
  }
}
