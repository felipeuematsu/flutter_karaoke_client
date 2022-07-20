import 'dart:collection';

import 'package:flutter_cdg_karaoke_player/model/song_queue_item.dart';
import 'package:flutter_cdg_karaoke_player/service/client/karaoke_client.dart';
import 'package:flutter_cdg_karaoke_player/service/queue_service.dart';

class QueueServiceImpl extends QueueService {
  QueueServiceImpl(this.client);

  final KaraokeClient client;

  @override
  Future<Queue<SongQueueItem>> getQueue() async {
    // final response = await client.get('/queue');
    // final queue = response.data as List<dynamic>;
    // return Queue.from(queue.map((item) => SongQueueItem.fromMap(item)));
    return Future.value(Queue<SongQueueItem>.of([]));
  }

  @override
  Future<Queue<SongQueueItem>> add(SongQueueItem item) async {
    final response = await client.post('/queue', data: item.toMap());
    final queue = response.data as List<dynamic>;
    return Queue.from(queue.map((item) => SongQueueItem.fromMap(item)));
  }

  @override
  Future<Queue<SongQueueItem>> remove(SongQueueItem item) async {
    final response = await client.delete('/queue/${item.song.songId}');
    final queue = response.data as List<dynamic>;
    return Queue.from(queue.map((item) => SongQueueItem.fromMap(item)));
  }

  @override
  Future<Queue<SongQueueItem>> clear() async {
    final response = await client.delete('/queue');
    final queue = response.data as List<dynamic>;
    return Queue.from(queue.map((item) => SongQueueItem.fromMap(item)));
  }

  @override
  Future<Queue<SongQueueItem>> skip() async {
    final response = await client.delete('/queue/skip');
    final queue = response.data as List<dynamic>;
    return Queue.from(queue.map((item) => SongQueueItem.fromMap(item)));
  }
}
