import 'package:briewview/core/network/user_storage_services.dart';
import 'package:briewview/features/user_management/model/user_model.dart';
import 'package:injectable/injectable.dart';
import '../model/profile_model.dart';

@singleton
class ProfileService {
  final UserStorageServices _userStorageServices;
  ProfileService(this._userStorageServices);
  // Mock data for demonstration
  // In real app, this would make HTTP calls to API
  Future<UserModel> getCurrentProfile() async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
   
     final userData = await _userStorageServices.getCurrentUser();
  
     return userData ?? UserModel(id: '', name: '', email: '', profilePicture: '', role: '', identityId: '');
  } 

  Future<UserModel> updateProfile(UserModel user) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    return user;
  }

  Future<void> updateLanguagePreference(bool isVietnamese) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    // In real app, this would update language preference in backend
  }


  Future<void> deleteAccount() async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    // In real app, this would call delete account API
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

