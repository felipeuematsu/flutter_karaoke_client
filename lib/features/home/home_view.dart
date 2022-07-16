import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_cdg_karaoke_player/features/karaoke_player/karaoke_mini_player_view.dart';
import 'package:flutter_cdg_karaoke_player/features/karaoke_player_window/components/window_scaffold.dart';
import 'package:flutter_cdg_karaoke_player/features/widgets/navigation_view/custom_navigation_view.dart';
import 'package:flutter_cdg_karaoke_player/service/karaoke_video_player_controller.dart';
import 'package:get_it/get_it.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final KaraokeVideoPlayerController karaokeService = GetIt.I.get();
    return CustomNavigationView(
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Row(
          children: [
            const Spacer(flex: 3),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    KaraokeMiniPlayerView(karaokeService: karaokeService),
                    const SizedBox(height: 12.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FilledButton(
                          onPressed: () => karaokeService.stop(),
                          child: const Icon(FluentIcons.back),
                        ),
                        StreamBuilder<bool>(
                          stream: karaokeService.isPlayingStream.stream,
                          builder: (_, snapshot) => FilledButton(
                            onPressed: snapshot.data == true ? karaokeService.pause : karaokeService.play,
                            child: Icon(snapshot.data == true ? FluentIcons.pause : FluentIcons.play),
                          ),
                        ),
                        FilledButton(
                          onPressed: () => karaokeService.stop(),
                          child: const Icon(FluentIcons.stop_solid),
                        ),
                        FilledButton(
                          onPressed: () => karaokeService.stop(),
                          child: const Icon(FluentIcons.next),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
