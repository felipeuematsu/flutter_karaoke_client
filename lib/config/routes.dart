enum Routes {
  home,
  history,
  settings,
  songs,
  users,
  // playlists,
  queue,
  ;

  String get route => _routesMap[this] ?? '';
}

const _routesMap = {
  Routes.home: '/',
  Routes.history: '/history',
  Routes.settings: '/settings',
  Routes.songs: '/songs',
  Routes.users: '/users',
  // Routes.playlists: '/playlists',
  Routes.queue: '/queue',
};
