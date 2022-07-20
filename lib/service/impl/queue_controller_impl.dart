import 'dart:async';
import 'dart:collection';

import 'package:flutter_cdg_karaoke_player/model/song_queue_item.dart';
import 'package:flutter_cdg_karaoke_player/service/queue_controller.dart';
import 'package:flutter_cdg_karaoke_player/service/queue_service.dart';

class QueueControllerImpl implements QueueController {
  QueueControllerImpl(this.queueService) {
    _timer;
  }

  late final _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    queueService.getQueue().then((queue) => _queueStream.sink.add(queue));
  });

  final _queueStream = StreamController<Queue<SongQueueItem>>.broadcast();

  final QueueService queueService;

  @override
  void add(SongQueueItem item) {
    queueService.add(item).then((queue) => _queueStream.add(queue));
  }

  @override
  void clear() {
    queueService.clear().then((queue) => _queueStream.add(queue));
  }

  @override
  void remove(SongQueueItem item) {
    queueService.remove(item).then((queue) => _queueStream.add(queue));
  }

  @override
  void skip() {
    queueService.skip().then((queue) => _queueStream.add(queue));
  }

  @override
  Stream<Queue<SongQueueItem>> get queueStream => _queueStream.stream;
}
