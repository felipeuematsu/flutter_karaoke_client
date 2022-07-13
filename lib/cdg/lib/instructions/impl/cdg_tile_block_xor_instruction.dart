import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_context.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/instructions/impl/cdg_tile_block_instruction.dart';

/// **********************************************
/// TILE_BLOCK_XOR
///***********************************************/
class CDGTileBlockXORInstruction extends CDGTileBlockInstruction {
  CDGTileBlockXORInstruction(super.bytes);

  @override
  CDGContext op(CDGContext ctx, int offset, int color) => ctx..pixels[offset] = ctx.pixels[offset] ^ color;
}
