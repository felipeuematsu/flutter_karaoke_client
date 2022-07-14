import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_cdg_karaoke_player/features/home/home_view.dart';
import 'package:flutter_cdg_karaoke_player/features/karaoke_player_window/karaoke_player_window.dart';
import 'package:list_ext/list_ext.dart';
import 'package:window_manager/window_manager.dart';

void main(List<String> args) {
  if (args.firstOrNull == 'multi_window') {
    final windowId = int.parse(args[1]);
    runApp(KaraokePlayerWindow(windowController: WindowController.fromWindowId(windowId)));
    doWhenWindowReady(() async {
      appWindow.title = 'Karaoke Player';
      appWindow.show();
    });
  } else {
    runApp(const MyApp());
    doWhenWindowReady(() async {
      await WindowManager.instance.setTitleBarStyle(TitleBarStyle.hidden);
      appWindow.alignment = Alignment.topLeft;
      appWindow.title = 'Karaoke';
      appWindow.show();
    });
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
