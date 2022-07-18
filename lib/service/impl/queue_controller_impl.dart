import 'dart:async';
import 'dart:collection';

import 'package:flutter_cdg_karaoke_player/model/song_queue_item.dart';
import 'package:flutter_cdg_karaoke_player/service/queue_controller.dart';
import 'package:flutter_cdg_karaoke_player/service/queue_service.dart';

class QueueControllerImpl implements QueueController {
  QueueControllerImpl(this.queueService);

  final _queueStream = StreamController<Queue<SongQueueItem>>.broadcast();

  final QueueService queueService;

  @override
  void add(SongQueueItem item) {
    // TODO: implement add
  }

  @override
  void clear() {
    // TODO: implement clear
  }

  @override
  void remove(SongQueueItem item) {
    // TODO: implement remove
  }

  @override
  void skip() {
    // TODO: implement skip
  }

  @override
  // TODO: implement queueStream
  Stream<Queue<SongQueueItem>> get queueStream => _queueStream.stream;
}
