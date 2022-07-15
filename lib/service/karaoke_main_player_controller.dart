import 'dart:async';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_player.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_render.dart';
import 'package:just_audio/just_audio.dart';

abstract class KaraokeMainPlayerController {
  abstract final Timer timer;

  Stream<bool> get isPlayingStream;

  final renderStream = StreamController<CdgRender>.broadcast();

  Future<void> loadZip(String zipPath);

  Future<void> playOnPressed();

  void close();

  void stop();
}

// Feed your own stream of bytes into the player
class MyCustomSource extends StreamAudioSource {
  MyCustomSource(this.bytes);

  final List<int> bytes;

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= bytes.length;
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes.sublist(start, end)),
      contentType: 'audio/mpeg',
    );
  }
}
