import 'dart:async';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_player.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_render.dart';
import 'package:just_audio/just_audio.dart';

Map<String, dynamic> _encodeRender(CdgRender render) {
  return {
    'width': render.imageData.width,
    'height': render.imageData.height,
    'data': render.imageData.data,
  };
}

class KaraokePlayerController {
  KaraokePlayerController._() {
    isOpen = true;
    loadZip('assets/cdg/test.zip').then((_) => isLoaded = true);
    timer;
  }

  factory KaraokePlayerController() => _instance;
  static final KaraokePlayerController _instance = KaraokePlayerController._();

  late final timer = Timer.periodic(const Duration(milliseconds: 16), (_) {
    try {
      final CdgRender render = _cdgPlayer.render(_audioPlayer.position.inMilliseconds);
      if (render.isChanged) {
        renderStream.sink.add(render);
        try {
          final playerId = playerWindowId;
          if (playerId != null) {
            final encodedRender = _encodeRender(render);
            DesktopMultiWindow.invokeMethod(playerId, 'render', encodedRender);
            // compute(_encodeRender, render).then((value) => DesktopMultiWindow.invokeMethod(id, 'render', value));
          }
        } catch (_) {}
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  });

  Stream<bool> get isPlayingStream => _audioPlayer.playingStream;

  bool isOpen = false;
  bool isLoaded = false;

  int? playerWindowId;

  final CDGPlayer _cdgPlayer = CDGPlayer();
  final AudioPlayer _audioPlayer = AudioPlayer();

  final renderStream = StreamController<CdgRender>.broadcast();

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

  void close() {
    _audioPlayer.stop();
    renderStream.close();
  }

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
