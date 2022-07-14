import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_cdg_karaoke_player/features/karaoke_player_window/karaoke_player_window.dart';

class KaraokePlayerWindowApp extends StatefulWidget {
  const KaraokePlayerWindowApp({Key? key, required this.windowController}) : super(key: key);

  final WindowController windowController;

  @override
  State<KaraokePlayerWindowApp> createState() => _KaraokePlayerWindowAppState();
}

class _KaraokePlayerWindowAppState extends State<KaraokePlayerWindowApp> {
  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Karaoke Player',
      theme: ThemeData(
        focusTheme: const FocusThemeData(glowFactor: 4.0),
      ),
      home: KaraokePlayerWindow(windowController: widget.windowController),
    );
  }
}