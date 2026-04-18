import 'dart:typed_data';

Future<String> saveImageForCurrentPlatform(Uint8List imageBytes) {
  throw UnsupportedError('Saving images is not supported on this platform.');
}
