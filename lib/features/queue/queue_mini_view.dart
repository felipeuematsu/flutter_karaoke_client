import 'dart:collection';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_cdg_karaoke_player/model/song_queue_item.dart';
import 'package:flutter_cdg_karaoke_player/service/queue_controller.dart';

class QueueMiniView extends StatelessWidget {
  const QueueMiniView({Key? key, required this.queueController}) : super(key: key);

  final QueueController queueController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Acrylic(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: StreamBuilder<Queue<SongQueueItem>>(
            stream: queueController.queueStream,
            builder: (context, snapshot) {
              final queue = snapshot.data;
              if (queue == null) {
                return const Center(child: ProgressRing());
              }

              if (queue.isEmpty) {
                return ListView(
                  padding: const EdgeInsets.all(8.0),
                  children: [
                    Acrylic(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      tint: FluentTheme.of(context).disabledColor,
                      child: const ListTile(title: Text('No songs in queue'), leading: Icon(FluentIcons.field_empty)),
                    )
                  ],
                );
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
        ),
      ),
    );
  }
}
