import 'package:flutter/material.dart';

class ResourcesSection extends StatelessWidget {
  const ResourcesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Switch to stacked layout if screen is narrower than 900px
        final bool isWide = constraints.maxWidth > 900;

        return Column(
          children: [
            // ------------------------------------------------
            // TOP SECTION: VIDEOS & GUIDES
            // ------------------------------------------------
            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildVideoTutorialsCard()),
                  const SizedBox(width: 24),
                  Expanded(child: _buildUserGuidesCard()),
                ],
              )
            else
              Column(
                children: [
                  _buildVideoTutorialsCard(),
                  const SizedBox(height: 24),
                  _buildUserGuidesCard(),
                ],
              ),

            const SizedBox(height: 24),

            // ------------------------------------------------
            // BOTTOM SECTION: SUPPORT HOURS
            // ------------------------------------------------
            _buildSupportHoursCard(),
          ],
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // 1. VIDEO TUTORIALS CARD
  // ---------------------------------------------------------------------------
  Widget _buildVideoTutorialsCard() {
    final tutorials = [
      {"title": "How to Book Your First Consultation", "duration": "3:45 mins"},
      {"title": "Setting Up Your Health Profile", "duration": "2:20 mins"},
      {"title": "Using the Digital Wallet", "duration": "4:10 mins"},
    ];

    return _buildBaseCard(
      title: "Video Tutorials",
      icon: Icons.videocam_outlined,
      children: tutorials.map((item) {
        return _buildListItem(
          title: item['title']!,
          subtitle: item['duration']!,
          isDuration: true,
        );
      }).toList(),
    );
  }

  // ---------------------------------------------------------------------------
  // 2. USER GUIDES CARD
  // ---------------------------------------------------------------------------
  Widget _buildUserGuidesCard() {
    final guides = [
      {
        "title": "Patient User Guide",
        "desc": "Complete guide for patients"
      },
      {
        "title": "Privacy & Security Guide",
        "desc": "Understanding your data protection"
      },
      {
        "title": "Payment Methods Guide",
        "desc": "All about payments and billing"
      },
    ];

    return _buildBaseCard(
      title: "User Guides",
      icon: Icons.description_outlined,
      children: guides.map((item) {
        return _buildListItem(
          title: item['title']!,
          subtitle: item['desc']!,
          isDuration: false,
        );
      }).toList(),
    );
  }

  // ---------------------------------------------------------------------------
  // 3. SUPPORT HOURS CARD
  // ---------------------------------------------------------------------------
  Widget _buildSupportHoursCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF), // Light Blue (Colors.blue.shade50 approx)
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDBEAFE)), // Light blue border
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
                    color: Color(0xFF1E40AF), // Darker Blue text
                  ),
                ),
                const SizedBox(height: 12),
                _buildScheduleRow("Emergency Support:", "24/7 available"),
                _buildScheduleRow("General Support:", "Monday - Sunday, 9 AM - 9 PM IST"),
                _buildScheduleRow("Technical Support:", "Monday - Friday, 9 AM - 6 PM IST"),
                _buildScheduleRow("Billing Support:", "Monday - Friday, 10 AM - 6 PM IST"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HELPER WIDGETS
  // ---------------------------------------------------------------------------

  Widget _buildBaseCard({
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
          ...children.map((child) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: child,
              )),
        ],
      ),
    );
  }

  Widget _buildListItem({
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

  Widget _buildScheduleRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B), height: 1.5),
          children: [
            TextSpan(
              text: "$label ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}