import 'dart:math';
import 'dart:ui' as ui;

import 'package:bitmap/bitmap.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_cdg_karaoke_player/cdg/cdg_painter.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_context.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_render.dart';
import 'package:flutter_cdg_karaoke_player/features/karaoke_player_window/karaoke_player_controller.dart';
import 'package:window_manager/window_manager.dart';

class KaraokePlayerWindow extends StatefulWidget {
  const KaraokePlayerWindow({Key? key, this.windowController}) : super(key: key);

  final WindowController? windowController;

  @override
  State<KaraokePlayerWindow> createState() => _KaraokePlayerWindowState();
}

class _KaraokePlayerWindowState extends State<KaraokePlayerWindow> {
  late final _videoPlayerService = KaraokePlayerController();

  CustomPaint? lastPaint;

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Karaoke Player',
      theme: ThemeData(
        focusTheme: const FocusThemeData(glowFactor: 4.0),
      ),
      home: GestureDetector(
        onDoubleTap: () async {
          windowManager.setFullScreen(!(await windowManager.isFullScreen()));
        },
        child: Acrylic(
          child: Center(
            child: FutureBuilder<Size>(
                future: windowManager.getSize(),
                builder: (context, snapshot) {
                  final size = snapshot.data;

                  if (size == null) {
                    return const SizedBox();
                  }
                  final heightScale = CDGContext.kHeightDouble / size.height;
                  final widthScale = CDGContext.kWidthDouble / size.width;
                  final minScale = min(heightScale, widthScale);
                  return Transform(
                    transform: Matrix4.identity()
                    ..scale(minScale, minScale)
                    ,
                    child: StreamBuilder<CdgRender>(
                      stream: _videoPlayerService.renderStream.stream,
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
                  );
                }),
          ),
        ),
      ),
    );
  }
}
