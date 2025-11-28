
// =============================================================================
// TAB 4: FINANCIAL
// =============================================================================
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
class FinancialTab extends StatelessWidget {
  const FinancialTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // CHART
        Container(
          height: 350,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Cost Savings Analysis",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937))),
              const SizedBox(height: 24),
              Expanded(
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 240000,
                    barTouchData: BarTouchData(enabled: false),
                    gridData: FlGridData(
                        show: true,
                        horizontalInterval: 60000,
                        drawVerticalLine: true),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 45,
                          interval: 60000,
                          getTitlesWidget: (value, meta) => Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.grey)),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final qs = ["Q1", "Q2", "Q3", "Q4"];
                            if (value.toInt() >= 0 && value.toInt() < 4) {
                              return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(qs[value.toInt()]));
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(
                        show: true,
                        border: const Border(
                            bottom: BorderSide(color: Colors.black12),
                            left: BorderSide(color: Colors.black12))),
                    barGroups: [
                      _makeGroup(0, 180000, 120000),
                      _makeGroup(1, 195000, 125000),
                      _makeGroup(2, 210000, 130000),
                      _makeGroup(3, 230000, 135000),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // BOTTOM CARDS
        LayoutBuilder(builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 800;
          return Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildSummaryCard(
                "Total Savings YTD",
                "₹3.0L",
                "vs traditional approach",
                const Color(0xFF10B981),
                isMobile
                    ? constraints.maxWidth
                    : (constraints.maxWidth - 32) / 3,
              ),
              _buildSummaryCard(
                "ROI on Wellness Programs",
                "280%",
                "return on investment",
                const Color(0xFF3B82F6),
                isMobile
                    ? constraints.maxWidth
                    : (constraints.maxWidth - 32) / 3,
              ),
              _buildSummaryCard(
                "Avg Cost per Employee",
                "₹1,538",
                "monthly healthcare cost",
                const Color(0xFFA855F7),
                isMobile
                    ? constraints.maxWidth
                    : (constraints.maxWidth - 32) / 3,
              ),
            ],
          );
        }),
      ],
    );
  }

  BarChartGroupData _makeGroup(int x, double y1, double y2) {
    return BarChartGroupData(
      x: x,
      barsSpace: 0, // Bars touching each other in group? Image shows gap.
      barRods: [
        BarChartRodData(
            toY: y1,
            color: const Color(0xFFEF4444),
            width: 40,
            borderRadius: BorderRadius.zero),
        BarChartRodData(
            toY: y2,
            color: const Color(0xFF3B82F6),
            width: 40,
            borderRadius: BorderRadius.zero),
      ],
    );
  }

  Widget _buildSummaryCard(
      String title, String value, String sub, Color color, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Text(title,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(sub, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}
