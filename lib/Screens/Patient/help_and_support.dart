import 'package:flutter/material.dart';

import 'package:healthcare_plus/Screens/Patient/helpandsupport/helpheader.dart';
import 'package:healthcare_plus/widgets/custom_support_tab_toggle.dart';
import './helpandsupport/contactsupportsection.dart';
import './helpandsupport/mytickets.dart';
import './helpandsupport/resourcesection.dart';
// Import the FAQ Section we just created:
import './helpandsupport/faqsection.dart'; 

class HelpAndSupport extends StatefulWidget {
  const HelpAndSupport({super.key});

  @override
  State<HelpAndSupport> createState() => _HelpAndSupportState();
}

class _HelpAndSupportState extends State<HelpAndSupport> {
  int _currentTabIndex = 0;

  final List<String> _tabs = [
    "FAQ",
    "Contact Support",
    "My Tickets",
    "Resources"
  ];

  // 1. DATA: Categories for the Chips (Horizontal scroll)
  final List<FaqCategory> _faqCategories = [
    FaqCategory("acc", "Account & Profile", Icons.person_outline),
    FaqCategory("apt", "Appointments", Icons.videocam_outlined),
    FaqCategory("pay", "Payments & Billing", Icons.receipt_long_outlined),
    FaqCategory("sec", "Privacy & Security", Icons.security_outlined),
    FaqCategory("rx", "Prescriptions", Icons.description_outlined),
    FaqCategory("ins", "Insurance", Icons.verified_user_outlined),
  ];

  // 2. DATA: Questions List
  final List<FaqItem> _faqData = [
    FaqItem(
      question: "How do I create an account?",
      answer: "To create an account, click 'Sign Up' on the homepage and follow the instructions.",
      categories: ["Account & Profile", "Privacy & Security"],
      tags: ["signup", "onboarding"],
    ),
    FaqItem(
      question: "How do I book a teleconsultation?",
      answer: "Go to the 'Appointments' tab and select 'Book New'. Choose your doctor and time slot.",
      categories: ["Appointments"],
    ),
    FaqItem(
      question: "What payment methods are accepted?",
      answer: "We accept Visa, MasterCard, UPI, and Net Banking.",
      categories: ["Payments & Billing", "Appointments"],
    ),
    FaqItem(
      question: "How secure is my health data?",
      answer: "We use end-to-end encryption to ensure your data is safe according to HIPAA guidelines.",
      categories: ["Privacy & Security", "Account & Profile"],
      tags: ["encryption", "security", "hipaa"],
      helpfulCount: 124,
    ),
    FaqItem(
      question: "Can I download my prescriptions?",
      answer: "Yes, go to the 'Prescriptions' tab to download PDFs of your past prescriptions.",
      categories: ["Prescriptions", "Appointments"],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(// Global background color
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. HEADER COMPONENT
            const HelpHeader(), // Using dummy widget below
            
            const SizedBox(height: 20),

            // 2. TAB NAVIGATION
            SupportTabsToggle(
              tabs: _tabs,
              selectedIndex: _currentTabIndex,
              onSelected: (index) {
                setState(() {
                  _currentTabIndex = index;
                });
              },
            ),
            
            const SizedBox(height: 20),

            // 3. DYNAMIC CONTENT
            IndexedStack(
              index: _currentTabIndex,
              children: [
                // INDEX 0: FAQ
                FaqSection(
                  items: _faqData, 
                  categories: _faqCategories // Pass categories here
                ),      
                
                // INDEX 1-3: Other Sections
                const ContactSupportSection(),    
                const MyTicketsSection(),        
                const ResourcesSection(),        
              ],
            ),
          ],
        ),
      ),
    );
  }
}