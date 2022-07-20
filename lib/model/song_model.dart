class SongModel {
  SongModel(this.songId, this.duration, this.title, this.author, this.path, [this.lastPlayed]);

  final int songId, duration;
  final String title, author, path;
  final DateTime? lastPlayed;

  Map<String, dynamic> toMap() {
    return {
      'songId': songId,
      'duration': duration,
      'title': title,
      'author': author,
      'path': path,
      'lastPlayed': lastPlayed,
    };
  }

  factory SongModel.fromMap(Map<String, dynamic> map) {
    return SongModel(
      map['songId'] as int,
      map['duration'] as int,
      map['title'] as String,
      map['author'] as String,
      map['path'] as String,
      DateTime.parse(map['lastPlayed']),
    );
  }
}
