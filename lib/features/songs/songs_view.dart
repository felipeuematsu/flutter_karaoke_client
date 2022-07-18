import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_cdg_karaoke_player/features/widgets/navigation_view/custom_navigation_view.dart';

class SongsView extends StatelessWidget {
  const SongsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CustomNavigationView(selected: 1);
  }
}
