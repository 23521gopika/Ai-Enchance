import 'dart:typed_data';
import 'package:saver_gallery/saver_gallery.dart';

import 'ai_service_exception.dart';

Future<String> saveImageForCurrentPlatform(Uint8List imageBytes) async {
  final String extension = _isWebp(imageBytes) ? 'webp' : 'jpg';
  final String fileName =
      'enhanced_${DateTime.now().millisecondsSinceEpoch}.$extension';

  const String galleryPath = 'Pictures/AIEnhancer';

  final result = await SaverGallery.saveImage(
    imageBytes,
    fileName: fileName,
    androidRelativePath: galleryPath,
    skipIfExists: false,
  );

  if (result.isSuccess) {
    return '$galleryPath/$fileName';
  }

  final String errorMessage = (result.errorMessage ?? '').trim();
  throw AiServiceException(
    errorMessage.isNotEmpty
        ? errorMessage
        : 'Failed to save image to gallery.',
  );
}

bool _isWebp(Uint8List bytes) {
  if (bytes.length < 12) {
    return false;
  }

  return bytes[0] == 0x52 &&
      bytes[1] == 0x49 &&
      bytes[2] == 0x46 &&
      bytes[3] == 0x46 &&
      bytes[8] == 0x57 &&
      bytes[9] == 0x45 &&
      bytes[10] == 0x42 &&
      bytes[11] == 0x50;
}