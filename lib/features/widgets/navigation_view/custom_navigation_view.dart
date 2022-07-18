import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_cdg_karaoke_player/config/routes.dart';
import 'package:flutter_cdg_karaoke_player/config/strings.dart';

class CustomNavigationView extends StatelessWidget {
  const CustomNavigationView({Key? key, this.child, required this.selected, this.implyLeading = false}) : super(key: key);
  final Widget? child;
  final int selected;

  Future<void> _pushRoute(BuildContext context, String route) async {
    Navigator.pushReplacementNamed(context, route);
  }

  final bool implyLeading;

  void Function(int) _onChanged(BuildContext context) => (int index) {
        if (index == 0) {
          _pushRoute(context, Routes.home.route);
        } else if (index == 1) {
          _pushRoute(context, Routes.songs.route);
        } else if (index == 2) {
          _pushRoute(context, Routes.queue.route);
        }
      };

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      pane: NavigationPane(
        displayMode: PaneDisplayMode.open,
        selected: selected,
        onChanged: _onChanged(context),
        items: [
          PaneItem(icon: const Icon(FluentIcons.home), title: Text(Strings.home.tr)),
          PaneItem(icon: const Icon(FluentIcons.music_note), title: Text(Strings.songs.tr)),
          PaneItem(icon: const Icon(FluentIcons.playlist_music), title: Text(Strings.queue.tr)),
        ],
      ),
      appBar: NavigationAppBar(
        backgroundColor: const Color(0xFFEEEEEE),
        title: Text(Strings.appName.tr),
        automaticallyImplyLeading: implyLeading,

      ),
      content: child ?? const SizedBox(),
    );
  }
}
