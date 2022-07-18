import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter_cdg_karaoke_player/model/song_queue_item.dart';
import 'package:flutter_cdg_karaoke_player/service/server_service.dart';

class ServerServiceImpl extends ServerService {
  final _client = Dio();

  @override
  Future<void> addSongToQueue(SongQueueItem item) {
    // TODO: implement addSongToQueue
    throw UnimplementedError();
  }

  @override
  Future<void> clearQueue() {
    // TODO: implement clearQueue
    throw UnimplementedError();
  }

  @override
  Future<Queue<SongQueueItem>> fetchQueueFromServer(Queue<SongQueueItem> queue) {
    // TODO: implement fetchQueueFromServer
    throw UnimplementedError();
  }

  @override
  Future<void> removeSongFromQueue(SongQueueItem item) {
    // TODO: implement removeSongFromQueue
    throw UnimplementedError();
  }
// final _serverft = Dio
}
