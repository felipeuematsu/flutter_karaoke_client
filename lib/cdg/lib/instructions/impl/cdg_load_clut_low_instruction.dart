import 'dart:typed_data';

import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_constants.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_context.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/instructions/abstract_instruction.dart';

/// **********************************************
/// LOAD_CLUT_LOW
///***********************************************/
class CDGLoadCLUTLowInstruction implements CDGInstruction {
  CDGLoadCLUTLowInstruction(Uint8List bytes) {
    for (var i = 0; i < 8; i++) {
      final cur = kCdgData + 2 * i;

      var color = (bytes[cur] & 0x3F) << 6;
      color += bytes[cur + 1] & 0x3F;

      colors[i] = [color >> 8, (color & 0xF0) >> 4, color & 0xF];
    }
  }

  List<List<int>> colors = List<List<int>>.generate(8, (_) => List.generate(3, (_) => 0, growable: false), growable: false);

  @override
  CDGContext execute(CDGContext ctx) {
    for (var i = 0; i < 8; i++) {
      ctx.setCLUTEntry(
        i + clutOffset,
        colors[i][0],
        colors[i][1],
        colors[i][2],
      );
    }
    return ctx;
  }

  int get clutOffset => 0;
}
