import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Widget buildSourceImage({
  required XFile image,
  required BoxFit fit,
  Uint8List? webImageBytes,
}) {
  if (webImageBytes != null && webImageBytes.isNotEmpty) {
    return Image.memory(
      webImageBytes,
      fit: fit,
    );
  }

  return Image.network(
    image.path,
    fit: fit,
    errorBuilder: (_, __, ___) {
      return const Center(
        child: Icon(
          Icons.broken_image_outlined,
          size: 42,
        ),
      );
    },
  );
}
