import 'package:flutter/material.dart';
import '../../widgets/custom_header.dart';
import '../../utils/app_responsive.dart';
import './earningscomponents/earnings_stat_card.dart';
import '../../widgets/custom_tab.dart';
import './earningscomponents/payment_details_list.dart'; // ⭐ NEW COMPONENT
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

  final List<Map<String, dynamic>> paymentData = [
    {
      "name": "Priya Sharma",
      "type": "Video Consultation",
      "date": "15/01/2024",
      "amount": 500,
      "status": "paid",
    },
    {
      "name": "Rahul Kumar",
      "type": "In-Person Consultation",
      "date": "14/01/2024",
      "amount": 750,
      "status": "paid",
    },
    {
      "name": "Anita Patel",
      "type": "Audio Consultation",
      "date": "13/01/2024",
      "amount": 400,
      "status": "pending",
    },
    {
      "name": "Vikram Singh",
      "type": "Video Consultation",
      "date": "10/01/2024",
      "amount": 600,
      "status": "overdue",
    },
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
          padding: AppResponsive.pagePadding(context),
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

        /// WHITE CONTAINER FOR TAB CONTENT
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: _buildTabContent(),
        ),
      ],
    );
  }

  /// TAB CONTENT
  Widget _buildTabContent() {
    switch (selectedTab) {
      case 0: // Payment History
        return PaymentDetailsList(
          title: "Recent Payments",
          subtitle: "Your latest payment transactions",
          buttonText: "View",
          payments: paymentData,
        );

      case 1: // Pending Payments
        return PaymentDetailsList(
          title: "Pending Payments",
          subtitle: "Payments awaiting processing",
          buttonText: "Follow Up",
          payments: paymentData.where((p) => p["status"] != "paid").toList(),
        );

      case 2: // Analytics
        return Column(
          children: [
            AnalyticsCard(
              title: "Earnings Analytics",
              subtitle: "Detailed breakdown of your earnings",
              type: AnalyticsType.list,
              items: [
                {"label": "Video Consultations", "value": "65% (₹0)"},
                {"label": "In-Person Consultations", "value": "25% (₹0)"},
                {"label": "Audio Consultations", "value": "10% (₹0)"},
              ],
            ),

            SizedBox(height: 20),

            AnalyticsCard(
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
        amount: "₹0",
        subtext: "From 0 consultations",
      ),
      const EarningsStatCard(
        title: "This Month",
        icon: Icons.calendar_today,
        amount: "₹0",
        percentageChange: "+12% from last month",
        positive: true,
      ),
      const EarningsStatCard(
        title: "This Week",
        icon: Icons.trending_up,
        amount: "₹0",
        percentageChange: "+8% from last week",
        positive: true,
      ),
      const EarningsStatCard(
        title: "Average Fee",
        icon: Icons.group,
        amount: "₹0",
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
