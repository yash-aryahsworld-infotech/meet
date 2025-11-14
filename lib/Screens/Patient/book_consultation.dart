import 'package:flutter/material.dart';

class BookConsultation extends StatefulWidget {
  const BookConsultation({super.key});

  @override
  State<BookConsultation> createState() => _BookConsultationState();
}

class _BookConsultationState extends State<BookConsultation> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Book Consultation",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
