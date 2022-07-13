import 'dart:async';
import 'dart:isolate';

import 'package:archive/archive_io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_player.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_render.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class KaraokeService extends GetxController {
  bool get isPlaying => _audioPlayer.playing;

  late final isolate = Isolate.spawn((_) => _loopVideoRender(), null);

  bool isClosed = false;
  bool isLoaded = false;

  final CDGPlayer _cdgPlayer = CDGPlayer();
  final AudioPlayer _audioPlayer = AudioPlayer();

  final audioDurationStream = StreamController<CdgRender>.broadcast();
  final audioStateStream = StreamController<CdgRender>.broadcast();

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
    if (isPlaying) {
      _audioPlayer.pause();
    } else {
      _play();
    }
  }

  Future<void> _play() async {
    if (!isLoaded) return;
    _audioPlayer.play();
  }

  void _loopVideoRender() async {
    while (true) {
      await Future.delayed(const Duration(milliseconds: 10));
      if (isClosed) return;
      if (isPlaying) {
        final CdgRender render = _cdgPlayer.render(_audioPlayer.position.inMilliseconds);
        if (render.isChanged) {
          audioDurationStream.sink.add(render);
        }
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadZip('assets/cdg/test.zip').then((_) => isLoaded = true);
    _loopVideoRender();
  }

  @override
  void onClose() {
    _audioPlayer.stop();
    audioDurationStream.close();
    isClosed = false;
    super.onClose();
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
