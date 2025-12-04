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
        const CostSavingsTab(),
      ],
    );
  }
}





class CostSavingsTab extends StatefulWidget {
  const CostSavingsTab({super.key});

  @override
  State<CostSavingsTab> createState() => _CostSavingsTabState();
}

class _CostSavingsTabState extends State<CostSavingsTab> {
  // -------------------------------------------------------
  // DATA FOR THE CHART
  // -------------------------------------------------------
  static const List<String> _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
  static const List<double> _blueData = [45, 52, 48, 60, 55, 70]; // Savings
  static const List<double> _redData = [12, 8, 15, 7, 11, 4];     // Costs

  // 1. Animation State Variable
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    // 2. Trigger animation start after build
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _isLoaded = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // -------------------------------------------------------
        // CHART CARD
        // -------------------------------------------------------
        Container(
          height: 350,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
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
              
              // 🔹 ANIMATED BAR CHART
              Expanded(
                child: BarChart(
                  BarChartData(
                    // 3. Animation Configuration
                    // swapAnimationDuration: const Duration(milliseconds: 800),
                    // swapAnimationCurve: Curves.easeInOutQuint,
                    
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 80, 

                    // Tooltip Logic
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final month = _months[group.x.toInt()];
                          final val1 = _blueData[group.x.toInt()];
                          final val2 = _redData[group.x.toInt()];
                          return BarTooltipItem(
                            "$month\n"
                            "Savings : ${val1.toInt()}k\n"
                            "Costs : ${val2.toInt()}k",
                            const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        },
                      ),
                    ),

                    // Axis Titles
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
                            if (value.toInt() < 0 || value.toInt() >= _months.length) {
                              return const SizedBox();
                            }
                            return SideTitleWidget(
                              meta: meta,
                              child: Text(
                                _months[value.toInt()],
                                style: const TextStyle(
                                  color: Color(0xFF6B7280),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: 20, 
                          getTitlesWidget: (value, meta) {
                            if (value == 0) return const SizedBox();
                            return SideTitleWidget(
                              meta: meta,
                              child: Text(
                                "${value.toInt()}k",
                                style: const TextStyle(
                                  color: Color(0xFF6B7280),
                                  fontSize: 10,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    gridData: FlGridData(
                      show: true, 
                      drawVerticalLine: false,
                      horizontalInterval: 20,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: Colors.grey.shade100,
                        strokeWidth: 1,
                      ),
                    ),
                    borderData: FlBorderData(show: false),

                    // 4. BARS with Animation Logic
                    barGroups: _buildBarGroups(),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // -------------------------------------------------------
        // BOTTOM CARDS (Static)
        
      ],
    );
  }

  // -------------------------------------------------------
  // BUILD ANIMATED BAR GROUPS
  // -------------------------------------------------------
  List<BarChartGroupData> _buildBarGroups() {
    return List.generate(_months.length, (index) {
      return BarChartGroupData(
        x: index,
        barsSpace: 8, 
        barRods: [
          // Blue Bar
          BarChartRodData(
            // 5. If Loaded: show data, Else: show 0 (grows from bottom)
            toY: _isLoaded ? _blueData[index] : 0, 
            width: 16,
            borderRadius: BorderRadius.circular(4),
            color: const Color(0xFF1665D8),
          ),
          // Red Bar
          BarChartRodData(
            // 5. If Loaded: show data, Else: show 0
            toY: _isLoaded ? _redData[index] : 0,
            width: 16,
            borderRadius: BorderRadius.circular(4),
            color: const Color(0xFFE53935), 
          ),
        ],
      );
    });
  }

 
 
}