import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_constants.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_context.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/instructions/abstract_instruction.dart';

/// **********************************************
/// SCROLL_PRESET
///***********************************************/
class CDGScrollPresetInstruction implements CDGInstruction {
  CDGScrollPresetInstruction(Uint8List bytes)
      : color = bytes[kCdgData] & 0x0F,
        hCmd = ((bytes[kCdgData + 1] & 0x3F) & 0x30) >> 4,
        hOffset = ((bytes[kCdgData + 1] & 0x3F) & 0x07),
        vCmd = ((bytes[kCdgData + 2] & 0x3F) & 0x30) >> 4,
        vOffset = ((bytes[kCdgData + 2] & 0x3F) & 0x07);

  int color;
  int hCmd;
  int hOffset;
  int vOffset;
  int vCmd;

  @override
  CDGContext execute(CDGContext ctx) {
    ctx.hOffset = min(hOffset, 5);
    ctx.vOffset = min(vOffset, 11);

    int hMove = 0;
    if (hCmd == kCdgScrollRight) {
      hMove = CDGContext.kTileWidth;
    } else if (hCmd == kCdgScrollLeft) {
      hMove = -CDGContext.kTileWidth;
    }

    int vMove = 0;
    if (vCmd == kCdgScrollDown) {
      vMove = CDGContext.kTileHeight;
    } else if (vCmd == kCdgScrollUp) {
      vMove = -CDGContext.kTileHeight;
    }

    if (hMove == 0 && vMove == 0) {
      return ctx;
    }

    int offX, offY;
    for (var x = 0; x < CDGContext.kWidth; x++) {
      for (var y = 0; y < CDGContext.kHeight; y++) {
        offX = x + hMove;
        offY = y + vMove;
        ctx.buffer[x + y * CDGContext.kWidth] = getPixel(ctx, offX, offY);
      }
    }

    final tmp = ctx.pixels;
    ctx.pixels = ctx.buffer;
    ctx.buffer = tmp;
    return ctx;
  }

  int getPixel(CDGContext ctx, int offX, int offY) {
    if (offX > 0 && offX < CDGContext.kWidth && offY > 0 && offY < CDGContext.kHeight) {
      return ctx.pixels[offX + offY * CDGContext.kWidth];
    } else {
      return color;
    }
  }
}
