import 'dart:async';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_image_data.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_render.dart';

CdgRender _decodeRender(encoded) {
  final args = encoded;
  final cdgImageData = CdgRenderedImageData(args['width'], args['height'], args['data']);
  return CdgRender.rendered(imageData: cdgImageData, isChanged: true);
}

class KaraokeVideoPlayerController {
  KaraokeVideoPlayerController(int windowId) {
    DesktopMultiWindow.setMethodHandler((call, fromWindowId) async {
      switch (call.method) {
        case 'render':
          renderStream.sink.add(_decodeRender(call.arguments));
          return Future.value('Ok');
        default:
          return Future.value('Method not implemented');
      }
    });
  }

  final renderStream = StreamController<CdgRender>.broadcast();
}
