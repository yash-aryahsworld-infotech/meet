import 'package:flutter/material.dart';
import 'dart:convert'; // For pretty printing JSON
// ---------------------------------------------------------
// 1. DATA MODEL (Defined in the same file for portability)
// ---------------------------------------------------------
class SecurityLog {
  final String level; // "INFO", "LOW", "HIGH"
  final String title;
  final DateTime timestamp;
  final String? ipAddress;
  final Map<String, dynamic>? jsonDetails;

  SecurityLog({
    required this.level,
    required this.title,
    required this.timestamp,
    this.ipAddress,
    this.jsonDetails,
  });
}




class SecurityMonitorWidget extends StatefulWidget {
  final List<SecurityLog> logs;
  final VoidCallback? onRefresh;

  const SecurityMonitorWidget({
    Key? key, 
    required this.logs, 
    this.onRefresh,
  }) : super(key: key);

  @override
  State<SecurityMonitorWidget> createState() => _SecurityMonitorWidgetState();
}

class _SecurityMonitorWidgetState extends State<SecurityMonitorWidget> {
  bool _showDetails = false;

  void _toggleDetails() {
    setState(() {
      _showDetails = !_showDetails;
    });
  }

  // Helper to get color based on severity
  Color _getLevelColor(String level) {
    switch (level.toUpperCase()) {
      case 'INFO': return Colors.green;
      case 'LOW': return Colors.blue;
      case 'HIGH': return Colors.red;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // --- HEADER ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.security, size: 24, color: Colors.black87),
                    SizedBox(width: 8),
                    Text(
                      "Security Monitor",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    // Show/Hide Details Button
                    TextButton.icon(
                      onPressed: _toggleDetails,
                      style: TextButton.styleFrom(
                        backgroundColor: _showDetails ? Colors.white : Colors.cyan.shade400,
                        foregroundColor: _showDetails ? Colors.black87 : Colors.white,
                        side: _showDetails ? BorderSide(color: Colors.blue.shade700) : null,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      icon: Icon(
                        _showDetails ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        size: 18,
                      ),
                      label: Text(_showDetails ? "Hide Details" : "Show Details"),
                    ),
                    const SizedBox(width: 8),
                    // Refresh Button
                    OutlinedButton(
                      onPressed: widget.onRefresh ?? () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black87,
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      child: const Text("Refresh"),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // --- LIST OF LOGS ---
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.logs.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final log = widget.logs[index];
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Log Header Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.monitor_heart_outlined, color: Colors.grey.shade600, size: 20),
                          const SizedBox(width: 12),
                          // Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getLevelColor(log.level).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              log.level,
                              style: TextStyle(
                                color: _getLevelColor(log.level),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      log.title, 
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      // Formatting simple date for demo
                                      "${log.timestamp.day}/${log.timestamp.month}/${log.timestamp.year}, ${log.timestamp.hour}:${log.timestamp.minute}:${log.timestamp.second}",
                                      style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      
                      // EXPANDED DETAILS (JSON VIEW)
                      if (_showDetails && log.jsonDetails != null) ...[
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.only(left: 32.0), // Indent to align with text
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  const JsonEncoder.withIndent('  ').convert(log.jsonDetails),
                                  style: TextStyle(
                                    fontFamily: 'Courier', // Monospace font
                                    fontSize: 12,
                                    color: Colors.grey.shade800,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                              if (log.ipAddress != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    "IP: ${log.ipAddress}",
                                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ]
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}