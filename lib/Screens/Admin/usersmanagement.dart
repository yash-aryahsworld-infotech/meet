import 'package:flutter/material.dart';
import 'package:healthcare_plus/widgets/custom_header.dart';

class UsersManagementPage extends StatelessWidget {
  const UsersManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            title: "User Management",
            button1Text: "export users",
            button1OnPressed: () => {},
            button2Text: "Add User",
            button2OnPressed: () => {},
          ),

          
        ],
      ),
    );
  }
}
