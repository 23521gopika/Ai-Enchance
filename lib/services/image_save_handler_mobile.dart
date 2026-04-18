import 'dart:io';
import 'dart:typed_data';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

Future<String> saveImageForCurrentPlatform(Uint8List imageBytes) async {
  final String fileName = 'enhanced_${DateTime.now().millisecondsSinceEpoch}';
  final dynamic result = await ImageGallerySaver.saveImage(
    imageBytes,
    quality: 100,
    name: fileName,
  );

  if (_parseSaveResult(result)) {
    return 'Saved to gallery';
  }

  final Directory targetDirectory = Platform.isAndroid
      ? await getExternalStorageDirectory() ??
            await getApplicationDocumentsDirectory()
      : await getApplicationDocumentsDirectory();
  final File outputFile = File('${targetDirectory.path}/$fileName.jpg');
  await outputFile.writeAsBytes(imageBytes);
  return outputFile.path;
}

bool _parseSaveResult(dynamic result) {
  if (result is Map) {
    final dynamic saved = result['isSuccess'] ?? result['success'];
    if (saved is bool) {
      return saved;
    }
    if (saved is int) {
      return saved == 1;
    }
    if (saved is String) {
      return saved == 'true' || saved == '1';
    }
  }
  return false;
}
