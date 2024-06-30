import 'package:flutter/material.dart';
import 'package:hover_overlay_popup/hover_overlay_popup.dart';

class CustomOverLayPainter extends CustomPainter {
  final double spikeWidth;
  final double spikeDepth;
  final Direction dir;
  final Color? color;
  final double radius;

  CustomOverLayPainter(this.spikeWidth, this.spikeDepth, this.color, {this.dir = Direction.top, this.radius = 2});
  @override
  void paint(Canvas canvas, Size size) {
    final spikeBox = Path();
    spikeBox.addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), Radius.circular(radius)));

    final spikePaint = Paint()..color = color ?? Colors.white;

    if (dir == Direction.top) {
      spikeBox
        ..moveTo((size.width / 2) + spikeWidth, size.height - 10)
        ..lineTo(size.width / 2, size.height + spikeDepth)
        ..lineTo((size.width / 2) - spikeWidth, size.height - 10);
    } else if (dir == Direction.right) {
      spikeBox
        ..moveTo(10, (size.height / 2) + spikeWidth)
        ..lineTo(-spikeDepth, size.height / 2)
        ..lineTo(10, (size.height / 2) - spikeWidth);
    } else if (dir == Direction.left) {
      spikeBox
        ..moveTo(size.width, (size.height / 2) + spikeWidth)
        ..lineTo(size.width + spikeDepth, size.height / 2)
        ..lineTo(size.width, (size.height / 2) - spikeWidth);
    } else {
      spikeBox
        ..moveTo((size.width / 2) + spikeWidth, 0)
        ..lineTo(size.width / 2, -spikeDepth)
        ..lineTo((size.width / 2) - spikeWidth, 0);
    }
    canvas.drawShadow(spikeBox, Colors.grey, 3, false);
    canvas.drawPath(spikeBox, spikePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
