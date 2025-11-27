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
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(20),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ---------- Header ----------
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

            // ---------- Icon ----------
            Icon(
              Icons.videocam_outlined,
              size: 60,
              color: Colors.grey.shade500,
            ),

            const SizedBox(height: 20),

            // ---------- Title ----------
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
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // ---------- Buttons ----------
            LayoutBuilder(
              builder: (context, constraints) {
                final bool isMobile = constraints.maxWidth < 500;
                final double buttonWidth =
                    isMobile ? double.infinity : 220;

                // --- Video Button ---
                final videoButton = SizedBox(
                  width: buttonWidth,
                  child: ElevatedButton.icon(
                    onPressed: _handleVideoCall,
                    icon: const Icon(Icons.videocam, size: 20),
                    label: const Text(
                      "Start Video Call",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      elevation: 3,
                    ),
                  ),
                );

                // --- Audio Button ---
                final audioButton = SizedBox(
                  width: buttonWidth,
                  child: OutlinedButton.icon(
                    onPressed: _handleAudioCall,
                    icon: const Icon(Icons.call, size: 20),
                    label: const Text(
                      "Audio Only",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      side: const BorderSide(color: Color(0xFFD1D5DB)),
                      foregroundColor: Colors.black87,
                    ),
                  ),
                );

                // Mobile → Column, Desktop → Row
                return isMobile
                    ? Column(
                        children: [
                          videoButton,
                          const SizedBox(height: 14),
                          audioButton,
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          videoButton,
                          const SizedBox(width: 14),
                          audioButton,
                        ],
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
