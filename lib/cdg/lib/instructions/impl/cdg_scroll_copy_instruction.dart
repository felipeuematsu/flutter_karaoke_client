import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_context.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/instructions/impl/cdg_scroll_preset_instruction.dart';

/// **********************************************
/// SCROLL_COPY
///***********************************************/
class CDGScrollCopyInstruction extends CDGScrollPresetInstruction {
  CDGScrollCopyInstruction(super.bytes);

  @override
  int getPixel(CDGContext ctx, int offX, int offY) {
    offX = (offX + CDGContext.kWidth) % CDGContext.kWidth;
    offY = (offY + CDGContext.kHeight) % CDGContext.kHeight;
    return ctx.pixels[offX + offY * CDGContext.kWidth];
  }
}
