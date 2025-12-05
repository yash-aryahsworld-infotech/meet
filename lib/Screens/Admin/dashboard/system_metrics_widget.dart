import 'package:flutter/material.dart';

// --- DATA MODELS ---
class SystemMetric {
  final String label;
  final String value;
  final Color valueColor;
  final Color valueBgColor;
  final IconData icon;

  SystemMetric({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.valueBgColor,
    required this.icon,
  });
}

class SecurityCheckItem {
  final String label;
  final bool isSecure;

  SecurityCheckItem(this.label, this.isSecure);
}

// --- WIDGET ---
class SystemMetricsWidget extends StatelessWidget {
  final List<SystemMetric> metrics;
  final List<SecurityCheckItem> checklist;

  const SystemMetricsWidget({
    super.key,
    required this.metrics,
    required this.checklist,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "System Metrics",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            // Metrics List
            ...metrics.map((m) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                children: [
                  Icon(m.icon, size: 20, color: Colors.grey.shade600),
                  const SizedBox(width: 12),
                  Text(m.label, style: const TextStyle(color: Colors.black87)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: m.valueBgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      m.value,
                      style: TextStyle(
                        color: m.valueColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  )
                ],
              ),
            )),
            const SizedBox(height: 16),
            Divider(color: Colors.grey.shade200),
            const SizedBox(height: 16),
            Text(
              "Security Implementation Status:",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            const SizedBox(height: 12),
            // Checklist
            ...checklist.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Icon(
                    item.isSecure ? Icons.check_circle_outline : Icons.warning_amber_rounded,
                    size: 16,
                    color: item.isSecure ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item.label,
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}