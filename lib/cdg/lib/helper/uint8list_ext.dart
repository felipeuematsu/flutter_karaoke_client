import 'dart:typed_data';

extension on Uint8List {
  void fill(int value) {
    for (int i = 0; i < length; i++) {
      this[i] = value;
    }
  }
}
