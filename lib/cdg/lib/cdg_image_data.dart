
import 'dart:typed_data';

import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_context.dart';

class CDGImageData {
  CDGImageData(this.width, this.height);

  final int width;
  final int height;

  final Uint8ClampedList data = Uint8ClampedList(CDGContext.kWidth * CDGContext.kHeight * 4);
}
