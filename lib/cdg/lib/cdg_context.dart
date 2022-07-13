import 'dart:typed_data';

import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_image_data.dart';

/// **********************************************
/// CDGContext represents a specific state of
/// the screen, clut and other CDG variables.
///***********************************************/

class CDGContext {
  static const int kWidth = 300;
  static const double kWidthDouble = 300.0;
  static const int kHeight = 216;
  static const double kHeightDouble = 216.0;
  static const int kDisplayWidth = 288;
  static const int kDisplayHeight = 192;
  static const List<int> kDisplayBounds = [6, 12, 294, 204];
  static const int kTileWidth = 6;
  static const int kTileHeight = 12;

  int hOffset = 0;
  int vOffset = 0;
  int? keyColor;
  int? bgColor;
  List<List<int>> clut = List<List<int>>.generate(16, (_) => [0, 0, 0], growable: false); // color lookup table
  Uint8List pixels = Uint8List(kWidth * kHeight);
  Uint8List buffer = Uint8List(kWidth * kHeight);
  CDGImageData imageData = CDGImageData(kWidth, kHeight);

  List<int> backgroundRGBA = List.of([0, 0, 0, 0], growable: false);
  List<int> contentBounds = List.of([0, 0, 0, 0], growable: false);

  void setCLUTEntry(int index, int r, int g, int b) {
    clut[index] = [r, g, b].map((c) => c * 17).toList();
  }

  void renderFrame([bool forceKey = false]) {
    const left = 0, top = 0, right = kWidth, bottom = kHeight;
    var x1 = kWidth, y1 = kHeight, x2 = 0, y2 = 0;
    var isContent = false;
    final bgColor = this.bgColor;

    for (var y = top; y < bottom; y++) {
      for (var x = left; x < right; x++) {
        // Respect the horizontal and vertical offsets for grabbing the pixel color
        final px = ((x - hOffset) + kWidth) % kWidth;
        final py = ((y - vOffset) + kHeight) % kHeight;
        final pixelIndex = px + (py * kWidth);
        final colorIndex = pixels[pixelIndex];
        final r = clut[colorIndex][0], g = clut[colorIndex][1], b = clut[colorIndex][2];
        final isKeyColor = colorIndex == keyColor || (forceKey && (colorIndex == bgColor || bgColor == null));

        // Set the rgba values in the image data
        final offset = 4 * (x + (y * kWidth));
        imageData.data[offset] = r;
        imageData.data[offset + 1] = g;
        imageData.data[offset + 2] = b;
        imageData.data[offset + 3] = isKeyColor ? 0x00 : 0xff;

        if (!isKeyColor) {
          isContent = true;
          if (x1 > x) x1 = x;
          if (y1 > y) y1 = y;
          if (x2 < x) x2 = x;
          if (y2 < y) y2 = y;
        }
      }
    }

    // report content bounds, with two tweaks:
    // 1) if there are no visible pixels, report [0,0,0,0] (isContent flag)
    // 2) account for size of the rightmost/bottommost pixels in 2nd coordinates (+1)
    contentBounds = isContent || !forceKey ? [x1, y1, x2 + 1, y2 + 1] : [0, 0, 0, 0];

    // report background status
    backgroundRGBA = bgColor == null ? [0, 0, 0, forceKey ? 0 : 1] : [...clut[bgColor], bgColor == keyColor || forceKey ? 0 : 1];
  }
}
