import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_cdg_karaoke_player/features/widgets/navigation_view/custom_navigation_view.dart';
import 'package:flutter_cdg_karaoke_player/service/queue_controller.dart';

class QueueView extends StatelessWidget {
  const QueueView({Key? key, required this.queueController}) : super(key: key);

  final QueueController queueController;

  @override
  Widget build(BuildContext context) {
    return CustomNavigationView(
      selected: 2,
      child: Container(),
    );
  }
}
