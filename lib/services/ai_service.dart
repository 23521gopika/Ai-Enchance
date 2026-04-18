import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'image_save_handler.dart';

class AiService {
  static const String _enhanceUrl =
  'https://clipdrop-api.co/image-upscaling/v1/upscale';
  static const String _apiKey =
      '170bf53d4255fdc66bad6f36dbe116a91d11363101c93c6a7f9e16c83b75d68e77d653bf34ca7e9b178fb16da37cad73';

  Future<Uint8List> enhanceImage(XFile imageFile) async {
    try {
      final Uint8List imageBytes = await imageFile.readAsBytes();
      if (imageBytes.isEmpty) {
        throw AiServiceException('Selected image is empty. Please choose another image.');
      }

      final String fileName = _fileNameFromPath(imageFile.path);

      final http.MultipartRequest request =
          http.MultipartRequest('POST', Uri.parse(_enhanceUrl))
            ..headers['x-api-key'] = _apiKey
            ..files.add(
              http.MultipartFile.fromBytes(
                'image_file',
                imageBytes,
                filename: fileName,
              ),
            );

      debugPrint(
        '[AiService] Sending enhance request | '
        'url=$_enhanceUrl | file=$fileName | bytes=${imageBytes.length} | '
        'platform=${kIsWeb ? 'web' : defaultTargetPlatform.name}',
      );

      final http.StreamedResponse response = await request.send();
      final Uint8List responseBytes = await response.stream.toBytes();
      final String? contentType = response.headers['content-type'];

      debugPrint(
        '[AiService] Enhance response | '
        'status=${response.statusCode} | contentType=${contentType ?? 'unknown'} | '
        'bytes=${responseBytes.length}',
      );

      if (response.statusCode == 200 && !_isJson(contentType)) {
        return responseBytes;
      }

      final String apiError = _extractApiError(responseBytes, contentType);
      throw AiServiceException(
        'Enhancement failed (${response.statusCode}): $apiError',
      );
    } on AiServiceException {
      rethrow;
    } on http.ClientException {
      throw AiServiceException(
        'Network issue. Check your internet connection and try again.',
      );
    } catch (_) {
      throw AiServiceException(
        'Unexpected error occurred while enhancing image.',
      );
    }
  }

  Future<String> saveEnhancedImage(Uint8List imageBytes) async {
    try {
      return saveImageForCurrentPlatform(imageBytes);
    } on UnsupportedError catch (error) {
      throw AiServiceException(error.message ?? 'Saving is not supported.');
    } catch (_) {
      throw AiServiceException('Unable to save enhanced image.');
    }
  }

  bool _isJson(String? contentType) {
    return contentType != null && contentType.contains('application/json');
  }

  String _extractApiError(Uint8List bytes, String? contentType) {
    try {
      if (!_isJson(contentType)) {
        final String fallback = utf8.decode(bytes, allowMalformed: true).trim();
        if (fallback.isNotEmpty) {
          return fallback;
        }
        return 'The enhancement API returned an unexpected response.';
      }

      final dynamic decoded = jsonDecode(utf8.decode(bytes));
      if (decoded is Map<String, dynamic>) {
        final dynamic status = decoded['statusCode'] ?? decoded['status'];
        if (status == 401 || status == 403) {
          return 'Invalid API key or permission denied.';
        }
        final dynamic message = decoded['error'] ??
            decoded['message'] ??
            decoded['detail'] ??
            decoded['reason'];
        if (message is String && message.trim().isNotEmpty) {
          if (message.toLowerCase().contains('unknown url')) {
            return 'API endpoint is invalid. Please update to the current ClipDrop endpoint.';
          }
          return message.trim();
        }
      }
      return 'The enhancement API rejected the request.';
    } catch (_) {
      return 'Could not parse API error response.';
    }
  }

  String _fileNameFromPath(String path) {
    if (path.isEmpty) {
      return 'upload.jpg';
    }

    final List<String> parts = path.split(RegExp(r'[\\/]'));
    final String fileName = parts.isNotEmpty ? parts.last : 'upload.jpg';
    return fileName.isEmpty ? 'upload.jpg' : fileName;
  }
}

class AiServiceException implements Exception {
  AiServiceException(this.message);

  final String message;

  @override
  String toString() => message;
}