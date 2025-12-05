import 'package:flutter/material.dart';
import 'package:healthcare_plus/Screens/Patient/privacycomponent/consentcard.dart';
import 'package:healthcare_plus/Screens/Patient/privacycomponent/consenthistorycomponent.dart';
import 'package:healthcare_plus/Screens/Patient/privacycomponent/infocard.dart';

class PrivacyAndConsent extends StatefulWidget {
  const PrivacyAndConsent({super.key});

  @override
  State<PrivacyAndConsent> createState() => _PrivacyAndConsentState();
}

class _PrivacyAndConsentState extends State<PrivacyAndConsent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Data for the "Your Rights" card
  final List<String> _rightsPoints = [
    "You can withdraw consent at any time (except for essential services)",
    "Changes take effect immediately and are logged for compliance",
    "You can export your complete consent history",
    "Contact our privacy team for any questions or concerns",
  ];

  // Mock Data for the list
  final List<Map<String, dynamic>> _consentList = [
    {
      "id": "1",
      "title": "Essential Healthcare Services",
      "badges": [
        {"text": "essential", "color": "red"},
        {"text": "Required", "color": "orange"},
      ],
      "description":
          "Required for basic platform functionality, authentication, and healthcare delivery",
      "warning": "This consent is required for basic platform functionality",
      "purposes": [
        "Authentication",
        "Healthcare delivery",
        "Security",
        "Legal compliance",
      ],
      "dataTypes": [
        "Personal information",
        "Health records",
        "Authentication data",
        "Transaction data",
      ],
      "grantedOn": "25/11/2025, 16:48:17",
      "isGranted": true,
      "isRequired": true,
    },
    {
      "id": "2",
      "title": "Healthcare Provider Data Sharing",
      "badges": [
        {"text": "functional", "color": "blue"},
      ],
      "description":
          "Allows sharing of health records with verified providers for better diagnosis.",
      "warning": null,
      "purposes": ["Diagnosis", "History sharing", "Consultation"],
      "dataTypes": ["Health records", "Lab results", "Prescriptions"],
      "grantedOn": "20/11/2025, 10:20:00",
      "isGranted": true,
      "isRequired": false,
    },
    {
      "id": "3",
      "title": "Marketing & Promotions",
      "badges": [
        {"text": "optional", "color": "grey"},
      ],
      "description":
          "Receive updates about new features, health tips, and promotional offers.",
      "warning": null,
      "purposes": ["Marketing", "Analytics"],
      "dataTypes": ["Email address", "Usage data"],
      "grantedOn": null,
      "isGranted": false,
      "isRequired": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleConsent(int index) {
    setState(() {
      _consentList[index]['isGranted'] = !_consentList[index]['isGranted'];
      if (_consentList[index]['isGranted']) {
        _consentList[index]['grantedOn'] = DateTime.now().toString().substring(
          0,
          19,
        );
      } else {
        _consentList[index]['grantedOn'] = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildTabs(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // --- TAB 1: PREFERENCES ---
                    // Changed to ListView so we can mix the InfoCard and ConsentCards
                    ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        // Section Label
                        Text(
                          "Manage Consents",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Consent Cards
                        ..._consentList.asMap().entries.map((entry) {
                          int index = entry.key;
                          var data = entry.value;

                          return ConsentCard(
                            data: data,
                            onChanged: (val) => _toggleConsent(index),
                          );
                        }),

                        const SizedBox(height: 24),

                        // ✅ InfoCard moved to END
                        InfoCard(points: _rightsPoints),

                        const SizedBox(height: 50), // padding at bottom
                      ],
                    ),

                    // --- TAB 2: HISTORY ---
                   const SingleChildScrollView(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          ConsentHistoryComponent(),
                          SizedBox(height: 20), // Padding inside the scroll view
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.shield_outlined,
                size: 28,
                color: Colors.grey.shade800,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Privacy & Consent Management",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Control how your personal and health information is used across our platform",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Last updated: 25/11/2025",
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download_rounded, size: 18),
                label: const Text("Export Data"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey.shade800,
                  side: BorderSide(color: Colors.grey.shade300),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.black,
        indicatorWeight: 2,
        tabs: const [
          Tab(text: "Consent Preferences"),
          Tab(text: "Consent History"),
        ],
      ),
    );
  }
}
