import 'package:flutter/material.dart';

class GenericSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String hintText;

  const GenericSearchBar({
    super.key,
    required this.onChanged,
    this.hintText = 'Search...',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          icon: const Icon(Icons.search, color: Colors.grey),
          hintStyle: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}