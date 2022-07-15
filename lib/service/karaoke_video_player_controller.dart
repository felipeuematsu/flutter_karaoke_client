import 'dart:async';

import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_render.dart';

abstract class KaraokeVideoPlayerController {
  final isPlayingStream = StreamController<bool>();
  final renderStream = StreamController<CdgRender>.broadcast();

  Future<void> stop();

  Future<void> play();
}
