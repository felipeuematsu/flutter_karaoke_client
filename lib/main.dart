import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_cdg_karaoke_player/config/routes.dart';
import 'package:flutter_cdg_karaoke_player/config/theme.dart';
import 'package:flutter_cdg_karaoke_player/features/home/home_view.dart';
import 'package:flutter_cdg_karaoke_player/features/karaoke_player_window/karaoke_player_window_app.dart';
import 'package:flutter_cdg_karaoke_player/features/queue/queue_view.dart';
import 'package:flutter_cdg_karaoke_player/features/songs/songs_view.dart';
import 'package:flutter_cdg_karaoke_player/service/karaoke_main_player_controller.dart';
import 'package:flutter_cdg_karaoke_player/features/karaoke_player_window/karaoke_player_window.dart';
import 'package:flutter_cdg_karaoke_player/service/impl/karaoke_main_player_controller_impl.dart';
import 'package:flutter_cdg_karaoke_player/service/karaoke_video_player_controller.dart';
import 'package:flutter_cdg_karaoke_player/service/impl/karaoke_video_player_controller_impl.dart';
import 'package:get_it/get_it.dart';
import 'package:list_ext/list_ext.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (args.firstOrNull == 'multi_window') {
    GetIt.I.registerSingleton<KaraokeVideoPlayerController>(KaraokeVideoPlayerControllerImpl());
    runApp(const MainApp());
  } else {
    final window = await DesktopMultiWindow.createWindow('');
    GetIt.I.registerSingleton<KaraokeMainPlayerController>(KaraokeMainPlayerControllerImpl()..playerWindowId = window.windowId);
    runApp(const KaraokePlayerWindowApp());
    doWhenWindowReady(() async {
      appWindow.alignment = Alignment.topLeft;
      appWindow.title = 'Karaoke';
      appWindow.show();
    });

    window
      ..setFrame(const Offset(0, 0) & const Size(1280, 720))
      ..center()
      ..setTitle('Karaoke Player')
      ..show();
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.system,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      theme: lightTheme,
      routes: {
        Routes.home.route: (context) => const HomeView(),
        Routes.songs.route: (context) => const SongsView(),
        Routes.queue.route: (context) => const QueueView(),
      },
      initialRoute: Routes.home.route,
    );
  }
}
