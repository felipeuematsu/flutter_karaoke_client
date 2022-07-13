import 'package:flutter_cdg_karaoke_player/cdg/lib/instructions/impl/cdg_load_clut_low_instruction.dart';

/// **********************************************
/// LOAD_CLUT_HI
///***********************************************/
class CDGLoadCLUTHighInstruction extends CDGLoadCLUTLowInstruction {
  CDGLoadCLUTHighInstruction(super.bytes);

  @override
  int get clutOffset => 8;
}
