import 'dart:math';
import 'dart:ui' as ui;

import 'package:bitmap/bitmap.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_cdg_karaoke_player/cdg/cdg_painter.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_context.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_render.dart';
import 'package:flutter_cdg_karaoke_player/features/karaoke_player_window/components/window_scaffold.dart';
import 'package:flutter_cdg_karaoke_player/service/karaoke_main_player_controller.dart';

class KaraokePlayerWindow extends StatefulWidget {
  const KaraokePlayerWindow({Key? key, this.windowController, required this.videoPlayerService}) : super(key: key);

  final KaraokeMainPlayerController videoPlayerService;
  final WindowController? windowController;

  @override
  State<KaraokePlayerWindow> createState() => _KaraokePlayerWindowState();
}

class _KaraokePlayerWindowState extends State<KaraokePlayerWindow> {
  CustomPaint? lastPaint;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height / CDGContext.kHeightDouble;
    final width = MediaQuery.of(context).size.width / CDGContext.kWidthDouble;

    final minScale = min(height, width);
    return WindowScaffold(
      background: const DecoratedBox(decoration: BoxDecoration(color: Colors.white)),
      body: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()..scale(minScale, minScale, 1.0),
        child: Center(
          child: StreamBuilder<CdgRender>(
            stream: widget.videoPlayerService.renderStream.stream,
            builder: (_, snapshot) {
              final data = snapshot.data;
              if (data == null) return const SizedBox();
              return FutureBuilder<ui.Image>(
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
        ),
      ),
    );
  }
}
