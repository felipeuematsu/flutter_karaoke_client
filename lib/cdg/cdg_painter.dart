import 'dart:ui';

import 'package:flutter/material.dart' hide Image;

class CdgPainter extends CustomPainter {
  const CdgPainter({Key? key, required this.imageData});

  const CdgPainter.fromImageData({Key? key, required this.imageData});

  final Image imageData;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(
      imageData,
      Offset.zero,
      Paint(),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
