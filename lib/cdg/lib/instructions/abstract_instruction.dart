import 'dart:typed_data';

import 'package:flutter_cdg_karaoke_player/cdg/lib/cdg_context.dart';

abstract class CDGInstruction {
  const CDGInstruction(Uint8List bytes);

  CDGContext execute(CDGContext context);
}
