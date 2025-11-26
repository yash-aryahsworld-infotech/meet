import 'package:flutter/material.dart';
import 'package:healthcare_plus/Screens/patient/walletcomponents/statssection.dart';
import 'package:healthcare_plus/Screens/Patient/walletcomponents/balancesection.dart';
import 'package:healthcare_plus/Screens/Patient/walletcomponents/transactionhistorysection.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF3F4F6), // backgroundColor of Scaffold

      child: Stack(
        children: [
          // -----------------------
          // PAGE CONTENT
          // -----------------------
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Digital Wallet",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Text(
                  "Your healthcare payment wallet with instant transactions",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),

                // Balance
                const BalanceSection(),
                const SizedBox(height: 24),

                // Transactions
                const TransactionHistorySection(),
                const SizedBox(height: 24),

                // Stats
                const StatsSection(),
                const SizedBox(height: 20), // space for FAB
              ],
            ),
          ),
        ],
      ),
    );
  }
}
