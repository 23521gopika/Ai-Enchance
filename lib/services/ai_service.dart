import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class AiService {
  static const String apiUrl = 'https://api.example.com/enhance';

  static Future<Uint8List?> enhanceImage(File imageFile) async {
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    request.files.add(
      await http.MultipartFile.fromPath('image', imageFile.path),
    );

    var response = await request.send();

    if (response.statusCode == 200) {
      return await response.stream.toBytes();
    } else {
      return null;
    }
  }
}