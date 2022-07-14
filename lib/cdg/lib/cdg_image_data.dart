
import 'dart:typed_data';

import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_context.dart';

class CdgImageData {
  CdgImageData(this.width, this.height);

  final int width;
  final int height;

  Uint8ClampedList data = Uint8ClampedList(CDGContext.kWidth * CDGContext.kHeight * 4);
}

class CdgRenderedImageData {
  CdgRenderedImageData(this.width, this.height, this.data);

  final int width;
  final int height;

  final Uint8List data;
}
