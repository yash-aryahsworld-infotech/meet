import 'package:flutter/material.dart';

class CorporateEmployeesPage extends StatelessWidget {
  const CorporateEmployeesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Employees",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),

          const SizedBox(height: 20),

          _searchBar(),

          const SizedBox(height: 20),

          Container(
            height: 550,
            padding: const EdgeInsets.all(10),
            decoration: _boxDecoration(),
            child: ListView.builder(
              itemCount: 12,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(child: Text("E$index")),
                  title: Text("Employee $index"),
                  subtitle: Text("employee$index@company.com"),
                  trailing: Icon(Icons.chevron_right),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: _boxDecoration(),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search employees...",
          border: InputBorder.none,
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 10),
      ],
    );
  }
}
