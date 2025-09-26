import 'package:briewview/core/network/user_storage_services.dart';
import 'package:briewview/features/auth/services/auth_services.dart';
import 'package:briewview/features/profile/model/profile_dto.dart';
import 'package:briewview/features/profile/model/profile_model.dart';
import 'package:briewview/features/user_management/model/user_model.dart';
import 'package:injectable/injectable.dart';
import '../services/profile_service.dart';
import 'profile_repository.dart';

@Singleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileService _profileService;
  final UserStorageServices _userStorageServices;
  final AuthApi _authApi;

  ProfileRepositoryImpl(
    this._profileService,
    this._authApi,
    this._userStorageServices,
  );

  @override
  Future<UserModel> getCurrentProfile() async {
    try {
      final profileModel = await _profileService.getCurrentProfile();
      return profileModel;
    } catch (e) {
      throw Exception('Failed to get current profile: $e');
    }
  }

  @override
  Future<UserModel> loadFullProfile() async {
    try {
      final dataUser = await _userStorageServices.getCurrentUser();
      if (dataUser?.id == null || dataUser!.id.isEmpty) {
        throw Exception('User ID is null or empty');
      }
      final profileModel = await _authApi.getCurrentUser(dataUser.id);
      if (profileModel == null) {
        throw Exception('No profile data found');
      }

      final dataProfile = profileModel['userJson'] as Map<String, dynamic>?;
      if (dataProfile == null) {  
        throw Exception('User JSON data is null');
      }
      print('Loaded profile data: ${dataProfile}'); 

      final resultProfileModel = UserModel.fromJson(dataProfile);
      print('Loaded full profile: ${resultProfileModel}');
      return resultProfileModel;
    } catch (e) {
      throw Exception('Failed to load profile: $e');
    }
  }

  @override
  Future<Map<String,dynamic>> updateProfile(ProfileDTO user) async {
    try {
      final dataUser = await _userStorageServices.getCurrentUser();
      if (dataUser == null) {
        throw Exception('Current user data is null');
      }
      final profileModel = user;
      print('Profile model to update: ${profileModel.toJson()}');
      final updatedProfileModel = await _profileService.updateProfile(
        profileModel,
      );
      print(
        'Updated profile model Repository: ${updatedProfileModel.toJson()}',
      );
      final dataResult = updatedProfileModel.toJson();
      return dataResult;
    } catch (e) {
      throw Exception('Failed to update profile Repository: $e');
    }
  }

  @override
  Future<void> updateLanguagePreference(bool isVietnamese) async {
    try {
      await _profileService.updateLanguagePreference(isVietnamese);
    } catch (e) {
      throw Exception('Failed to update language preference: $e');
    }
  }

  @override
  Future<void> deleteAccount() {
    // TODO: implement deleteAccount
    throw UnimplementedError();
  }

  @override
  Future<bool> updateProfilePicture(String imagePath) async {
    try {
      final result = await _profileService.updateProfilePicture(imagePath);
      print('Update profile picture result: $result');
      if (result != null && result['isSuccess'] == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Failed to update profile picture: $e');
    }
  }
}
