import 'dart:typed_data';

import 'package:bitmap/bitmap.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_image_data.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_render.dart';

@Deprecated('Use `CdgPainter` instead. Will remain here in favor of knowledge of the underlying implementation.')
class CdgImage extends StatefulWidget {
  const CdgImage({Key? key, required this.renderStream}) : super(key: key);

  final Stream<CdgRender> renderStream;

  @override
  State<CdgImage> createState() => _CdgImageState();
}

class _CdgImageState extends State<CdgImage> {
  Uint8List? bytes(CdgImageData imageData) => imageData.data.buffer.asUint8List();
  Image? lastImage;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CdgRender>(
      stream: widget.renderStream,
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (snapshot.hasData && data != null) {
          final bytes = data.imageData.data;
          return lastImage = Image.memory(Bitmap.fromHeadless(data.imageData.width, data.imageData.height, bytes).buildHeaded());
        }
        return lastImage ?? const Center(child: ProgressRing());
      },
    );
  }
}
