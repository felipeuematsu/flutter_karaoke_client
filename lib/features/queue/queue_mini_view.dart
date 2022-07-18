import 'dart:collection';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_cdg_karaoke_player/model/song_queue_item.dart';
import 'package:flutter_cdg_karaoke_player/service/queue_controller.dart';

class QueueMiniView extends StatelessWidget {
  const QueueMiniView({Key? key, required this.queueController}) : super(key: key);

  final QueueController queueController;

  @override
  Widget build(BuildContext context) {
    return Acrylic(
      child: StreamBuilder<Queue<SongQueueItem>>(
        stream: queueController.queueStream,
        builder: (context, snapshot) {
          final queue = snapshot.data;
          if (queue == null) {
            return const Center(child: ProgressRing());
          }

          if (queue.isEmpty) {
            return ListView(children: const [ListTile(title: Text('No songs in queue'), leading: Icon(FluentIcons.field_empty))]);
          }

          return ListView.builder(
            itemCount: queue.length,
            itemBuilder: (context, index) => ListTile(
                title: Text(queue.elementAt(index).song.title),
                leading: Text(index.toString()),
                subtitle: Text(queue.elementAt(index).singer.name),
              ),
          );
        },
      ),
    );
  }
}
