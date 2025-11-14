import 'package:flutter/material.dart';

class CorporateProgramsPage extends StatelessWidget {
  const CorporateProgramsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Programs",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: List.generate(6, (i) {
              return Container(
                width: 260,
                padding: const EdgeInsets.all(20),
                decoration: _box(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.favorite, color: Colors.red, size: 34),
                    const SizedBox(height: 10),
                    Text("Program $i",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(
                      "Short description of employee wellness program.",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              );
            }),
          )
        ],
      ),
    );
  }

  BoxDecoration _box() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: const [
      BoxShadow(color: Colors.black12, blurRadius: 10)
    ],
  );
}
