enum Strings {
  appName,
  home,
  ;

  String get tr => _stringsMap[this] ?? '';
}

const _stringsMap = {
  Strings.appName: 'Karaoke Player',
  Strings.home: 'Home',
};