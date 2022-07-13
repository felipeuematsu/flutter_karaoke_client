
import 'dart:typed_data';

import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_constants.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_context.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/instructions/abstract_instruction.dart';

/// **********************************************
/// BORDER_PRESET
///***********************************************/
class CDGBorderPresetInstruction implements CDGInstruction {
  CDGBorderPresetInstruction(Uint8List bytes) : color = bytes[kCdgData] & 0x0F;

  int color;

  @override
  CDGContext execute(CDGContext ctx) {
    const b = CDGContext.kDisplayBounds;
    for (var x = 0; x < CDGContext.kWidth; x++) {
      for (var y = 0; y < b[1]; y++) {
        ctx.pixels[x + y * CDGContext.kWidth] = color;
      }
      for (var y = b[3] + 1; y < CDGContext.kHeight; y++) {
        ctx.pixels[x + y * CDGContext.kWidth] = color;
      }
    }
    for (var y = b[1]; y <= b[3]; y++) {
      for (var x = 0; x < b[0]; x++) {
        ctx.pixels[x + y * CDGContext.kWidth] = color;
      }
      for (var x = b[2] + 1; x < CDGContext.kWidth; x++) {
        ctx.pixels[x + y * CDGContext.kWidth] = color;
      }
    }
    return ctx;
  }
}
