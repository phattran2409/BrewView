import 'package:json_annotation/json_annotation.dart';
import 'profile.dart';

part 'profile_model.g.dart';

@JsonSerializable()
class ProfileModel {
  final String? id;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? profilePicture;
  final String? bio;
  final String? provinceName; 
  final int?  age;  
  final String? gender;
  
  @JsonKey(name: 'is_vietnamese_language')
  final bool isVietnameseLanguage;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  ProfileModel({
     this.id,
     this.name,
     this.email,
    this.phoneNumber,
    this.profilePicture,
    this.bio,
    this.isVietnameseLanguage = true,
    this.createdAt,
    this.updatedAt,
    this.provinceName,
    this.age,
    this.gender,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);

  factory ProfileModel.fromEntity(Profile profile) {
    return ProfileModel(
      id: profile.id,
      name: profile.name,
      email: profile.email,
      phoneNumber: profile.phoneNumber,
      profilePicture: profile.profilePicture,
      bio: profile.bio,
      isVietnameseLanguage: profile.isVietnameseLanguage,
      createdAt: profile.createdAt,
      updatedAt: profile.updatedAt,
    );
  }

  Profile toEntity() {
    return Profile(
      id: id ?? '',
      name: name ?? '',
      email: email ?? '',
      phoneNumber: phoneNumber ?? '',
      profilePicture: profilePicture ?? '',
      bio: bio ?? '',
      isVietnameseLanguage: isVietnameseLanguage,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

