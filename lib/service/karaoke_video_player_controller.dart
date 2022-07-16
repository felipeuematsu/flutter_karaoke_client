import 'dart:async';

import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_render.dart';

abstract class KaraokeVideoPlayerController {
  final isPlayingStream = StreamController<bool>.broadcast();
  final renderStream = StreamController<CdgRender>.broadcast();

  Future<void> stop();

  Future<void> play();

  Future<void> pause();

  Future<void> addToQueue(int songId, int singerId);

  Future<void> skip();

  Future<void> restart();
}
