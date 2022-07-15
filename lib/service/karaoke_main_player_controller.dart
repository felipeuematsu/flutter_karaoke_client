import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_player.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_render.dart';
import 'package:flutter_cdg_karaoke_player/model/song_queue_item.dart';
import 'package:just_audio/just_audio.dart';

abstract class KaraokeMainPlayerController {
  abstract final Timer timer;

  final renderStream = StreamController<CdgRender>.broadcast();

  Queue<SongQueueItem> queue = Queue<SongQueueItem>();

  Future<void> loadZip(String zipPath);

  void play();

  void pause();

  void stop();

  void close();

  void addToQueue(int songId, int singerId);
}
