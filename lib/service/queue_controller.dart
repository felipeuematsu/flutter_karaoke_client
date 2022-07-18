import 'dart:collection';

import 'package:flutter_cdg_karaoke_player/model/song_queue_item.dart';

abstract class QueueController {
  Stream<Queue<SongQueueItem>> get queueStream;

  void add(SongQueueItem item);

  void remove(SongQueueItem item);

  void clear();

  void skip();
}
