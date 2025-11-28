import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_plus/Screens/Corporate/analytics/health_metrics_trend_card.dart';
import 'package:healthcare_plus/Screens/Corporate/analytics/risk_distribution_card.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top Row: Health Trend & Risk Dist
        LayoutBuilder(builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 900;
          if (isMobile) {
            return Column(
              children: const [
                HealthMetricsTrendCard(),
                SizedBox(height: 16),
                RiskDistributionCard(),
              ],
            );
          } else {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Expanded(flex: 3, child: HealthMetricsTrendCard()),
                SizedBox(width: 16),
                Expanded(flex: 2, child: RiskDistributionCard()),
              ],
            );
          }
        }),
        const SizedBox(height: 16),
        // Bottom Row: Monthly Claims vs Screenings
        const MonthlyClaimsChart(),
      ],
    );
  }
}





class MonthlyClaimsChart extends StatelessWidget {
  const MonthlyClaimsChart({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.9,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,

          // -------------------- TOUCH TOOLTIP --------------------
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
        
              tooltipPadding: const EdgeInsets.all(8),
     
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final month = _months[group.x.toInt()];
                final screenings = _screenings[group.x.toInt()];
                final claims = _claims[group.x.toInt()];

                return BarTooltipItem(
                  "$month\n"
                  "Health Screenings : $screenings\n"
                  "Insurance Claims : $claims",
                  const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ),

          // -------------------- AXIS TITLES --------------------
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),

            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 38,
                getTitlesWidget: (value, meta) {
                  const style = TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  );

                  return SideTitleWidget(
                    meta: meta,
                    child: Text(
                      _months[value.toInt()],
                      style: style,
                    ),
                  );
                },
              ),
            ),

            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(
                      value.toInt().toString(),
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 12,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),

          // -------------------- BARS --------------------
          barGroups: _buildBarGroups(),
        ),
      ),
    );
  }

  // -------------------------------------------------------
  // YOUR MONTHLY DATA (MATCHES THE IMAGE)
  // -------------------------------------------------------
  static const List<String> _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];

  static const List<double> _screenings = [45, 52, 48, 60, 55, 70];
  static const List<double> _claims = [12, 8, 15, 7, 11, 4];

  // -------------------------------------------------------
  // BUILD CHART GROUPS (2 bars per month)
  // -------------------------------------------------------
  List<BarChartGroupData> _buildBarGroups() {
    return List.generate(_months.length, (index) {
      return BarChartGroupData(
        x: index,
        barsSpace: 8,
        barRods: [
          BarChartRodData(
            toY: _screenings[index],
            width: 16,
            borderRadius: BorderRadius.circular(4),
            color: const Color(0xFF1665D8), // Blue
          ),
          BarChartRodData(
            toY: _claims[index],
            width: 16,
            borderRadius: BorderRadius.circular(4),
            color: const Color(0xFFE53935), // Red
          ),
        ],
      );
    });
  }
}
