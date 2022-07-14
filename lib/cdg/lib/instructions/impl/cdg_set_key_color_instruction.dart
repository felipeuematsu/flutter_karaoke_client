import 'dart:typed_data';

import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_constants.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_context.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/instructions/abstract_instruction.dart';

/// **********************************************
/// SET_KEY_COLOR
///***********************************************/
class CDGSetKeyColorInstruction implements CDGInstruction {
  CDGSetKeyColorInstruction(Uint8List bytes) : index = bytes[kCdgData] & 0x0F;

  int index;

  @override
  CDGContext execute(CDGContext ctx) => ctx..keyColor = index;
}
