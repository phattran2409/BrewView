import 'dart:convert';
import 'dart:typed_data';
import 'package:path/path.dart' as path;

class HandleFileUpload {
  static Uint8List createMultipartBody({
     required String boundary,
     required String fileName,
     required Uint8List fileBytes,  
      required String mimeType,
  }) {
    final buffer = StringBuffer();

    // ✅ Start boundary
    buffer.write('--$boundary\r\n');

    // ✅ Content-Disposition header
    buffer.write(
      'Content-Disposition: form-data; name="avatarFile"; filename="$fileName"\r\n',
    );

    // ✅ Content-Type header
    buffer.write('Content-Type: $mimeType\r\n\r\n');

    // ✅ Convert buffer to bytes
    final headerBytes = utf8.encode(buffer.toString());

    // ✅ End boundary
    final endBoundary = utf8.encode('\r\n--$boundary--\r\n');

    // ✅ Combine all parts
    final result = Uint8List(
      headerBytes.length + fileBytes.length + endBoundary.length,
    );
    result.setRange(0, headerBytes.length, headerBytes);
    result.setRange(
      headerBytes.length,
      headerBytes.length + fileBytes.length,
      fileBytes,
    );
    result.setRange(
      headerBytes.length + fileBytes.length,
      result.length,
      endBoundary,
    );

    return result;  
  }
  static String? getMimeType(String filePath) {
    final extension = path.extension(filePath).toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'bmp':
        return 'image/bmp';
      case 'webp':
        return 'image/webp';
      default:
        return null; // Unknown MIME type
    }
  }
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024)
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
} 