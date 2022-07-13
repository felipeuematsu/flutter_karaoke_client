import 'dart:typed_data';

import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_context.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_parser.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_render.dart';

/// **********************************************
/// CDGPlayer
///***********************************************/
class CDGPlayer {
  CDGContext ctx = CDGContext();
  CDGParser? parser;
  bool? forceKey;

  void load(ByteBuffer? buffer) {
    if (buffer == null) throw Exception('load() expects an ArrayBuffer');

    forceKey = null;
    parser = CDGParser(buffer);
  }

  CdgRender render(int time, [bool forceKey = false]) {
    final parser = this.parser;
    if (parser == null) throw Exception('load() must be called before render()');
    if (time < 0) throw Exception('Invalid time: $time');

    final instructions = parser.parseThrough(time / 1000);
    final isChanged = instructions.instructions.isNotEmpty || instructions.isRestarting || forceKey != this.forceKey;
    this.forceKey = forceKey;

    if (instructions.isRestarting) {
      ctx = CDGContext();
    }

    for (final i in instructions.instructions) {
      ctx = i.execute(ctx);
    }

    if (isChanged) {
      ctx.renderFrame(forceKey);
    }

    return CdgRender(
      imageData: ctx.imageData,
      isChanged: isChanged,
      backgroundRgba: ctx.backgroundRGBA,
      contentBounds: ctx.contentBounds,
    );
  }
}
