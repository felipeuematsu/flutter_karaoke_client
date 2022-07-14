import 'package:bitmap/bitmap.dart';
import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_image_data.dart';

class CdgRender {
  CdgRender({required CdgImageData imageData, required this.isChanged, this.backgroundRgba, this.contentBounds})
      : imageData = CdgRenderedImageData(
            imageData.width,
            imageData.height,
            Bitmap.fromHeadless(
              imageData.width,
              imageData.height,
              imageData.data.buffer.asUint8List(),
            ).buildHeaded());
  CdgRender.rendered({required this.imageData, required this.isChanged, this.backgroundRgba, this.contentBounds});

  CdgRenderedImageData imageData;
  bool isChanged;
  List<int>? backgroundRgba, contentBounds;
}
