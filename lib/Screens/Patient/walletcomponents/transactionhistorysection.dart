import 'package:flutter/material.dart';
import 'package:healthcare_plus/widgets/custom_tab.dart';
import 'package:healthcare_plus/utils/app_responsive.dart'; // ← your responsive file

class TransactionHistorySection extends StatefulWidget {
  const TransactionHistorySection({super.key});

  @override
  State<TransactionHistorySection> createState() => _TransactionHistorySectionState();
}

class _TransactionHistorySectionState extends State<TransactionHistorySection> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ["All", "Paid", "Received", "Refunds"];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ------------------------------------------------
          // HEADER (Responsive)
          // ------------------------------------------------
          LayoutBuilder(
            builder: (context, constraints) {
              bool isMobile = constraints.maxWidth < 600;

              final titleRow = const Row(
                children: [
                  Icon(Icons.description_outlined, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Transaction History",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              );

              final statementButton = OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download, size: 16, color: Colors.grey),
                label: const Text(
                  "Statement",
                  style: TextStyle(color: Colors.grey),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );

              return isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        titleRow,
                        const SizedBox(height: 12),
                        statementButton, // Statement button on new line
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        titleRow,
                        statementButton,
                      ],
                    );
            },
          ),

          const SizedBox(height: 20),

          // ------------------------------------------------
          // SEARCH + TABTOGGLE RESPONSIVE
          // ------------------------------------------------
          LayoutBuilder(
            builder: (context, constraints) {
              bool isSmall = constraints.maxWidth < 700;

              // SEARCH BAR
              final searchBar = TextField(
                decoration: InputDecoration(
                  hintText: "Search transactions...",
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              );

              // TAB TOGGLE (direct)
              final tabToggle = TabToggle(
                options: _tabs,
                selectedIndex: _selectedTabIndex,
                onSelected: (index) {
                  setState(() => _selectedTabIndex = index);
                },
              );

              return isSmall
                  ? Column(
                      children: [
                        searchBar,
                        const SizedBox(height: 12),
                        tabToggle,
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(child: searchBar),
                        const SizedBox(width: 16),
                        tabToggle,
                      ],
                    );
            },
          ),

          const SizedBox(height: 40),

          // ------------------------------------------------
          // EMPTY STATE
          // ------------------------------------------------
          Center(
            child: Column(
              children: [
                Icon(Icons.search_off, size: 48, color: Colors.grey.shade300),
                const SizedBox(height: 12),
                Text(
                  "No transactions found",
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
