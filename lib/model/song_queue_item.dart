import 'package:flutter_cdg_karaoke_player/model/singer_model.dart';
import 'package:flutter_cdg_karaoke_player/model/song_model.dart';

class SongQueueItem {
  SongQueueItem(
    this.song,
    this.singer,
  );

  final SongModel song;
  final SingerModel singer;
}
