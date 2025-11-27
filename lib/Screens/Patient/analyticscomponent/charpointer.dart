// --- THE CUSTOM PAINTER LOGIC ---
import 'package:flutter/material.dart';
import 'package:healthcare_plus/Screens/Patient/analyticscomponent/healthmetricdata.dart';

class ChartPainter extends CustomPainter {
  final List<HealthMetricData> dataPoints;

  ChartPainter({required this.dataPoints});

  final double maxY = 140; // Max value for Y-axis scaling
  final double minY = 0;
  final int horizontalLines = 5;

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Setup Paints
    final gridPaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final bpPaint = Paint()
      ..color = const Color(0xFF3B82F6)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final hrPaint = Paint()
      ..color = const Color(0xFFEF4444)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final weightPaint = Paint()
      ..color = const Color(0xFF10B981)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
      
    final dotPaint = Paint()..style = PaintingStyle.fill;

    // Dimensions
    final double leftPadding = 30; // Space for Y-axis labels
    final double bottomPadding = 20; // Space for X-axis labels
    final double chartWidth = size.width - leftPadding;
    final double chartHeight = size.height - bottomPadding;

    // 2. Draw Grid & Y-Axis Labels
    final double yStep = chartHeight / (horizontalLines - 1);
    final double yValueStep = (maxY - minY) / (horizontalLines - 1);

    for (int i = 0; i < horizontalLines; i++) {
      double y = chartHeight - (i * yStep);
      double value = minY + (i * yValueStep);

      // Draw dashed horizontal line
      _drawDashedLine(canvas, gridPaint, Offset(leftPadding, y), Offset(size.width, y));

      // Draw Y-axis Label
      TextSpan span = TextSpan(
        style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
        text: value.toInt().toString(),
      );
      TextPainter tp = TextPainter(text: span, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }

    // 3. Draw Data Lines & X-Axis Labels
    if (dataPoints.isEmpty) return;

    final double xStep = chartWidth / (dataPoints.length - 1);
    
    Path bpPath = Path();
    Path hrPath = Path();
    Path weightPath = Path();

    for (int i = 0; i < dataPoints.length; i++) {
      double x = leftPadding + (i * xStep);
      
      // Calculate Y positions relative to max value
      double bpY = chartHeight - ((dataPoints[i].bp / maxY) * chartHeight);
      double hrY = chartHeight - ((dataPoints[i].heartRate / maxY) * chartHeight);
      double weightY = chartHeight - ((dataPoints[i].weight / maxY) * chartHeight);

      // Move to start or draw line
      if (i == 0) {
        bpPath.moveTo(x, bpY);
        hrPath.moveTo(x, hrY);
        weightPath.moveTo(x, weightY);
      } else {
        bpPath.lineTo(x, bpY);
        hrPath.lineTo(x, hrY);
        weightPath.lineTo(x, weightY);
      }

      // Draw X-Axis Label (Month)
      TextSpan span = TextSpan(
        style: TextStyle(color: Colors.grey.shade500, fontSize: 10, fontWeight: FontWeight.bold),
        text: dataPoints[i].month,
      );
      TextPainter tp = TextPainter(text: span, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(x - tp.width / 2, chartHeight + 6));
      
      // Draw Dots
      canvas.drawCircle(Offset(x, bpY), 3, dotPaint..color = const Color(0xFF3B82F6)); // Blue dot
      canvas.drawCircle(Offset(x, hrY), 3, dotPaint..color = const Color(0xFFEF4444)); // Red dot
      canvas.drawCircle(Offset(x, weightY), 3, dotPaint..color = const Color(0xFF10B981)); // Green dot
      
      // Reset color for white inner dot (optional style choice)
      canvas.drawCircle(Offset(x, bpY), 1.5, dotPaint..color = Colors.white);
      canvas.drawCircle(Offset(x, hrY), 1.5, dotPaint..color = Colors.white);
      canvas.drawCircle(Offset(x, weightY), 1.5, dotPaint..color = Colors.white);
    }

    // Paint the paths
    canvas.drawPath(bpPath, bpPaint);
    canvas.drawPath(hrPath, hrPaint);
    canvas.drawPath(weightPath, weightPaint);
  }

  void _drawDashedLine(Canvas canvas, Paint paint, Offset p1, Offset p2) {
    double dashWidth = 5;
    double dashSpace = 5;
    // double distance = p2.dx - p1.dx; // Assuming horizontal line
    double startX = p1.dx;
    
    while (startX < p2.dx) {
      canvas.drawLine(
        Offset(startX, p1.dy),
        Offset(startX + dashWidth, p1.dy),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}