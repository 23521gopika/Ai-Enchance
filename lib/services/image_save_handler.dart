import 'dart:typed_data';

import 'image_save_handler_stub.dart'
    if (dart.library.io) 'image_save_handler_mobile.dart'
    if (dart.library.html) 'image_save_handler_web.dart' as impl;

Future<String> saveImageForCurrentPlatform(Uint8List imageBytes) {
  return impl.saveImageForCurrentPlatform(imageBytes);
}
