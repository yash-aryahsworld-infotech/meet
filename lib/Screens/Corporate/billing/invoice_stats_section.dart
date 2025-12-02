import 'package:flutter/material.dart';
import 'package:healthcare_plus/widgets/custom_quickstats_card.dart';

class InvoiceStatsSection extends StatelessWidget {
  final int totalInvoices;
  final int paidInvoices;
  final int pendingAmount;
  final int avgMonthlySpend;

  const InvoiceStatsSection({
    super.key,
    required this.totalInvoices,
    required this.paidInvoices,
    required this.pendingAmount,
    required this.avgMonthlySpend,
  });

  @override
  Widget build(BuildContext context) {
    final stats = [
      StatItem(
        title: "Total Invoices",
        count: totalInvoices.toString(),
        icon: Icons.description_outlined,
        themeColor: Colors.blue,
      ),
      StatItem(
        title: "Paid Invoices",
        count: paidInvoices.toString(),
        icon: Icons.check_circle_outline,
        themeColor: Colors.green,
      ),
      StatItem(
        title: "Pending Amount",
        count: "₹${pendingAmount.toString()}",
        icon: Icons.error_outline,
        themeColor: Colors.red,
      ),
      StatItem(
        title: "Avg Monthly Spend",
        count: "₹${avgMonthlySpend.toString()}",
        icon: Icons.show_chart,
        themeColor: Colors.deepPurple,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;

        int crossAxis = width < 600 ? 2 : 4; // mobile → 2, desktop → 4
        double gap = 16;
        double itemWidth = (width - (gap * (crossAxis - 1))) / crossAxis;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: stats
              .map((item) => SizedBox(
                    width: itemWidth,
                    child: QuickStatCard(item: item),
                  ))
              .toList(),
        );
      },
    );
  }
}