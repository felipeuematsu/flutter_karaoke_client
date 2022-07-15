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

  Future<void> _invokeMethod(String method, [dynamic args]) async {
    final id = playerId;
    if (id != null) {
      await DesktopMultiWindow.invokeMethod(id, method, args);
    }
  }

  Future<dynamic> Function(MethodCall call, int fromWindowId)? get _handler => (call, fromWindowId) async {
        playerId ??= fromWindowId;
        switch (call.method) {
          case 'render':
            return renderStream.sink.add(_decodeRender(call.arguments));
          case 'play':
            return isPlayingStream.sink.add(call.arguments as bool);
          default:
            return Future.value('Method not implemented');
        }
      };

  int? playerId;

  @override
  Future<void> stop() async => await _invokeMethod('stop');

  @override
  Future<void> play() async => await _invokeMethod('play');

  @override
  Future<void> pause() async => await _invokeMethod('pause');

  @override
  Future<void> addToQueue(int songId, int singerId) async => await _invokeMethod('addToQueue', {'songId': songId, 'singerId': singerId});

  @override
  Future<void> skip() async => await _invokeMethod('skip');
}
