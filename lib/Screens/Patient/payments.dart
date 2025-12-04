import 'package:flutter/material.dart';
import 'package:healthcare_plus/Screens/Patient/patientcomponents/payment_breakdown_card.dart';
import 'package:healthcare_plus/Screens/Patient/patientcomponents/payment_method_card.dart';
import 'package:healthcare_plus/Screens/Patient/patientcomponents/trust_footer.dart';

class Payments extends StatefulWidget {
  const Payments({super.key});

  @override
  State<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  // Track the currently selected payment method
  int _selectedIndex = 0;

  // Base consultation amount
  // Note: I unified the logic here. The class level var is used for calculation.
  final double _baseAmount = 2500.00; 

  late final List<Map<String, dynamic>> _paymentMethods;

  @override
  void initState() {
    super.initState();
    
    // Color Constants for Badges
    const greenBg = Color(0xFFDCFCE7);
    const greenText = Color(0xFF166534);
    const grayBg = Color(0xFFF3F4F6);
    const grayText = Color(0xFF374151);

    _paymentMethods = [
      // 1. UPI
      {
        "id": "upi",
        "title": "UPI (Recommended)",
        "icon": Icons.bolt, 
        "baseAmount": _baseAmount,
        "fee": 0.00,
        "badges": [
          {'text': "Most Popular", 'bgColor': greenBg, 'textColor': greenText},
          {'text': "No Fee", 'bgColor': grayBg, 'textColor': grayText},
        ],
        "tags": ['Zero fees', 'Instant confirmation', 'Most popular'],
        "features": ["Instant", "No fees"],
      },
      // 2. Credit/Debit Cards
      {
        "id": "card",
        "title": "Credit/Debit Cards",
        "icon": Icons.credit_card_outlined,
        "baseAmount": _baseAmount,
        "fee": 45.00,
        "badges": [],
        "tags": ['Widely accepted', 'EMI available', 'Secure'],
        "features": ["2-3 minutes", "1.8% fee"],
      },
      // 3. Digital Wallets
      {
        "id": "wallet",
        "title": "Digital Wallets",
        "icon": Icons.account_balance_wallet_outlined,
        "baseAmount": _baseAmount,
        "fee": 12.50,
        "badges": [],
        "tags": ['Quick payment', 'Rewards available', 'No OTP required'],
        "features": ["Instant", "0.5% fee"],
      },
      // 4. Net Banking
      {
        "id": "netbanking",
        "title": "Net Banking",
        "icon": Icons.account_balance,
        "baseAmount": _baseAmount,
        "fee": 50.00,
        "badges": [],
        "tags": ['Bank security', 'Higher limits', 'Detailed records'],
        "features": ["3-5 minutes", "2% fee"],
      },
      // 5. EMI Financing
      {
        "id": "emi",
        "title": "EMI Financing",
        "icon": Icons.calculate_outlined,
        "baseAmount": _baseAmount,
        "fee": 0.00,
        "badges": [
          {'text': "No Fee", 'bgColor': grayBg, 'textColor': grayText},
        ],
        "tags": ['0% interest options', 'Flexible tenure', 'Instant approval'],
        "features": ["5-10 minutes", "No fees"],
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Calculate current totals based on selection
    final selectedMethod = _paymentMethods[_selectedIndex];
    final double currentFee = (selectedMethod['fee'] as num).toDouble();
    final double totalPayable = _baseAmount + currentFee;

    return Material(
      // 1. Set background to light grey so the white container is visible
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              // --- START: WHITE CONTAINER WRAPPER ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20), // Padding inside the white box
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  // Optional: Subtle shadow to make it pop
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Header (Inside Container)
                    Text(
                      "💻 Transparent Payment Gateway",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      "Pay for Teleconsultation • Amount: ₹${_baseAmount.toStringAsFixed(0)} • All fees disclosed upfront",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade500,
                        height: 1.5,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // 2. Payment Method List (Inside Container)
                    ...List.generate(_paymentMethods.length, (index) {
                      return PaymentMethodCard(
                        data: _paymentMethods[index],
                        isSelected: _selectedIndex == index,
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                      );
                    }),
                  ],
                ),
              ),
              // --- END: WHITE CONTAINER WRAPPER ---

              const SizedBox(height: 24),

              // 3. Breakdown Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  "Order Summary",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              PaymentBreakdownCard(
                baseAmount: _baseAmount,
                fee: currentFee,
                totalPayable: totalPayable,
              ),

              const SizedBox(height: 32),

              // 4. Pay Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Processing payment of ₹${totalPayable.toStringAsFixed(0)} via ${selectedMethod['title']}",
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    elevation: 0, // Flat design is more modern
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock, size: 20, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        "Pay ₹${totalPayable.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // 5. Trust Footer
              const Center(child: TrustFooter()),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}