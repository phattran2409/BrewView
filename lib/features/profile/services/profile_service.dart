import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as path;
import 'package:briewview/core/constants/app_constants.dart';
import 'package:briewview/core/network/user_storage_services.dart';
import 'package:briewview/features/user_management/model/user_model.dart';
import 'package:injectable/injectable.dart';
import '../model/profile_model.dart';
import 'dart:convert';

@singleton
class ProfileService {
  final UserStorageServices _userStorageServices;
  final HttpClient _httpClient;

  ProfileService(this._userStorageServices) : _httpClient = _createHttpClient();

  // ✅ Tạo HttpClient riêng với SSL bypass
  static HttpClient _createHttpClient() {
    final client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  }

  Future<UserModel> getCurrentProfile() async {
    await Future.delayed(const Duration(seconds: 1));
    final userData = await _userStorageServices.getCurrentUser();
    return userData ??
        UserModel(
          id: '',
          name: '',
          email: '',
          profilePicture: '',
          role: '',
          identityId: '',
        );
  }

  Future<UserModel> updateProfile(UserModel user) async {
    await Future.delayed(const Duration(seconds: 1));
    return user;
  }

  Future<void> updateLanguagePreference(bool isVietnamese) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> deleteAccount() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  // ✅ Implementation hoàn toàn khác thủ với HttpClient
  Future<Map<String, dynamic>?> updateProfilePicture(String imagePath) async {
    try {
      final dataUser = await _userStorageServices.getCurrentUser();

      if (dataUser?.id == null || dataUser!.id.isEmpty) {
        throw Exception('User ID is null or empty');
      }

      final file = File(imagePath);
      if (!await file.exists()) {
        throw Exception('File does not exist at path: $imagePath');
      }

      // ✅ Debug info
      final fileSize = await file.length();
      final fileName = path.basename(imagePath);
      print(' MANUAL UPLOAD DEBUG:');
      print('  - User ID: ${dataUser.id}');
      print('  - File: $fileName');
      print('  - Size: ${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB');
      print('  - Path: $imagePath');

      // ✅ Tạo boundary cho multipart
      final boundary =
          '----WebKitFormBoundary${DateTime.now().millisecondsSinceEpoch}';

      // ✅ Đọc file bytes
      final fileBytes = await file.readAsBytes();

      // ✅ Tạo multipart body thủ công
      final multipartBody = _createMultipartBody(
        boundary: boundary,
        fileName: fileName,
        fileBytes: fileBytes,
        mimeType: _getMimeType(imagePath),
      );

      // ✅ Tạo HTTP request
      final uri = Uri.parse(
        '${AppConstants.apiBaseUrl}/api/users/avatar/${dataUser.id}',
      );
      print('🚀 Request URL: $uri');

      final request = await _httpClient.postUrl(uri);

      // ✅ Set headers
      request.headers.set('accept', '*/*');
      request.headers.set(
        'Content-Type',
        'multipart/form-data; boundary=$boundary',
      );
      request.headers.set('Content-Length', multipartBody.length.toString());

      // ✅ Thêm Authorization header nếu có
      if (dataUser.accessToken != null && dataUser.accessToken!.isNotEmpty) {
        request.headers.set('Authorization', 'Bearer ${dataUser.accessToken}');
        print('✅ Added Authorization header');
      }

      // ✅ Write body
      request.add(multipartBody);

      print('🚀 Sending request...');

      // ✅ Send request
      final response = await request.close();
      final responseBody =
          await response.transform(const SystemEncoding().decoder).join();

      print('✅ Response received:');
      print('  - Status: ${response.statusCode}');
      print('  - Headers: ${response.headers}');
      print('  - Body: $responseBody');

      if (response.statusCode == 200) {
        try {
          return {'isSuccess': true, 'data': responseBody};
        } catch (e) {
          return {'isSuccess': true, 'data': responseBody};
        }
      } else {
        throw Exception(
          'Failed to update profile picture: ${response.statusCode} - $responseBody',
        );
      }
    } catch (e) {
      print('❌ Manual upload error: $e');
      throw Exception('Failed to update profile picture: $e');
    }
  }

  // ✅ Tạo multipart body thủ công
  Uint8List _createMultipartBody({
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

  Future<Map<String, dynamic>> getFileSizeInfo(String imagePath) async {
    final file = File(imagePath);
    if (!await file.exists()) {
      throw Exception('File does not exist at path: $imagePath');
    }

    final fileSize = await file.length();
    final fileName = path.basename(imagePath);

    return {
      'fileSize': fileSize,
      'fileSizeFormatted': _formatFileSize(fileSize),
      'fileName': fileName,
      'isValidSize': fileSize <= 5 * 1024 * 1024, // 5MB limit
    };
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024)
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  String _getMimeType(String imagePath) {
    final extension = path.extension(imagePath).toLowerCase();
    switch (extension) {
      case '.png':
        return 'image/png';
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.gif':
        return 'image/gif';
      case '.webp':
        return 'image/webp';
      default:
        return 'image/png';
    }
  }

  // ✅ Dispose HttpClient
  void dispose() {
    _httpClient.close();
  }
}

extension ProfileModelCopyWith on ProfileModel {
  ProfileModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? profilePicture,
    String? bio,
    bool? isVietnameseLanguage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      bio: bio ?? this.bio,
      isVietnameseLanguage: isVietnameseLanguage ?? this.isVietnameseLanguage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
