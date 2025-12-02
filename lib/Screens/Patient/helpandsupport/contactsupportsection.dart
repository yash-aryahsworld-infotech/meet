import 'package:flutter/material.dart';
// Make sure to import the files where you saved the components above
import './contactsupport/contactoptionlist.dart';
import './contactsupport/submitticketform.dart';

class ContactSupportSection extends StatelessWidget {
  const ContactSupportSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. TOP CONTACT CARDS SECTION
        ContactOptionsList(),

        SizedBox(height: 32),

        // 2. TICKET FORM SECTION
        SubmitTicketForm(),
      ],
    );
  }
}