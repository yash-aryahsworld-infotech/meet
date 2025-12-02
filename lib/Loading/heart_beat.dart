import 'package:flutter/material.dart';

class RealisticHeartbeat extends StatefulWidget {
  // FIXED: Added semicolon at the end
  const RealisticHeartbeat({super.key}); 

  @override
  State<RealisticHeartbeat> createState() => _RealisticHeartbeatState();
}

class _RealisticHeartbeatState extends State<RealisticHeartbeat>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // This sequence simulates: Pump -> Shrink -> Big Pump -> Back to Normal -> Pause
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 15), // lub
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 15),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 20), // DUB
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 20),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 30), // pause
    ]).animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        // OPTIMIZATION: Pass the static Icon here as 'child'
        // so it doesn't get rebuilt 60 times a second.
        child: const Icon(
          Icons.favorite,
          color: Colors.red,
          size: 60,
        ),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child, // Reuse the icon instance
          );
        },
      ),
    );
  }
}