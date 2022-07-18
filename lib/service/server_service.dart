import 'dart:collection';

import 'package:flutter_cdg_karaoke_player/model/song_queue_item.dart';

abstract class ServerService {
  Future<Queue<SongQueueItem>> fetchQueueFromServer(Queue<SongQueueItem> queue);
  Future<void> addSongToQueue(SongQueueItem item);
  Future<void> removeSongFromQueue(SongQueueItem item);
  Future<void> clearQueue();

}
