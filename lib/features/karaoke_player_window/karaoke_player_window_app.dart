import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_cdg_karaoke_player/features/karaoke_player_window/karaoke_player_window.dart';
import 'package:get_it/get_it.dart';

class KaraokePlayerWindowApp extends StatefulWidget {
  const KaraokePlayerWindowApp({Key? key, this.windowController}) : super(key: key);

  final WindowController? windowController;

  @override
  State<KaraokePlayerWindowApp> createState() => _KaraokePlayerWindowAppState();
}

class _KaraokePlayerWindowAppState extends State<KaraokePlayerWindowApp> {
  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Karaoke Player',
      home: KaraokePlayerWindow(windowController: widget.windowController, videoPlayerService: GetIt.I.get()),
    );
  }
}
