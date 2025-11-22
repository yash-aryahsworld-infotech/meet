import 'package:flutter/material.dart';
import 'package:healthcare_plus/Screens/HealthProvider/earningscomponents/pendingpaymentscomponent.dart';
import 'package:healthcare_plus/Screens/HealthProvider/earningscomponents/recentpaymentscomponent.dart';
import '../../widgets/custom_header.dart';
import '../../utils/app_responsive.dart';
import './earningscomponents/earnings_stat_card.dart';
import '../../widgets/custom_tab.dart';
import './earningscomponents/analytics_card.dart'; // ⭐ NEW COMPONENT

class EarningsComponent extends StatefulWidget {
  const EarningsComponent({super.key});

  @override
  State<EarningsComponent> createState() => _EarningsComponentState();
}

class _EarningsComponentState extends State<EarningsComponent> {
  int selectedTab = 0;

  final List<String> tabs = [
    "Payment History",
    "Pending Payments",
    "Analytics",
  ];

  final List<int> tabCounts = [
    4, // Payment history
    2, // Pending
    0,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// HEADER
        PageHeader(
          title: "Earnings Dashboard",
          subtitle: "Track your consultation earnings and payments",
          button1Icon: Icons.download,
          button1Text: "Export Reports",
          button1OnPressed: () {},
          padding: EdgeInsets.zero, // Padding handled by parent
        ),

        const SizedBox(height: 20),

        /// STATS CARDS
        _buildCards(
          context,
          AppResponsive.isMobile(context),
          AppResponsive.isTablet(context),
        ),

        const SizedBox(height: 30),

        /// TABS (LEFT)
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            child: TabToggle(
              options: tabs,
              counts: tabCounts,
              selectedIndex: selectedTab,
              fontSize: 15,
              height: 48,
              onSelected: (index) {
                setState(() => selectedTab = index);
              },
            ),
          ),
        ),

        const SizedBox(height: 20),

        /// TAB CONTENT
        // I removed the outer White Container because the components
        // (RecentPayment, PendingPayment, AnalyticsCard) are already Cards
        // with their own white background and shadows.
        _buildTabContent(),
      ],
    );
  }

  /// TAB CONTENT
  Widget _buildTabContent() {
    switch (selectedTab) {
      case 0: // Payment History
        return const RecentPaymentsComponent();

      case 1: // Pending Payments
        return const PendingPaymentsComponent();

      case 2: // Analytics
        return Column(
          children: [
            const AnalyticsCard(
              title: "Earnings Analytics",
              subtitle: "Detailed breakdown of your earnings",
              type: AnalyticsType.list,
              items: [
                {"label": "Video Consultations", "value": "65% (₹15,000)"},
                {"label": "In-Person Consultations", "value": "25% (₹5,500)"},
                {"label": "Audio Consultations", "value": "10% (₹2,200)"},
              ],
            ),

            const SizedBox(height: 20),

            const AnalyticsCard(
              title: "Performance Metrics",
              subtitle: "Key performance indicators",
              type: AnalyticsType.grid,
              items: [
                {"label": "Payment Success Rate", "value": "98%"},
                {"label": "Avg Payment Time", "value": "3.2 days"},
                {"label": "Pending Amount", "value": "₹2450"},
                {"label": "Avg Rating", "value": "4.8/5"},
              ],
            ),
          ],
        );

      default:
        return const SizedBox();
    }
  }

  /// STATS CARDS
  Widget _buildCards(BuildContext context, bool isMobile, bool isTablet) {
    final List<Widget> cards = [
      const EarningsStatCard(
        title: "Total Earnings",
        icon: Icons.attach_money,
        amount: "₹22,700",
        subtext: "From 32 consultations",
      ),
      const EarningsStatCard(
        title: "This Month",
        icon: Icons.calendar_today,
        amount: "₹8,450",
        percentageChange: "+12% from last month",
        positive: true,
      ),
      const EarningsStatCard(
        title: "This Week",
        icon: Icons.trending_up,
        amount: "₹2,100",
        percentageChange: "+8% from last week",
        positive: true,
      ),
      const EarningsStatCard(
        title: "Average Fee",
        icon: Icons.group,
        amount: "₹710",
        subtext: "Per consultation",
      ),
    ];

    if (isMobile) {
      return Column(
        children: [
          for (var c in cards) ...[c, const SizedBox(height: 16)],
        ],
      );
    }

    if (isTablet) {
      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.8,
        physics: const NeverScrollableScrollPhysics(),
        children: cards,
      );
    }

    // Desktop: Row
    return Row(
      children: [
        for (var i = 0; i < cards.length; i++) ...[
          Expanded(child: cards[i]),
          if (i != cards.length - 1) const SizedBox(width: 16),
        ],
      ],
    );
  }
}