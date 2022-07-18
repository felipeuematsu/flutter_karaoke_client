import 'dart:collection';

import 'package:flutter_cdg_karaoke_player/model/song_queue_item.dart';
import 'package:flutter_cdg_karaoke_player/service/queue_service.dart';

class QueueServiceImpl extends QueueService {
  Future<Queue<SongQueueItem>> getQueue();

  Future<Queue<SongQueueItem>> add(SongQueueItem item);

  Future<Queue<SongQueueItem>> remove(SongQueueItem item);

  Future<Queue<SongQueueItem>> clear();

  Future<Queue<SongQueueItem>> skip();
}
