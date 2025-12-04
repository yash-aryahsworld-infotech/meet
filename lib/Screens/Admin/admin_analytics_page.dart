import 'package:flutter/material.dart';
import './analytics/overview_tab.dart'; // Assumes the toggle file is here
import './analytics/projections_tab.dart';
import './analytics/revenue_tab.dart';
import './analytics/users_tab.dart';
import "../../widgets/custom_support_tab_toggle.dart";

class AdminAnalyticsPage extends StatefulWidget {
  const AdminAnalyticsPage({super.key});

  @override
  State<AdminAnalyticsPage> createState() => _AdminAnalyticsPageState();
}

class _AdminAnalyticsPageState extends State<AdminAnalyticsPage> {
  int _selectedIndex = 0;

  final List<String> _tabs = ["Overview", "Revenue", "Users", "Projections"];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Analytics Dashboard",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Text(
                  "Real-time Data",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // The Custom Toggle Tab
          SupportTabsToggle(
            tabs: _tabs,
            selectedIndex: _selectedIndex,
            onSelected: (index) {
              setState(() => _selectedIndex = index);
            },
          ),

          const SizedBox(height: 24),

          // Content Switcher
          IndexedStack(
            index: _selectedIndex,
            children: const [
              OverviewTab(),
              RevenueTab(),
              UsersTab(),
              ProjectionsTab(),
            ],
          ),
        ],
      ),
    );
  }
}
