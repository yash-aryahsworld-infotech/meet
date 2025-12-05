import 'package:flutter/material.dart';
import 'package:healthcare_plus/Screens/Patient/analyticscomponent/charpointer.dart';

class HealthMetricData {
  final String month;
  final double bp;
  final double heartRate;
  final double weight;

  HealthMetricData({
    required this.month,
    required this.bp,
    required this.heartRate,
    required this.weight,
  });
}
// --- The Fixed Chart Component ---
class HealthTrendsChart extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<HealthMetricData> dataPoints;

  const HealthTrendsChart({
    super.key,
    required this.title,
    required this.subtitle,
    required this.dataPoints,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive calculations
    final isSmallScreen = MediaQuery.of(context).size.width < 400;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.trending_up, color: Colors.grey.shade800, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 30),

          // --- CHART SECTION ---
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            // 1. Add padding to the scroll view so start/end aren't flush
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              height: 200,
              // 2. FIXED: Add extra buffer (+ 40) to width calculation 
              // to ensure the last label "Dec" has space to draw.
              width: (dataPoints.length * 60.0) + 40, 
              child: CustomPaint(
                painter: ChartPainter(dataPoints: dataPoints),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Legend / Key
          Center(
            child: Wrap(
              spacing: 16,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _buildLegendItem("BP", const Color(0xFF3B82F6)),
                _buildLegendItem("Heart Rate", const Color(0xFFEF4444)),
                _buildLegendItem("Weight", const Color(0xFF10B981)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label,
            style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}