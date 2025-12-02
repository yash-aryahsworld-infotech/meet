import 'package:flutter/material.dart';
import 'package:healthcare_plus/Screens/Patient/analyticscomponent/HealthGoalsCard.dart';
import 'package:healthcare_plus/Screens/Patient/analyticscomponent/healthmetricdata.dart';
import 'package:healthcare_plus/Screens/Patient/analyticscomponent/healthremindercard.dart';
import 'package:healthcare_plus/Screens/Patient/analyticscomponent/healthrickcard.dart';
import 'package:healthcare_plus/Screens/Patient/analyticscomponent/healthscorecard.dart';

// --- MAIN SCREEN ---
class Analytics extends StatelessWidget {
  const Analytics({super.key});

  @override
  Widget build(BuildContext context) {
    return Material( // Light grey background
      child: SingleChildScrollView(
        child: Column(
          children: [
            // 1. HEALTH SCORE COMPONENT
            const HealthScoreCard(
              title: "Health Score",
              subtitle: "Your overall health rating based on various metrics",
              score: 78,
              maxScore: 100,
              scoreColor: Color(0xFFF59E0B), // Orange/Gold
            ),
            
            const SizedBox(height: 20),

            // 2. HEALTH TRENDS CHART COMPONENT (Custom Paint - No Library)
            HealthTrendsChart(
              title: "Health Trends",
              subtitle: "Track your key health metrics over time",
              dataPoints: [
                HealthMetricData(month: "Jan", bp: 120, heartRate: 72, weight: 70),
                HealthMetricData(month: "Feb", bp: 118, heartRate: 70, weight: 69.5),
                HealthMetricData(month: "Mar", bp: 122, heartRate: 74, weight: 70),
                HealthMetricData(month: "Apr", bp: 119, heartRate: 71, weight: 69),
                HealthMetricData(month: "May", bp: 121, heartRate: 73, weight: 69.2),
                HealthMetricData(month: "Jun", bp: 117, heartRate: 69, weight: 68.8),
                 HealthMetricData(month: "July", bp: 120, heartRate: 72, weight: 70),
                HealthMetricData(month: "Aug", bp: 118, heartRate: 70, weight: 69.5),
                HealthMetricData(month: "Sep", bp: 122, heartRate: 74, weight: 70),
                HealthMetricData(month: "Oct", bp: 119, heartRate: 71, weight: 69),
                HealthMetricData(month: "Nov", bp: 121, heartRate: 73, weight: 69.2),
                HealthMetricData(month: "Dec", bp: 117, heartRate: 69, weight: 68.8),
              ],
            ),
              const SizedBox(height: 20),

              const HealthRiskCard(),   
              const SizedBox(height: 20),

            // 4. HEALTH GOALS PROGRESS COMPONENT (NEW)
            const HealthGoalsCard(
              title: "Health Goals Progress",
              subtitle: "Track your progress towards health objectives",
              goals: [
                HealthGoalData(
                  label: "Weight Loss",
                  valueText: "69.5 / 68 kg",
                  progress: 0.6,
                  percentageText: "60% complete",
                ),
                HealthGoalData(
                  label: "Blood Pressure",
                  valueText: "119 / 115 mmHg",
                  progress: 0.75,
                  percentageText: "75% complete",
                ),
                HealthGoalData(
                  label: "Exercise",
                  valueText: "4 / 5 days/week",
                  progress: 0.8,
                  percentageText: "80% complete",
                ),
                HealthGoalData(
                  label: "Sleep",
                  valueText: "7 / 8 hours",
                  progress: 0.87,
                  percentageText: "87% complete",
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 5. HEALTH REMINDER COMPONENT (NEW)
            const HealthReminderCard(
              message: "It's been 3 days since your last workout. Consider scheduling some physical activity today for optimal health.",
            ),
          ],
          
        ),
      ),
    );
  }
}