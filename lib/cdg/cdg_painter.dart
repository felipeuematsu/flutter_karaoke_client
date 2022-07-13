import 'dart:ui';

import 'package:flutter/material.dart' hide Image;

class CdgPainter extends CustomPainter {
  CdgPainter({Key? key, required this.imageData, required this.backgroundRgba});

  Image imageData;
  List<int> backgroundRgba;

  Color backgroundColor(List<int> backgroundRgba) {
    return Color.fromARGB(
      backgroundRgba[3],
      backgroundRgba[0],
      backgroundRgba[1],
      backgroundRgba[2],
    );
  }

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
