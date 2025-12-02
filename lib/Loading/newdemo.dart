import 'dart:ui'; // Required for PathMetric
import 'package:flutter/material.dart';

class HeartbeatDrawingAnimation extends StatefulWidget {
  const HeartbeatDrawingAnimation({super.key});

  @override
  State<HeartbeatDrawingAnimation> createState() => _HeartbeatDrawingAnimationState();
}

class _HeartbeatDrawingAnimationState extends State<HeartbeatDrawingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Takes 3 seconds to draw
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    // Start the animation (looping for demo purposes)
    _controller.repeat(); 
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 200,
          height: 200,
          // This CustomPaint widget delegates the drawing to our class below
          child: CustomPaint(
            painter: HeartbeatPathPainter(_animation.value),
          ),
        ),
      ),
    );
  }
}

class HeartbeatPathPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0

  HeartbeatPathPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Define Paint Styles
    
    // Pink Paint (Outer Heart)
    final Paint pinkPaint = Paint()
      ..color = const Color(0xFFE91E63) // Pink/Magenta
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Teal Paint (Inner Pulse)
    final Paint tealPaint = Paint()
      ..color = const Color(0xFF00BCD4) // Teal/Cyan
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // 2. Define the Paths
    // We define the paths relative to a 100x100 grid and scale it up
    
    // The Heart Outline Path (approximated from your image)
    final Path heartPath = Path();
    heartPath.moveTo(size.width * 0.5, size.height * 0.95); // Bottom tip
    heartPath.cubicTo(
      size.width * 0.1, size.height * 0.6, // Control point 1
      size.width * 0.1, size.height * 0.1, // Control point 2
      size.width * 0.5, size.height * 0.25, // Top center dip
    );
    heartPath.cubicTo(
      size.width * 0.9, size.height * 0.1, 
      size.width * 0.9, size.height * 0.6, 
      size.width * 0.75, size.height * 0.8 // Stop before closing
    );

    // The EKG/Pulse Path (The zigzag inside)
    final Path pulsePath = Path();
    pulsePath.moveTo(size.width * 0.3, size.height * 0.6); // Start inside
    pulsePath.lineTo(size.width * 0.4, size.height * 0.4); // Up
    pulsePath.lineTo(size.width * 0.5, size.height * 0.7); // Down
    pulsePath.lineTo(size.width * 0.6, size.height * 0.55); // Up small
    pulsePath.lineTo(size.width * 0.75, size.height * 0.8); // Connect to heart

    // 3. Logic to Animate the "Drawing"
    // We split the progress: First 60% draws the heart, remaining 40% draws the pulse.

    // --- Draw Pink Heart (0% to 60%) ---
    double heartProgress = (progress / 0.6).clamp(0.0, 1.0);
    _drawAnimatedPath(canvas, heartPath, pinkPaint, heartProgress);

    // --- Draw Teal Pulse (60% to 100%) ---
    if (progress > 0.6) {
      double pulseProgress = ((progress - 0.6) / 0.4).clamp(0.0, 1.0);
      _drawAnimatedPath(canvas, pulsePath, tealPaint, pulseProgress);
    }
  }

  // Helper function to draw only a portion of the path
  void _drawAnimatedPath(Canvas canvas, Path path, Paint paint, double percent) {
    if (percent == 0) return;
    
    // Calculate the metrics of the path
    for (final PathMetric metric in path.computeMetrics()) {
      // Extract the path from 0.0 length to (totalLength * percent)
      final Path extractPath = metric.extractPath(0.0, metric.length * percent);
      canvas.drawPath(extractPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant HeartbeatPathPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}