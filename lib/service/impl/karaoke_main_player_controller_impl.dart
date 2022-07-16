import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_player.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_render.dart';
import 'package:flutter_cdg_karaoke_player/model/singer_model.dart';
import 'package:flutter_cdg_karaoke_player/model/song_model.dart';
import 'package:flutter_cdg_karaoke_player/model/song_queue_item.dart';
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
    _audioPlayer.playingStream.listen(_playingCallback);
  }

  Future<void> _invokeMethod(String method, [dynamic args]) async {
    final id = playerWindowId;
    if (id != null) {
      await DesktopMultiWindow.invokeMethod(id, method, args);
    }
  }

  void Function(dynamic playing) get _playingCallback => (playing) {
        final id = playerWindowId;
        if (id != null) {
          DesktopMultiWindow.invokeMethod(id, 'playing', playing);
        }
      };

  Future<dynamic> Function(MethodCall call, int fromWindowId) get _handler => (call, fromWindowId) async {
        switch (call.method) {
          case 'play':
            return play();
          case 'pause':
            return pause();
          case 'stop':
            return stop();
        }
      };

  @override
  late final timer = Timer.periodic(const Duration(milliseconds: 33), (_) {
    if (isLoaded) {
      try {
        final CdgRender render = _cdgPlayer.render(_audioPlayer.position.inMilliseconds);
        if (render.isChanged) {
          renderStream.sink.add(render);
          final playerId = playerWindowId;
          if (playerId != null) {
            try {
              DesktopMultiWindow.invokeMethod(playerId, 'render', _encodeRender(render));
            } catch (_) {}
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  });

  bool isLoaded = false;
  int? playerWindowId;

  final CDGPlayer _cdgPlayer = CDGPlayer();
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  Future<void> loadZip(String zipPath) async {
    final data = await rootBundle.load(zipPath);
    final archive = ZipDecoder().decodeBytes(data.buffer.asUint8List());
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
  }

  @override
  void play() {
    if (!isLoaded) return;
    _audioPlayer.play().then((_) => _invokeMethod('playing', _audioPlayer.playing));
  }

  @override
  void close() {
    _audioPlayer.stop();
    renderStream.close();
  }

  @override
  void stop() {
    _audioPlayer.stop().then((_) => _invokeMethod('playing', _audioPlayer.playing));
  }

  @override
  void pause() {
    if (!isLoaded) return;
    _audioPlayer.pause().then((_) => _invokeMethod('playing', _audioPlayer.playing));
  }

  @override
  void addToQueue(int songId, int singerId) {
    // TODO: get song and singer from server
    final song = SongModel(0, 0, '', '', '');
    final singer = SingerModel(0, '');

    queue.add(SongQueueItem(song, singer));
  }

  @override
  void restart() {
    if (!isLoaded) return;
    _audioPlayer
        .seek(const Duration(milliseconds: 0))
        .then((_) => _audioPlayer.play())
        .then((_) => _invokeMethod('playing', _audioPlayer.playing));
  }

  @override
  void skip() {
    // TODO: implement skip when queue ready
    if (!isLoaded) return;
    _audioPlayer.seek(const Duration(milliseconds: 0));
    _audioPlayer.play().then((_) => _invokeMethod('playing', _audioPlayer.playing));
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
