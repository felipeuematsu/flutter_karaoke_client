enum Strings {
  appName,
  home,
  songs,
  users,
  playlists,
  queue,
  ;

  String get tr => _stringsMap[this] ?? '';
}

const _stringsMap = {
  Strings.appName: 'Karaoke Player',
  Strings.home: 'Home',
  Strings.songs: 'Songs',
  Strings.users: 'Users',
  Strings.playlists: 'Playlists',
  Strings.queue: 'Queue',
};