import 'package:flutter/material.dart';

class DepartmentsTab extends StatelessWidget {
  const DepartmentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final depts = [
      {"name": "Engineering", "score": "78", "prog": "3.2", "claims": "5", "count": "80"},
      {"name": "Sales", "score": "72", "prog": "2.8", "claims": "8", "count": "45"},
      {"name": "Marketing", "score": "85", "prog": "4.1", "claims": "2", "count": "25"},
      {"name": "HR", "score": "88", "prog": "4.5", "claims": "1", "count": "15"},
      {"name": "Finance", "score": "75", "prog": "3", "claims": "4", "count": "30"},
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Department Health Overview",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 16),

              // Responsive department cards
              ...depts.map((d) => _DepartmentCard(data: d, isMobile: isMobile)),
            ],
          ),
        );
      },
    );
  }
}

class _DepartmentCard extends StatelessWidget {
  final Map<String, String> data;
  final bool isMobile;
  const _DepartmentCard({required this.data, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data["name"]!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  "${data["count"]} employees",
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// Metrics – Responsive Layout
          if (!isMobile)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _metric("Avg Health Score", data["score"]!),
                _metric("Programs per Employee", data["prog"]!),
                _metric("Claims this Quarter", data["claims"]!),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: _metric("Avg Health Score", data["score"]!)),
                    Expanded(child: _metric("Programs / Employee", data["prog"]!)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _metric("Claims this Quarter", data["claims"]!)),
                  ],
                )
              ],
            ),
        ],
      ),
    );
  }

  Widget _metric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
