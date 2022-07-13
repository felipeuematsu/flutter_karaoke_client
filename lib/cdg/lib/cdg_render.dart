import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_image_data.dart';

class CdgRender {
  CdgRender({required this.imageData, required this.isChanged, required this.backgroundRgba, required this.contentBounds});

  CDGImageData imageData;
  bool isChanged;
  List<int> backgroundRgba, contentBounds;
}
