import 'package:flutter/material.dart';

class PaymentMethodCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodCard({
    super.key,
    required this.data,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Math for totals
    final double baseAmount = (data['baseAmount'] ?? 0).toDouble();
    final double fee = (data['fee'] ?? 0).toDouble();
    final double total = baseAmount + fee;
    final bool hasFee = fee > 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF3B82F6) : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            else
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Icon ---
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Icon(
                data['icon'],
                color: isSelected ? const Color(0xFF3B82F6) : Colors.grey.shade700,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),

            // --- Middle Content ---
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Title & Colored Badges
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Text(
                        data['title'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      
                      // --- UPDATED BADGE LOGIC START ---
                      if (data['badges'] != null)
                        ...(data['badges'] as List).map((badgeData) {
                          String text = '';
                          Color bgColor = Colors.grey.shade100; // Default
                          Color txtColor = Colors.grey.shade700; // Default

                          // Handle if data is passed as a Map (with colors)
                          if (badgeData is Map) {
                            text = badgeData['text'] ?? '';
                            bgColor = badgeData['bgColor'] ?? Colors.grey.shade100;
                            txtColor = badgeData['textColor'] ?? Colors.grey.shade700;
                          } 
                          // Handle if data is passed as simple String (legacy support)
                          else if (badgeData is String) {
                            text = badgeData;
                          }

                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              text,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: txtColor,
                              ),
                            ),
                          );
                        }),
                      // --- UPDATED BADGE LOGIC END ---
                    ],
                  ),
                  const SizedBox(height: 8),

                  // 2. Tags (Square gray cards)
                  if (data['tags'] != null)
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: (data['tags'] as List).map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Text(
                            tag.toString(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                  const SizedBox(height: 8),

                  // 3. Features (Icons)
                  if (data['features'] != null)
                    Wrap(
                      spacing: 12,
                      runSpacing: 4,
                      children: (data['features'] as List).map((feature) {
                        // Quick icon logic
                        IconData fIcon = Icons.check_circle_outline;
                        if (feature.toString().toLowerCase().contains('instant')) {
                          fIcon = Icons.access_time_rounded;
                        }
                        
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(fIcon, size: 14, color: Colors.grey.shade500),
                            const SizedBox(width: 4),
                            Text(
                              feature.toString(),
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),

            // --- Right Side (Price) ---
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "₹${total.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                if (hasFee)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2.0),
                    child: Text(
                      "+ ₹${fee.toStringAsFixed(2)} fee",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                Text(
                  "Total amount",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}