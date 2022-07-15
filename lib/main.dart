import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_cdg_karaoke_player/features/home/home_view.dart';
import 'package:flutter_cdg_karaoke_player/features/karaoke_player_window/karaoke_player_controller.dart';
import 'package:flutter_cdg_karaoke_player/features/karaoke_player_window/karaoke_player_window.dart';
import 'package:flutter_cdg_karaoke_player/service/karaoke_video_player_controller.dart';
import 'package:list_ext/list_ext.dart';

void main(List<String> args) async {
  if (args.firstOrNull == 'multi_window') {
    // final windowId = int.parse(args[1]);
    runApp(const MyApp());
  } else {
    runApp(const KaraokePlayerWindow());
    doWhenWindowReady(() async {
      appWindow.alignment = Alignment.topLeft;
      appWindow.title = 'Karaoke';
      appWindow.show();
    });
    final window = await DesktopMultiWindow.createWindow('');
    KaraokePlayerController().playerWindowId = window.windowId;

    window
      ..setFrame(const Offset(0, 0) & const Size(1280, 720))
      ..center()
      ..setTitle('Karaoke Player')
      ..show();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        focusTheme: const FocusThemeData(glowFactor: 4.0),
      ),
      home: const HomeView(),
    );
  }
}
