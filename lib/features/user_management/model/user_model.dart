import 'user.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends User { 
  UserModel({
    required String id,
    required String name,
    required String email,
    String? phoneNumber,
    String? avatarUrl,
  }) : super(
          id: id,
          name: name,
          email: email,
          phoneNumber: phoneNumber,
          avatarUrl: avatarUrl,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      avatarUrl: avatarUrl,
    );
  } 
}
