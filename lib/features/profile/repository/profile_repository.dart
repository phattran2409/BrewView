import 'package:briewview/features/profile/model/profile_dto.dart';
import 'package:briewview/features/user_management/model/user_model.dart';

abstract class ProfileRepository {
  Future<UserModel> getCurrentProfile();
  Future<Map<String,dynamic>> updateProfile(ProfileDTO user);
  Future<bool> updateProfilePicture(String imagePath);
  Future<void> updateLanguagePreference(bool isVietnamese);
  Future<UserModel> loadFullProfile();
  // Future<void> logout();
  Future<void> deleteAccount();
}
