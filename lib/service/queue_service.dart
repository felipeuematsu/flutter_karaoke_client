import 'dart:collection';

import 'package:flutter_cdg_karaoke_player/model/song_queue_item.dart';

abstract class QueueService {
  Future<Queue<SongQueueItem>> getQueue();

  Future<Queue<SongQueueItem>> add(SongQueueItem item);

  Future<Queue<SongQueueItem>> remove(SongQueueItem item);

  Future<Queue<SongQueueItem>> clear();

  Future<Queue<SongQueueItem>> skip();
}
