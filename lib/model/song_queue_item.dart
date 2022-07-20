import 'package:flutter_cdg_karaoke_player/model/singer_model.dart';
import 'package:flutter_cdg_karaoke_player/model/song_model.dart';

class SongQueueItem {
  SongQueueItem(this.song, this.singer);

  factory SongQueueItem.fromMap(Map<String, dynamic> map) {
    return SongQueueItem(
      SongModel.fromMap(map['song']),
      SingerModel.fromMap(map['singer']),
    );
  }

  final SongModel song;
  final SingerModel singer;

  Map<String, dynamic> toMap() {
    return {
      'song': song,
      'singer': singer,
    };
  }
}
