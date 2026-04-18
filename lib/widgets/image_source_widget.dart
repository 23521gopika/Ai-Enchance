import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'image_source_widget_stub.dart'
    if (dart.library.io) 'image_source_widget_mobile.dart'
    if (dart.library.html) 'image_source_widget_web.dart' as impl;

Widget buildSourceImage({
  required XFile image,
  required BoxFit fit,
  Uint8List? webImageBytes,
}) {
  return impl.buildSourceImage(
    image: image,
    fit: fit,
    webImageBytes: webImageBytes,
  );
}
