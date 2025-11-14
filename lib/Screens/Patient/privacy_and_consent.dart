import 'package:flutter/material.dart';

class PrivacyAndConsent extends StatefulWidget {
  const PrivacyAndConsent({super.key});

  @override
  State<PrivacyAndConsent> createState() => _PrivacyAndConsentState();
}

class _PrivacyAndConsentState extends State<PrivacyAndConsent> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Privacy & Consent",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
