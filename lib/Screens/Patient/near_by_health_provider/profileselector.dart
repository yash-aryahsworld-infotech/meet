import 'package:flutter/material.dart';

class ProfileSelector extends StatelessWidget {
  final List<Map<String, dynamic>> profiles;
  final String? selectedKey;
  final ValueChanged<String?> onChanged;

  const ProfileSelector({
    super.key,
    required this.profiles,
    required this.selectedKey,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: selectedKey,
          hint: const Text("Select Profile"),
          icon: const Icon(Icons.arrow_drop_down),
          items: profiles.map((profile) {
            return DropdownMenuItem<String>(
              value: profile['key'],
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: profile['isMain'] ? Colors.blue.shade100 : Colors.orange.shade100,
                    child: Text(
                      profile['name'][0].toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: profile['isMain'] ? Colors.blue.shade900 : Colors.orange.shade900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(profile['name'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(width: 5),
                  Text("(${profile['relation']})", style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}