import 'package:fluent_ui/fluent_ui.dart';

final lightTheme = ThemeData().copyWith(
  activeColor: const Color(0xFF399F2E),
  accentColor: AccentColor('normal', const {
    'lightest': Color(0xffd9f6d5),
    'lighter': Color(0xffb2edab),
    'light': Color(0xff8ce382),
    'normal': Color(0xff66da58),
    'dark': Color(0xff3fd12e),
    'darker': Color(0xff33a725),
    'darkest': Color(0xff267d1c),
  }),
  acrylicBackgroundColor: const Color(0xFFEEEEEE),
  menuColor: const Color(0xFF787878),
  scaffoldBackgroundColor: const Color(0xFFCECECE),
  brightness: Brightness.light,
  inactiveBackgroundColor: const Color(0xFF595959),
  focusTheme: const FocusThemeData(glowFactor: 4.0),
);
