import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_constants.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_context.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/instructions/abstract_instruction.dart';

/// **********************************************
/// TILE_BLOCK
///***********************************************/
class CDGTileBlockInstruction implements CDGInstruction {
  CDGTileBlockInstruction(Uint8List bytes)
      : colors = [bytes[kCdgData] & 0x0F, bytes[kCdgData + 1] & 0x0F],
        row = bytes[kCdgData + 2] & 0x1F,
        column = bytes[kCdgData + 3] & 0x3F,
        pixels = bytes.sublist(kCdgData + 4, kCdgData + 16);
  List<int> colors;
  int row;
  int column;
  List<int> pixels;

  @override
  CDGContext execute(CDGContext ctx) {
    /* blit a tile */
    final x = column * CDGContext.kTileWidth;
    final y = row * CDGContext.kTileHeight;

    if (x + 6 > CDGContext.kWidth || y + 12 > CDGContext.kHeight) {
      if (kDebugMode) {
        print('TileBlock out of bounds ($row, $column)');
      }
      return ctx;
    }

    for (var i = 0; i < 12; i++) {
      final curByte = pixels[i];
      for (var j = 0; j < 6; j++) {
        final color = colors[((curByte >> (5 - j)) & 0x1)];
        final offset = x + j + (y + i) * CDGContext.kWidth;
        ctx = op(ctx, offset, color);
      }
    }
    return ctx;
  }

  CDGContext op(CDGContext ctx, int offset, int color) => ctx..pixels[offset] = color;
}
