import 'dart:async';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_player.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_render.dart';
import 'package:flutter_cdg_karaoke_player/service/karaoke_main_player_controller.dart';
import 'package:just_audio/just_audio.dart';

Map<String, dynamic> _encodeRender(CdgRender render) {
  return {
    'width': render.imageData.width,
    'height': render.imageData.height,
    'data': render.imageData.data,
  };
}

class KaraokeMainPlayerControllerImpl extends KaraokeMainPlayerController {
  KaraokeMainPlayerControllerImpl() {

    DesktopMultiWindow.setMethodHandler(_handler);
    loadZip('assets/cdg/test.zip').then((_) => isLoaded = true);
    timer;
  }
  Future<dynamic> Function(MethodCall call, int fromWindowId)? get _handler => (call, fromWindowId) async {
    switch (call.method) {
      case 'play':
        playOnPressed();
        return Future.value(_audioPlayer.playing);
      case 'stop':
        stop();
        return Future.value('Ok');
    }
  };

  @override
  late final timer = Timer.periodic(const Duration(milliseconds: 33), (_) {
    if (isLoaded) {
      try {
        final CdgRender render = _cdgPlayer.render(_audioPlayer.position.inMilliseconds);
        if (render.isChanged) {
          renderStream.sink.add(render);
          try {
            final playerId = playerWindowId;
            if (playerId != null) {
              final encodedRender = _encodeRender(render);
              DesktopMultiWindow.invokeMethod(playerId, 'render', encodedRender);
            }
          } catch (_) {}
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  });

  @override
  Stream<bool> get isPlayingStream => _audioPlayer.playingStream;

  bool isLoaded = false;

  int? playerWindowId;

  final CDGPlayer _cdgPlayer = CDGPlayer();
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  Future<void> loadZip(String zipPath) async {
    await rootBundle.load(zipPath).then((ByteData data) async {
      Archive archive = ZipDecoder().decodeBytes(data.buffer.asUint8List());
      for (final file in archive.files) {
        final content = file.content as Uint8List;
        if (file.name.contains('.cdg')) {
          _cdgPlayer.load(content.buffer);
        }
        if (file.name.contains('.mp3')) {
          final myCustomSource = MyCustomSource(content);
          await _audioPlayer.setAudioSource(myCustomSource);
        }
      }
    });
  }

  @override
  Future<void> playOnPressed() async {
    if (_audioPlayer.playing) {
      _audioPlayer.pause();
    } else {
      _play();
    }
  }

  Future<void> _play() async {
    if (!isLoaded) return;
    _audioPlayer.play();
  }

  @override
  void close() {
    _audioPlayer.stop();
    renderStream.close();
  }

  @override
  void stop() {
    _audioPlayer.stop();
  }
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
