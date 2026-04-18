import 'dart:typed_data';
import 'package:universal_html/html.dart' as html;

Future<String> saveImageForCurrentPlatform(Uint8List imageBytes) async {
  final String fileName = 'enhanced_${DateTime.now().millisecondsSinceEpoch}.png';
  final html.Blob blob = html.Blob(<dynamic>[imageBytes], 'image/png');
  final String blobUrl = html.Url.createObjectUrlFromBlob(blob);
  final html.AnchorElement anchor =
      html.AnchorElement(href: blobUrl)
        ..setAttribute('download', fileName)
        ..style.display = 'none';

  html.document.body?.children.add(anchor);
  anchor.click();
  anchor.remove();
  html.Url.revokeObjectUrl(blobUrl);

  return 'Downloaded: $fileName';
}
