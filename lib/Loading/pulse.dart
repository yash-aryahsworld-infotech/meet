import 'package:flutter/material.dart';

// --- 1. COPY THESE PAINTER CLASSES (Keep exactly as they were) ---

//        Padding(
//   padding: const EdgeInsets.symmetric(horizontal: 20.0),
//   child: ElevatedButton.icon(
//     onPressed: () {
//       // USE showDialog INSTEAD OF Navigator.push
//       showDialog(
//         context: context,
//         barrierDismissible: true, // Click outside to close
//         builder: (context) {
//           // Dialog wraps the content in a popup box
//           return const Dialog(
//             backgroundColor: Colors.white, // Clean look
//             insetPadding: EdgeInsets.all(20), // Padding from screen edge
//             child: ClipRRect(
//               borderRadius: BorderRadius.all(Radius.circular(20)),
//               // This is your widget from before (100px height)
//               child: HeartbeatBanner(), 
//             ),
//           );
//         },
//       );
//     },
//     icon: const Icon(Icons.favorite),
//     label: const Text("Show Pulse Popup"),
//     style: ElevatedButton.styleFrom(
//       backgroundColor: Colors.redAccent,
//       foregroundColor: Colors.white,
//     ),
//   ),
// ),






class EKGLinePainter extends CustomPainter {
  final Animation<double> animation;
  final List<double> ekgPoints;
  final Color lineColor;
  final double strokeWidth;

  EKGLinePainter({
    required this.animation,
    required this.ekgPoints,
    this.lineColor = Colors.white,
    this.strokeWidth = 3.0,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = lineColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Path path = Path();
    final int pointsToDraw = (ekgPoints.length * animation.value).round();

    if (pointsToDraw > 1) {
      path.moveTo(0, size.height / 2);
      for (int i = 0; i < pointsToDraw; i++) {
        final double x = (size.width / (ekgPoints.length - 1)) * i;
        final double y = size.height / 2 - (ekgPoints[i] * size.height * 0.35); 
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant EKGLinePainter oldDelegate) => true;
}

class EKGAnimation extends StatefulWidget {
  final double width;
  final double height;

  const EKGAnimation({super.key, required this.width, required this.height});

  @override
  State<EKGAnimation> createState() => _EKGAnimationState();
}

class _EKGAnimationState extends State<EKGAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<double> _ekgPattern = [
    0.0, 0.0, 0.0, 0.1, 0.15, 0.0, 0.0, -0.1, 1.0, -0.6, 0.0, 0.2, 0.3, 0.2, 0.0, 0.0, 0.0, 0.0, 0.0
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, 
      duration: const Duration(milliseconds: 1000) 
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: CustomPaint(
        painter: EKGLinePainter(
          animation: _controller,
          ekgPoints: _ekgPattern,
          strokeWidth: 2.5, // Slightly thinner for smaller view
        ),
      ),
    );
  }
}

class HeartBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = const Color(0xFFD32F2F)..style = PaintingStyle.fill;
    Paint shadowPaint = Paint()..color = Colors.redAccent.withValues(alpha: 0.5)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    Path path = Path();
    path.moveTo(size.width / 2, size.height * 0.3);
    path.cubicTo(size.width * 0.1, size.height * 0.05, -size.width * 0.15, size.height * 0.6, size.width / 2, size.height * 0.95);
    path.cubicTo(size.width * 1.15, size.height * 0.6, size.width * 0.9, size.height * 0.05, size.width / 2, size.height * 0.3);
    path.close();
    
    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// --- 2. THE NEW WIDGET (BANNER STYLE) ---

class HeartbeatBanner extends StatefulWidget {
  const HeartbeatBanner({super.key});

  @override
  State<HeartbeatBanner> createState() => _HeartbeatBannerState();
}

class _HeartbeatBannerState extends State<HeartbeatBanner> {
  
  @override
  Widget build(BuildContext context) {
    // Fixed heart size to fit inside 100px height nicely
    const double heartSize = 60.0; 

    return Material(
      color: Colors.white, // Background color for the strip
      child: SizedBox(
        height: 100, // Fixed Height as requested
        width: 100, // Full Width as requested
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 1. BACKGROUND RIPPLE
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(seconds: 2),
              curve: Curves.easeOutQuart,
              onEnd: () { if (mounted) setState(() {}); },
              builder: (context, value, child) {
                return Container(
                  // Grows from heart size to slightly larger
                  width: heartSize + (50 * value),
                  height: heartSize + (50 * value),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.withValues(alpha: 0.3 * (1.0 - value)), 
                  ),
                );
              },
            ),

            // 2. PULSING HEART + EKG
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 1.0, end: 1.12),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOutBack,
              onEnd: () { if (mounted) setState(() {}); },
              builder: (context, scaleValue, child) {
                return Transform.scale(
                  scale: scaleValue,
                  child: SizedBox(
                    width: heartSize, 
                    height: heartSize,
                    child: CustomPaint(
                      painter: HeartBackgroundPainter(),
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: heartSize * 0.15), 
                          // Adjusted EKG size to fit inside the 60px heart
                          child: EKGAnimation(width: heartSize * 0.7, height: heartSize * 0.4),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}