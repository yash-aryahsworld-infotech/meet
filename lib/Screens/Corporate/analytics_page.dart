import 'package:flutter/material.dart';

class CorporateAnalyticsPage extends StatelessWidget {
  const CorporateAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Analytics",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          Container(
            height: 420,
            width: double.infinity,
            decoration: _box(),
            child: Center(
              child: Text(
                "Charts will appear here",
                style: TextStyle(color: Colors.black45),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _box() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(18),
    boxShadow: const [
      BoxShadow(color: Colors.black12, blurRadius: 10)
    ],
  );
}
