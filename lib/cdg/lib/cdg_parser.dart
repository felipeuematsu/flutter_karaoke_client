import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_constants.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/instructions/abstract_instruction.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/instructions/cdg_instruction_list.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/instructions/impl/cdg_border_preset_instruction.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/instructions/impl/cdg_load_clut_high_instruction.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/instructions/impl/cdg_load_clut_low_instruction.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/instructions/impl/cdg_memory_preset_instruction.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/instructions/impl/cdg_scroll_copy_instruction.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/instructions/impl/cdg_scroll_preset_instruction.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/instructions/impl/cdg_set_key_color_instruction.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/instructions/impl/cdg_tile_block_instruction.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/instructions/impl/cdg_tile_block_xor_instruction.dart';

/// **********************************************
/// CDGParser
///***********************************************/
class CDGParser {
  CDGParser(ByteBuffer buffer)
      : bytes = buffer.asUint8List(),
        numPackets = buffer.lengthInBytes / kPacketSize,
        pc = -1;
  static const kCommandMask = 0x3F;
  static const kCdgCommand = 0x9;
  static const kByType = <int, Type>{
    kCdgMemoryPreset: CDGMemoryPresetInstruction,
    kCdgBorderPreset: CDGBorderPresetInstruction,
    kCdgTileBlock: CDGTileBlockInstruction,
    kCdgScrollPreset: CDGScrollPresetInstruction,
    kCdgScrollCopy: CDGScrollCopyInstruction,
    kCdgSetKeyColor: CDGSetKeyColorInstruction,
    kCdgLoadClutLow: CDGLoadCLUTLowInstruction,
    kCdgLoadClutHi: CDGLoadCLUTHighInstruction,
    kCdgTileBlockXor: CDGTileBlockXORInstruction
  };

  Uint8List bytes;
  int pc;
  double numPackets;

  CDGInstructionList parseThrough(double sec) {
    // determine packet we should be at, based on spec
    // of 4 packets per sector @ 75 sectors per second
    final newPc = (4 * 75 * sec).floor();
    final instructions = CDGInstructionList();

    if (pc > newPc) {
      // rewind kindly
      pc = -1;
      instructions.isRestarting = true;
    }

    while (pc < newPc && pc < numPackets) {
      pc++;
      final offset = pc * kPacketSize;
      final cmd = parse(bytes.sublist(offset, offset + kPacketSize));

      if (cmd != null) instructions.instructions.add(cmd);
    }

    return instructions;
  }

  CDGInstruction? _create(Type type, Uint8List packet) {
    switch (type) {
      case CDGMemoryPresetInstruction:
        return CDGMemoryPresetInstruction(packet);
      case CDGBorderPresetInstruction:
        return CDGBorderPresetInstruction(packet);
      case CDGTileBlockInstruction:
        return CDGTileBlockInstruction(packet);
      case CDGScrollPresetInstruction:
        return CDGScrollPresetInstruction(packet);
      case CDGScrollCopyInstruction:
        return CDGScrollCopyInstruction(packet);
      case CDGSetKeyColorInstruction:
        return CDGSetKeyColorInstruction(packet);
      case CDGLoadCLUTLowInstruction:
        return CDGLoadCLUTLowInstruction(packet);
      case CDGLoadCLUTHighInstruction:
        return CDGLoadCLUTHighInstruction(packet);
      case CDGTileBlockXORInstruction:
        return CDGTileBlockXORInstruction(packet);
    }

    return null;
  }

  CDGInstruction? parse(Uint8List packet) {
    if ((packet[0] & kCommandMask) == kCdgCommand) {
      final opcode = packet[1] & kCommandMask;
      final type = kByType[opcode];

      if (type != null) {
        return _create(type, packet);
      } else {
        if (kDebugMode) {
          print('Unknown CDG instruction (instruction = $opcode)');
        }
        return null;
      }
    }

    return null;
  }
}
