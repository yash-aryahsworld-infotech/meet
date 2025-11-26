import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// DATA MODEL
// ---------------------------------------------------------------------------
class SupportTicket {
  final String id;
  final String title;
  final String description;
  final String priority; // 'medium', 'high', 'low'
  final String status;   // 'resolved', 'open', 'pending'
  final String createdDate;
  final String updatedDate;

  SupportTicket({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.createdDate,
    required this.updatedDate,
  });
}

// ---------------------------------------------------------------------------
// COMPONENT
// ---------------------------------------------------------------------------

class MyTicketsSection extends StatelessWidget {
  const MyTicketsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Data
    final tickets = [
      SupportTicket(
        id: "TICK-001",
        title: "Unable to book appointment",
        description: "Getting error when trying to book appointment with Dr. Smith",
        priority: "medium",
        status: "resolved",
        createdDate: "15/09/2024",
        updatedDate: "16/09/2024",
      ),
       // Add more tickets here if needed to test list behavior
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
          // HEADER
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
            "Track the status of your support requests",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 24),

          // TICKET LIST
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tickets.length,
            separatorBuilder: (c, i) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return _TicketCard(ticket: tickets[index]);
            },
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// INDIVIDUAL TICKET CARD
// ---------------------------------------------------------------------------

class _TicketCard extends StatelessWidget {
  final SupportTicket ticket;

  const _TicketCard({required this.ticket});

  @override
  Widget build(BuildContext context) {
    // Colors
    final Color textDark = const Color(0xFF2E3A59);
    final Color textLight = const Color(0xFF8F9BB3);
    final Color borderGrey = const Color(0xFFE4E9F2);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderGrey),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Check available width to decide layout
          bool isNarrow = constraints.maxWidth < 500;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CONTENT COLUMN
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title + Badges
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Text(
                              ticket.title,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: textDark,
                              ),
                            ),
                            _buildStatusBadge(ticket.priority),
                            _buildStatusBadge(ticket.status),
                          ],
                        ),
                        const SizedBox(height: 8),
                        
                        // Description
                        Text(
                          ticket.description,
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 12),

                        // Meta Info (ID, Dates)
                        Wrap(
                          spacing: 16,
                          runSpacing: 4,
                          children: [
                            Text(
                              "ID: ${ticket.id}",
                              style: TextStyle(fontSize: 12, color: textLight),
                            ),
                            Text(
                              "Created: ${ticket.createdDate}",
                              style: TextStyle(fontSize: 12, color: textLight),
                            ),
                            Text(
                              "Updated: ${ticket.updatedDate}",
                              style: TextStyle(fontSize: 12, color: textLight),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // BUTTON (Only show on right if not narrow)
                  if (!isNarrow) ...[
                    const SizedBox(width: 16),
                    _buildViewDetailsButton(),
                  ]
                ],
              ),

              // BUTTON (Show at bottom if narrow/mobile)
              if (isNarrow) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: _buildViewDetailsButton(),
                ),
              ]
            ],
          );
        },
      ),
    );
  }

  Widget _buildViewDetailsButton() {
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

  Widget _buildStatusBadge(String text) {
    Color bg;
    Color fg;

    // Determine colors based on text content (mimicking the image logic)
    switch (text.toLowerCase()) {
      case 'medium':
        bg = const Color(0xFFFFF7E6); // Light Yellow
        fg = const Color(0xFFD48806); // Dark Yellow/Orange
        break;
      case 'resolved':
        bg = const Color(0xFFF6FFED); // Light Green
        fg = const Color(0xFF52C41A); // Dark Green
        break;
      case 'high':
        bg = const Color(0xFFFFF1F0); // Light Red
        fg = const Color(0xFFF5222D); // Dark Red
        break;
      case 'open':
        bg = const Color(0xFFE6F7FF); // Light Blue
        fg = const Color(0xFF1890FF); // Dark Blue
        break;
      default:
        bg = Colors.grey.shade100;
        fg = Colors.grey.shade600;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}