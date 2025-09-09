import 'package:briewview/features/user_management/model/user_model.dart';

abstract class ProfileRepository {
  Future<UserModel> getCurrentProfile();
  Future<UserModel> updateProfile(UserModel user);
  Future<void> updateLanguagePreference(bool isVietnamese);
  // Future<void> logout();
  Future<void> deleteAccount();
}
