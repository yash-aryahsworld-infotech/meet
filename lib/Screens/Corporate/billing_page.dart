import 'package:flutter/material.dart';
import 'package:healthcare_plus/Screens/Corporate/billing/invoice_stats_section.dart';
import 'package:healthcare_plus/Screens/Corporate/billing/invoice_tab.dart';
import 'package:healthcare_plus/Screens/Corporate/billing/payment_method.dart';
import 'package:healthcare_plus/Screens/Corporate/billing/subscription_tab.dart';
import 'package:healthcare_plus/utils/app_responsive.dart';
import 'package:healthcare_plus/widgets/custom_header.dart';
import 'package:healthcare_plus/widgets/custom_tab.dart';

// Your tab screens:


class CorporateBillingPage extends StatefulWidget {
  const CorporateBillingPage({super.key});

  @override
  State<CorporateBillingPage> createState() => _CorporateBillingPageState();
}

class _CorporateBillingPageState extends State<CorporateBillingPage> {
  int selectedTab = 0;

  final List<String> tabs = [
    "Invoices",
    "Subscritions",
    "Payment Methods",
  ];

  @override
  Widget build(BuildContext context) {
    final bool isMobile = AppResponsive.isMobile(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            title: "Billing & Payments",
            button1Icon: Icons.download,
            button1Text: "Export All",
            button1OnPressed: () {},
            button2Icon: Icons.card_membership,
            button2Text: isMobile ? "Update" : "Update Payment Method",
            button2OnPressed: () {},
          ),

          const InvoiceStatsSection(
            totalInvoices: 4,
            paidInvoices: 2,
            pendingAmount: 90000,
            avgMonthlySpend: 48167,
          ),

          

   
          const SizedBox(height: 20),

          // TAB 
         
          TabToggle(
            
            options: tabs,
            selectedIndex: selectedTab,
            onSelected: (index) {
              setState(() {
                selectedTab = index;
              });
            },
          ),
          

          const SizedBox(height: 20),

          // TAB CONTENT
          _buildTabContent(),
        ],
      ),
    );
  }

  // --------------------------------------------
  // TAB CONTENT HANDLER
  // --------------------------------------------
  Widget _buildTabContent() {
    switch (selectedTab) {
      case 0:
        return const InvoicesPage();
      case 1:
        return const SubscriptionPage();
      case 2:
        return const PaymentMethodsPage();
      default:
        return const InvoicesPage();
    }
  }
}
