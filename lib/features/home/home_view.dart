import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_cdg_karaoke_player/features/karaoke_player/karaoke_mini_player_view.dart';
import 'package:flutter_cdg_karaoke_player/features/karaoke_player_window/components/window_scaffold.dart';
import 'package:flutter_cdg_karaoke_player/service/karaoke_player_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final karaokeService = KaraokePlayerController();
    return WindowScaffold(
      background: Container(
        height: double.infinity,
        width: double.infinity,
        color: const Color(0xFF999999),
      ),
      body: Row(
        children: [
          Spacer(),
          Spacer(),
          Column(
            children: [
              KaraokeMiniPlayerView(karaokeService: karaokeService),
              Row(
                children: [
                  StreamBuilder<bool>(
                      stream: karaokeService.isPlayingStream,
                      builder: (context, snapshot) {
                        return FilledButton(
                          onPressed: karaokeService.playOnPressed,
                          child: Icon(snapshot.data == true ? FluentIcons.pause : FluentIcons.play),
                        );
                      }),
                  FilledButton(
                    onPressed: () => karaokeService.stop(),
                    child: const Icon(FluentIcons.stop_solid),
                  ),
                  FilledButton(
                    onPressed: () async {
                      final window = await DesktopMultiWindow.createWindow('');

                      karaokeService.playerWindowId = window.windowId;

                      window
                        ..setFrame(const Offset(0, 0) & const Size(1280, 720))
                        ..center()
                        ..setTitle('Karaoke Player')
                        ..show();
                    },
                    child: const Icon(FluentIcons.add),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
