import 'package:flutter/material.dart';
import 'package:healthcare_plus/Screens/Patient/privacycomponent/infocard.dart';

// ---------------------------------------------------------
class ConsentHistoryComponent extends StatelessWidget {
  const ConsentHistoryComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Activity Log Section
        _buildActivityLogCard(),
        
        const SizedBox(height: 24),
        
        // --- USING YOUR REUSABLE INFO CARD HERE ---
        const InfoCard(
          title: "Your Rights",
          icon: Icons.visibility_outlined,
          // We can use the defaults defined in the class, 
          // or override them here if we want a specific look.
          points: [
            "You can withdraw consent at any time (except for essential services)",
            "Changes take effect immediately and are logged for compliance",
            "You can export your complete consent history",
            "Contact our privacy team for any questions or concerns",
          ],
        ),
      ],
    );
  }

  // (Keeping the Activity Log code the same as before)
  Widget _buildActivityLogCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Consent Activity Log",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Complete history of your consent preferences and changes",
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          _buildLogItem(
            title: "Essential Healthcare Services",
            status: "Consent granted",
            date: "25/11/2025",
            time: "16:48:17",
            isGranted: true,
          ),
        ],
      ),
    );
  }

  Widget _buildLogItem({
    required String title,
    required String status,
    required String date,
    required String time,
    required bool isGranted,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isGranted ? const Color(0xFF22C55E) : Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(status, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(date, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(time, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
            ],
          ),
        ],
      ),
    );
  }
}