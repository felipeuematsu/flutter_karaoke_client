import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_cdg_karaoke_player/features/karaoke_player/karaoke_mini_player_view.dart';
import 'package:flutter_cdg_karaoke_player/features/queue/queue_mini_view.dart';
import 'package:flutter_cdg_karaoke_player/features/widgets/navigation_view/custom_navigation_view.dart';
import 'package:flutter_cdg_karaoke_player/service/karaoke_video_player_controller.dart';
import 'package:get_it/get_it.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final KaraokeVideoPlayerController karaokeService = GetIt.I.get();
    return CustomNavigationView(
      selected: 0,
      child: NavigationBody(
        transitionBuilder: (child, animation) => SuppressPageTransition(child: child),
        index: 0,
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(child: QueueMiniView(queueController: GetIt.I.get())),
                      // Flexible(child: SingersMiniView(queueController: GetIt.I.get())),
                    ],
                  ),
                ),
                const SizedBox(width: 8.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      KaraokeMiniPlayerView(karaokeService: karaokeService),
                      const SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FilledButton(onPressed: () => karaokeService.stop(), child: const Icon(FluentIcons.back)),
                          StreamBuilder<bool>(
                            stream: karaokeService.isPlayingStream.stream,
                            builder: (_, snapshot) => FilledButton(
                              onPressed: snapshot.data == true ? karaokeService.pause : karaokeService.play,
                              child: Icon(snapshot.data == true ? FluentIcons.pause : FluentIcons.play),
                            ),
                          ),
                          FilledButton(onPressed: () => karaokeService.stop(), child: const Icon(FluentIcons.stop_solid)),
                          FilledButton(onPressed: () => karaokeService.stop(), child: const Icon(FluentIcons.next)),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
