class SongModel {
  SongModel(this.songId, this.duration, this.title, this.author, this.path, [this.lastPlayed]);

  final int songId, duration;
  final String title, author, path;
  final DateTime? lastPlayed;
}
