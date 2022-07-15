import 'dart:async';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_image_data.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_render.dart';
import 'package:flutter_cdg_karaoke_player/service/karaoke_video_player_controller.dart';

CdgRender _decodeRender(encoded) {
  final args = encoded;
  final cdgImageData = CdgRenderedImageData(args['width'], args['height'], args['data']);
  return CdgRender.rendered(imageData: cdgImageData, isChanged: true);
}

class KaraokeVideoPlayerControllerImpl extends KaraokeVideoPlayerController {
  KaraokeVideoPlayerControllerImpl() {
    DesktopMultiWindow.setMethodHandler(_handler);
  }

  Future<dynamic> Function(MethodCall call, int fromWindowId)? get _handler => (call, fromWindowId) async {
        playerId ??= fromWindowId;
        switch (call.method) {
          case 'render':
            renderStream.sink.add(_decodeRender(call.arguments));
            return Future.value('Ok');
          default:
            return Future.value('Method not implemented');
        }
      };

  int? playerId;

  @override
  Future<void> stop() async {
    final id = playerId;
    if (id != null) {
      await DesktopMultiWindow.invokeMethod(id, 'stop');
    }
  }

  @override
  Future<void> play() async {
    final id = playerId;
    if (id != null) {
      isPlayingStream.sink.add(await DesktopMultiWindow.invokeMethod(id, 'play'));
    }
  }
}
