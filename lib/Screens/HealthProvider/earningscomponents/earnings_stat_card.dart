import 'package:flutter/material.dart';

// -------------------------------------------------------
// 1. PARENT SECTION (Responsive Grid of Cards)
// -------------------------------------------------------
class EarningsSection extends StatelessWidget {
  const EarningsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Data matching your screenshot
    final List<Map<String, dynamic>> earningsData = [
      {
        "title": "Total Earnings",
        "amount": "₹0",
        "subtext": "From 0 consultations",
        "icon": Icons.attach_money,
      },
      {
        "title": "This Month",
        "amount": "₹0",
        "percentageChange": "+12% from last month",
        "positive": true,
        "icon": Icons.calendar_today_outlined,
      },
      {
        "title": "This Week",
        "amount": "₹0",
        "percentageChange": "+8% from last week",
        "positive": true,
        "icon": Icons.trending_up,
      },
      {
        "title": "Average Fee",
        "amount": "₹0",
        "subtext": "Per consultation",
        "icon": Icons.people_outline,
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive: 4 columns on Web, 2 columns on Mobile
        int crossAxisCount = constraints.maxWidth > 900 ? 4 : 2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: earningsData.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            // Aspect ratio roughly matches the rectangular shape in your image
            childAspectRatio: 1.5, 
          ),
          itemBuilder: (context, index) {
            final data = earningsData[index];
            return EarningsStatCard(
              title: data['title'],
              amount: data['amount'],
              icon: data['icon'],
              subtext: data['subtext'],
              percentageChange: data['percentageChange'],
              positive: data['positive'] ?? true,
            );
          },
        );
      },
    );
  }
}

// -------------------------------------------------------
// 2. THE CARD WIDGET (Your Requested Structure)
// -------------------------------------------------------
class EarningsStatCard extends StatelessWidget {
  final String title;               // e.g., "Total Earnings"
  final IconData? icon;             // top-right icon
  final String amount;              // e.g., "₹0"
  final String? subtext;            // e.g., "From 0 consultations"
  final String? percentageChange;   // e.g., "+12% from last month"
  final bool positive;              // green if true, red if false

  const EarningsStatCard({
    super.key,
    required this.title,
    this.icon,
    required this.amount,
    this.subtext,
    this.percentageChange,
    this.positive = true,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if we are on mobile for font scaling
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16), // Matches AppResponsive.radiusMD usually
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // --- Top Row: Title & Icon ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isMobile ? 13 : 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(
                    icon,
                    size: 20,
                    color: Colors.grey[400],
                  ),
                ),
            ],
          ),

          // --- Middle: Amount ---
          Text(
            amount,
            style: TextStyle(
              fontSize: isMobile ? 24 : 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          // --- Bottom: Subtext OR Percentage ---
          if (percentageChange != null)
            Text(
              percentageChange!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: isMobile ? 11 : 12,
                color: positive ? Colors.green : Colors.red,
                fontWeight: FontWeight.w500,
              ),
            )
          else if (subtext != null)
            Text(
              subtext!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: isMobile ? 11 : 12,
                color: Colors.grey[500],
              ),
            )
          else
            const SizedBox(), // Placeholder to keep layout consistent
        ],
      ),
    );
  }
}