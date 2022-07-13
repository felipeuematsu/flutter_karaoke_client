
import 'package:bitmap/bitmap.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter_cdg_karaoke_player/cdg/cdg_image.dart';
import 'package:flutter_cdg_karaoke_player/cdg/cdg_painter.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_context.dart';
import 'package:flutter_cdg_karaoke_player/service/karaoke_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool get _playing => _karaokeService.isPlaying;

  final KaraokeService _karaokeService = KaraokeService()..onInit();

  CustomPaint? lastPaint;

  Future<void> _updateState() async {
    await _karaokeService.playOnPressed();
    setState(() {});
    print('Playing: $_playing');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Colors.blue,
              height: CDGContext.kHeightDouble,
              width: CDGContext.kWidthDouble,
              child: CdgImage(renderStream: _karaokeService.audioDurationStream.stream),
            ),
            StreamBuilder(
                stream: _karaokeService.audioDurationStream.stream,
                builder: (context, snapshot) {
                  final data = snapshot.data;

                  if (data == null) return const CircularProgressIndicator();
                  return FutureBuilder(
                    future: Bitmap.fromHeadless(data.imageData.width, data.imageData.height, data.imageData.data.buffer.asUint8List()).buildImage(),
                    builder: (context, snapshot) {
                      final imageData = snapshot.data;
                      if (snapshot.connectionState == ConnectionState.done && imageData != null) {
                        return lastPaint = CustomPaint(
                          painter: CdgPainter(imageData: imageData, backgroundRgba: data.backgroundRgba),
                          size: const Size(CDGContext.kWidthDouble, CDGContext.kHeightDouble),
                          isComplex: true,
                          willChange: data.isChanged,
                        );
                      }
                      return lastPaint ?? const SizedBox();
                    },
                  );
                }),
          ],
        ),
      ),
      floatingActionButton: Row(
        children: [
          FloatingActionButton(
            onPressed: _updateState,
            tooltip: _playing ? 'Pause' : 'Play',
            child: Icon(_playing ? Icons.pause : Icons.play_arrow),
          ), FloatingActionButton(
            onPressed: () => _karaokeService.stop(),
            tooltip:'Stop',
            child: const Icon(Icons.stop),
          ),
        ],
      ),
    );
  }
}
