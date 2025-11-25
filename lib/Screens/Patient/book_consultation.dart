import 'package:flutter/material.dart';

class BookConsultation extends StatefulWidget {
  const BookConsultation({super.key});

  @override
  State<BookConsultation> createState() => _BookConsultationState();
}

class _BookConsultationState extends State<BookConsultation> {
  void _handleVideoCall() {
    debugPrint("Video call button pressed");
  }

  void _handleAudioCall() {
    debugPrint("Audio call button pressed");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Section
          Row(
            children: [
              const Icon(Icons.videocam_outlined,
                  color: Colors.black87, size: 26),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Book Consultation",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Start or join a telemedicine consultation",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 60),

          // Icon
          Icon(Icons.videocam_outlined,
              size: 60, color: Colors.grey.shade500),

          const SizedBox(height: 20),

          // No Consultation Text
          const Text(
            "No Active Consultation",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "Start a new consultation or join an existing one",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 32),

          // Responsive Buttons
          LayoutBuilder(builder: (context, constraints) {
            // Determine layout based on width
            final bool isMobile = constraints.maxWidth < 500;
            // Mobile: Full width, Desktop: Fixed width
            final double buttonWidth = isMobile ? double.infinity : 200;

            // Video Button Widget
            Widget videoButton = Container(
              width: buttonWidth,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF1D4ED8),
                    Color(0xFF3B82F6),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: _handleVideoCall,
                icon: const Icon(Icons.videocam, color: Colors.white, size: 20),
                label: const Text(
                  "Start Video Call",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            );

            // Audio Button Widget
            Widget audioButton = Container(
              width: buttonWidth,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFD1D5DB), width: 1.4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: OutlinedButton.icon(
                onPressed: _handleAudioCall,
                icon: Icon(
                  Icons.call,
                  color: Colors.grey.shade800,
                  size: 20,
                ),
                label: Text(
                  "Audio Only",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade900,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide.none,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            );

            // Return Column for small screens, Row for large screens
            if (isMobile) {
              return Column(
                children: [
                  videoButton,
                  const SizedBox(height: 14),
                  audioButton,
                ],
              );
            } else {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  videoButton,
                  const SizedBox(width: 14),
                  audioButton,
                ],
              );
            }
          }),
        ],
      ),
    );
  }
}