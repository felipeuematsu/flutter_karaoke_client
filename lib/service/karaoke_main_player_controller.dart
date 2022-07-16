import 'dart:async';
import 'dart:collection';

import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_render.dart';
import 'package:flutter_cdg_karaoke_player/model/song_queue_item.dart';

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

  void skip();

  void restart();
}
