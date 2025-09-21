import 'dart:io';
import 'dart:typed_data';
import 'package:briewview/core/utils/FileUpload.dart';
import 'package:briewview/features/profile/model/profile_dto.dart';
import 'package:dio/dio.dart';
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
  final Dio _dio;

  ProfileService(this._userStorageServices, this._dio)
    : _httpClient = _createHttpClient();

  // ✅ Tạo HttpClient riêng với SSL bypass
  static HttpClient _createHttpClient() {
    final client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  }

  Future<UserModel> getCurrentProfile() async {
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

  Future<ProfileDTO> updateProfile(ProfileDTO user) async {
    try {
      final dataUser = await _userStorageServices.getCurrentUser();
      if (dataUser?.id == null || dataUser!.id.isEmpty) {
        throw Exception('User ID is null or empty');
      }

      print('Update data: ${user.toJson()}');
      final result = await _dio.put(
        AppConstants.getUpdateUserProfile(dataUser.id),
        data: {
          'age': user.age,
          'gender': user.gender,
          'phoneNumber': user.phoneNumber,
          'provinceName': user.provinceName,
        },
      );

      final data = result.data as Map<String, dynamic>;
  
      return data['isSuccess'] == true
          ? ProfileDTO.fromJson(data['data'])
          : throw Exception('Failed to update profile: ${data['message']}');
          
    } catch (e) {
      throw Exception('Failed to update profile Services : $e');
    }
  }

  Future<void> updateLanguagePreference(bool isVietnamese) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> deleteAccount() async {
    await Future.delayed(const Duration(seconds: 2));
  }

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

      final fileSize = await file.length();
      final fileName = path.basename(imagePath);

      final boundary =
          '----WebKitFormBoundary${DateTime.now().millisecondsSinceEpoch}';

      final fileBytes = await file.readAsBytes();

      final multipartBody = HandleFileUpload.createMultipartBody(
        boundary: boundary,
        fileName: fileName,
        fileBytes: fileBytes,
        mimeType: HandleFileUpload.getMimeType(imagePath) ?? '',
      );

      final uri = Uri.parse(
        '${AppConstants.apiBaseUrl}/api/users/avatar/${dataUser.id}',
      );

      final request = await _httpClient.postUrl(uri);

      request.headers.set('accept', '*/*');
      request.headers.set(
        'Content-Type',
        'multipart/form-data; boundary=$boundary',
      );
      request.headers.set('Content-Length', multipartBody.length.toString());

      if (dataUser.accessToken != null && dataUser.accessToken!.isNotEmpty) {
        request.headers.set('Authorization', 'Bearer ${dataUser.accessToken}');
      }

      request.add(multipartBody);

      final response = await request.close();
      final responseBody =
          await response.transform(const SystemEncoding().decoder).join();

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
      throw Exception('Failed to update profile picture: $e');
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
