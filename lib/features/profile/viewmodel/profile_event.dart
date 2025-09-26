import 'package:briewview/features/profile/model/profile_dto.dart';
import 'package:briewview/features/user_management/model/user_model.dart';

abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class LoadFullProfile extends ProfileEvent {}
 
class UpdateProfile extends ProfileEvent {
   final ProfileDTO profileDTO;
  UpdateProfile({
    required this.profileDTO, 
  });
}

class ShowMoreInfo extends ProfileEvent {
  final UserModel profile;  
  ShowMoreInfo({
    required this.profile,
  });
}

class ToggleLanguage extends ProfileEvent {
  final bool isVietnamese;

  ToggleLanguage(this.isVietnamese);
}

class Logout extends ProfileEvent {}

class DeleteAccount extends ProfileEvent {}

class UpdateProfilePicture extends ProfileEvent {
  final String imagePath;

  UpdateProfilePicture(this.imagePath);
}

