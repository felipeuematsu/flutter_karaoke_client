import 'dart:ui';

import 'package:bitmap/bitmap.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Image;
import 'package:flutter_cdg_karaoke_player/cdg/cdg_painter.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_context.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_render.dart';
import 'package:flutter_cdg_karaoke_player/service/karaoke_video_player_controller.dart';
import 'package:get_it/get_it.dart';

class KaraokeMiniPlayerView extends StatefulWidget {
  const KaraokeMiniPlayerView({Key? key, required this.karaokeService}) : super(key: key);

  final KaraokeVideoPlayerController karaokeService;

  @override
  State<KaraokeMiniPlayerView> createState() => _KaraokeMiniPlayerViewState();
}

class _KaraokeMiniPlayerViewState extends State<KaraokeMiniPlayerView> {
  CustomPaint? lastPaint;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: CDGContext.kHeightDouble,
      width: CDGContext.kWidthDouble,
      color: const Color(0xFFBBBBBB),
      child: StreamBuilder<CdgRender>(
        stream: widget.karaokeService.renderStream.stream,
        builder: (_, snapshot) {
          final data = snapshot.data;
          if (data == null) return const ProgressRing();
          return FutureBuilder<Image>(
            future: Bitmap.fromHeadful(data.imageData.width, data.imageData.height, data.imageData.data).buildImage(),
            builder: (context, snapshot) {
              final imageData = snapshot.data;
              if (snapshot.connectionState == ConnectionState.done && imageData != null) {
                return lastPaint = CustomPaint(
                  painter: CdgPainter(imageData: imageData),
                  size: const Size(CDGContext.kWidthDouble, CDGContext.kHeightDouble),
                  isComplex: true,
                  willChange: data.isChanged,
                );
              }
              return lastPaint ?? const SizedBox();
            },
          );
        },
      ),
    );
  }
}
