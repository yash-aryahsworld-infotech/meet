// =============================================================================
// TAB 2: PROGRAMS
// =============================================================================
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
class ProgramsTab extends StatelessWidget {
  const ProgramsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 900;
      if (isMobile) {
        return Column(
          children: const [
            _ProgramParticipationCard(),
            SizedBox(height: 16),
            _ProgramPerformanceCard(),
          ],
        );
      } else {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Expanded(child: _ProgramParticipationCard()),
            SizedBox(width: 16),
            Expanded(child: _ProgramPerformanceCard()),
          ],
        );
      }
    });
  }
}

class _ProgramParticipationCard extends StatelessWidget {
  const _ProgramParticipationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
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
          const Text(
            "Program Participation",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937)),
          ),
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 0,
                sections: [
                  PieChartSectionData(
                    color: const Color(0xFF3B82F6),
                    value: 120,
                    title: 'Fitness: 120',
                    radius: 80,
                    titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3B82F6)),
                    titlePositionPercentageOffset: 1.4,
                  ),
                  PieChartSectionData(
                    color: const Color(0xFFA855F7),
                    value: 85,
                    title: 'Mental Health: 85',
                    radius: 80,
                    titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFA855F7)),
                    titlePositionPercentageOffset: 1.5,
                  ),
                  PieChartSectionData(
                    color: const Color(0xFF10B981),
                    value: 60,
                    title: 'Nutrition: 60',
                    radius: 80,
                    titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF10B981)),
                    titlePositionPercentageOffset: 1.5,
                  ),
                  PieChartSectionData(
                    color: const Color(0xFFF59E0B),
                    value: 200,
                    title: 'Preventive Care: 200',
                    radius: 80,
                    titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF59E0B)),
                    titlePositionPercentageOffset: 1.5,
                  ),
                  
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgramPerformanceCard extends StatelessWidget {
  const _ProgramPerformanceCard();

  @override
  Widget build(BuildContext context) {
    return Container(
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
          const Text(
            "Program Performance",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937)),
          ),
          const SizedBox(height: 32),
          _buildBar("Fitness", 0.6, "120 participants"),
          const SizedBox(height: 24),
          _buildBar("Mental Health", 0.4, "85 participants"),
          const SizedBox(height: 24),
          _buildBar("Nutrition", 0.3, "60 participants"),
          const SizedBox(height: 24),
          _buildBar("Preventive Care", 0.95, "200 participants"),
        ],
      ),
    );
  }

  Widget _buildBar(String label, double percent, String rightText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            Text(rightText,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 8,
            backgroundColor: Colors.grey.shade100,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
          ),
        ),
      ],
    );
  }
}
