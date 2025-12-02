import 'package:flutter/material.dart';

class ResourcesSection extends StatelessWidget {
  const ResourcesSection({super.key});

  // ------------------------------------------------------------
  // 🔵 EASY-TO-EDIT DATA LISTS (Modify Only These Arrays)
  // ------------------------------------------------------------
  static const List<Map<String, String>> videoTutorials = [
    {"title": "How to Book Your First Consultation", "duration": "3:45 mins"},
    {"title": "Setting Up Your Health Profile", "duration": "2:20 mins"},
    {"title": "Using the Digital Wallet", "duration": "4:10 mins"},
  ];

  static const List<Map<String, String>> userGuides = [
    {"title": "Patient User Guide", "desc": "Complete guide for patients"},
    {"title": "Privacy & Security Guide", "desc": "Understanding your data protection"},
    {"title": "Payment Methods Guide", "desc": "All about payments and billing"},
  ];

  static const List<Map<String, String>> supportHours = [
    {"label": "Emergency Support:", "value": "24/7 available"},
    {"label": "General Support:", "value": "Mon–Sun, 9 AM – 9 PM IST"},
    {"label": "Technical Support:", "value": "Mon–Fri, 9 AM – 6 PM IST"},
    {"label": "Billing Support:", "value": "Mon–Fri, 10 AM – 6 PM IST"},
  ];

  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth > 900;

        return Column(
          children: [
            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _videoCard()),
                  const SizedBox(width: 24),
                  Expanded(child: _guidesCard()),
                ],
              )
            else
              Column(
                children: [
                  _videoCard(),
                  const SizedBox(height: 24),
                  _guidesCard(),
                ],
              ),

            const SizedBox(height: 24),
            _supportHoursCard(),
          ],
        );
      },
    );
  }

  // ------------------------------------------------------------
  // 🔵 VIDEO TUTORIALS CARD
  // ------------------------------------------------------------
  Widget _videoCard() {
    return _baseCard(
      title: "Video Tutorials",
      icon: Icons.videocam_outlined,
      children: videoTutorials.map((e) {
        return _listItem(
          title: e["title"]!,
          subtitle: e["duration"]!,
          isDuration: true,
        );
      }).toList(),
    );
  }

  // ------------------------------------------------------------
  // 🔵 USER GUIDES CARD
  // ------------------------------------------------------------
  Widget _guidesCard() {
    return _baseCard(
      title: "User Guides",
      icon: Icons.description_outlined,
      children: userGuides.map((e) {
        return _listItem(
          title: e["title"]!,
          subtitle: e["desc"]!,
          isDuration: false,
        );
      }).toList(),
    );
  }

  // ------------------------------------------------------------
  // 🔵 SUPPORT HOURS CARD
  // ------------------------------------------------------------
  Widget _supportHoursCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDBEAFE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.access_time, color: Color(0xFF1665D8), size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Support Hours",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E40AF),
                  ),
                ),
                const SizedBox(height: 12),
                ...supportHours.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF1E293B),
                          height: 1.5,
                        ),
                        children: [
                          TextSpan(
                            text: "${item['label']} ",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: item['value']),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // 🔵 BASE CARD LAYOUT
  // ------------------------------------------------------------
  Widget _baseCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
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
          Row(
            children: [
              Icon(icon, size: 20, color: const Color(0xFF2E3A59)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E3A59),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: c,
              )),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // 🔵 SINGLE LIST ITEM
  // ------------------------------------------------------------
  Widget _listItem({
    required String title,
    required String subtitle,
    required bool isDuration,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E3A59),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: isDuration ? Colors.grey.shade500 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
