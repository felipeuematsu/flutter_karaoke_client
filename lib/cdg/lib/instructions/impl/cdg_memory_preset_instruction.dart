import 'dart:typed_data';

import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_constants.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_context.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/instructions/abstract_instruction.dart';

/// **********************************************
/// MEMORY_PRESET
///***********************************************/
class CDGMemoryPresetInstruction implements CDGInstruction {
  CDGMemoryPresetInstruction(Uint8List bytes)
      : color = bytes[kCdgData] & 0x0F,
        repeat = bytes[kCdgData + 1] & 0x0F;

  int color;
  int repeat;

  @override
  CDGContext execute(CDGContext ctx) => ctx
    ..pixels.fillRange(0, ctx.pixels.length, color)
    ..bgColor = color;
}
