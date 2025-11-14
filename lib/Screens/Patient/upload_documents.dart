import 'package:flutter/material.dart';

class UploadDocuments extends StatefulWidget {
  const UploadDocuments({super.key});

  @override
  State<UploadDocuments> createState() => _UploadDocumentsState();
}

class _UploadDocumentsState extends State<UploadDocuments> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Upload Documents",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
