import 'dart:typed_data';
import 'package:saver_gallery/saver_gallery.dart';

Future<String> saveImageForCurrentPlatform(Uint8List imageBytes) async {
  final String fileName =
      'enhanced_${DateTime.now().millisecondsSinceEpoch}.jpg';

  final result = await SaverGallery.saveImage(
    imageBytes,
    fileName: fileName,
    androidRelativePath: "Pictures/AIEnhancer",
    skipIfExists: false, // ✅ IMPORTANT FIX
  );

  if (result.isSuccess) {
    return "Saved to gallery";
  } else {
    return "Save failed";
  }
}