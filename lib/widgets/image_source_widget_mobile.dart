import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Widget buildSourceImage({
  required XFile image,
  required BoxFit fit,
  Uint8List? webImageBytes,
}) {
  return Image.file(
    File(image.path),
    fit: fit,
  );
}
