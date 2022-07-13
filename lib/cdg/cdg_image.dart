import 'dart:typed_data';

import 'package:bitmap/bitmap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_image_data.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_render.dart';

class CdgImage extends StatefulWidget {
  const CdgImage({Key? key, required this.renderStream}) : super(key: key);

  final Stream<CdgRender> renderStream;

  @override
  State<CdgImage> createState() => _CdgImageState();
}

class _CdgImageState extends State<CdgImage> {
  Uint8List? bytes(CDGImageData imageData) => imageData.data.buffer.asUint8List();

  Color backgroundColor(List<int> backgroundRgba) {
    return Color.fromARGB(
      backgroundRgba[3],
      backgroundRgba[0],
      backgroundRgba[1],
      backgroundRgba[2],
    );
  }

  Image? lastImage;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.renderStream,
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (snapshot.hasData && data != null) {
          final bytes = this.bytes(data.imageData);
          if (bytes != null) {
            return lastImage = Image.memory(Bitmap.fromHeadless(data.imageData.width, data.imageData.height, bytes).buildHeaded());
          }
        }
        return lastImage ?? const Center(child: CircularProgressIndicator());
      },
    );
  }
}
