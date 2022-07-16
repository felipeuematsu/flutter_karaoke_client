import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_cdg_karaoke_player/config/strings.dart';

class CustomNavigationView extends StatelessWidget {
  const CustomNavigationView({Key? key, this.child}) : super(key: key);
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      pane: NavigationPane(
        items: [
          PaneItem(
            icon: const Icon(FluentIcons.home),
            title: Text(Strings.home.tr),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.music_in_collection),
            title: Text(Strings.home.tr),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.stream_playlist),
            title: Text(Strings.home.tr),
          ),
        ],
      ),
      appBar: NavigationAppBar(
        backgroundColor: const Color(0xFFEEEEEE),
        title: Text(Strings.appName.tr),
      ),
      content: child ?? const SizedBox(),
    );
  }
}
