import 'package:flutter/material.dart';

class ContactOptionsList extends StatelessWidget {
  const ContactOptionsList({super.key});

  @override
  Widget build(BuildContext context) {
    // Colors
    const Color primaryBlue = Color(0xFF1665D8);
    const Color textDark = Color(0xFF2E3A59);
    const Color textLight = Color(0xFF8F9BB3);
    const Color borderGrey = Color(0xFFE4E9F2);

    // Data
    final cards = [
      {
        "icon": Icons.phone_in_talk_outlined,
        "title": "Phone Support",
        "desc": "Available 24/7 for emergencies\n9 AM - 9 PM for general support",
        "actionText": "+91-1800-123-4567",
        "isButton": false,
      },
      {
        "icon": Icons.chat_bubble_outline,
        "title": "Live Chat",
        "desc": "Chat with our support team\nAverage response: 2-5 minutes",
        "actionText": "Start Chat",
        "isButton": true,
      },
      {
        "icon": Icons.email_outlined,
        "title": "Email Support",
        "desc": "Email us your questions\nResponse within 24 hours",
        "actionText": "support@healthcare-plus.com",
        "isButton": false,
      },
    ];

    Widget buildCard(Map<String, Object> data) {
      final bool isButton = data["isButton"] as bool;
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderGrey),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(data["icon"] as IconData, size: 32, color: primaryBlue),
            const SizedBox(height: 16),
            Text(
              data["title"] as String,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              data["desc"] as String,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: textLight,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            if (isButton)
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: Text(data["actionText"] as String),
                ),
              )
            else
              Text(
                data["actionText"] as String,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: textDark,
                ),
              ),
          ],
        ),
      );
    }

    return LayoutBuilder(builder: (context, constraints) {
      bool isWide = constraints.maxWidth > 800;
      
      if (isWide) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: buildCard(cards[0])),
            const SizedBox(width: 16),
            Expanded(child: buildCard(cards[1])),
            const SizedBox(width: 16),
            Expanded(child: buildCard(cards[2])),
          ],
        );
      } else {
        return Column(
          children: [
            buildCard(cards[0]),
            const SizedBox(height: 16),
            buildCard(cards[1]),
            const SizedBox(height: 16),
            buildCard(cards[2]),
          ],
        );
      }
    });
  }
}