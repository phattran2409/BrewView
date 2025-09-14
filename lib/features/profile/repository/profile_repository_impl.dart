import 'package:briewview/features/user_management/model/user_model.dart';
import 'package:injectable/injectable.dart';
import '../services/profile_service.dart';
import 'profile_repository.dart';

@Singleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileService _profileService;

  ProfileRepositoryImpl(this._profileService);

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
  Future<UserModel> updateProfile(UserModel user) async {
    try {
      final profileModel = user;
      final updatedProfileModel = await _profileService.updateProfile(
        profileModel,
      );
      return updatedProfileModel;
    } catch (e) {
      throw Exception('Failed to update profile: $e');
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
