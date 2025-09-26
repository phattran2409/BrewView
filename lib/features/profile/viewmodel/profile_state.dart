import 'package:briewview/features/profile/model/profile_dto.dart';
import 'package:briewview/features/user_management/model/user_model.dart';


abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel profile;

  ProfileLoaded(this.profile);
}

class ShowMoreInfoState extends ProfileState {
  final UserModel profile;

  ShowMoreInfoState(this.profile);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

class ProfileUpdating extends ProfileState {
  final UserModel profile;

  ProfileUpdating(this.profile);
}

//  State when profile is successfully updated
class ProfileUpdated extends ProfileState {
  final ProfileDTO profile;

  ProfileUpdated(this.profile);
}

class LanguageToggled extends ProfileState {
  final bool isVietnamese;

  LanguageToggled(this.isVietnamese);
}

class ProfilePictureUpdatedSuccess extends ProfileState {

}

class LoggingOut extends ProfileState {}

class LoggedOut extends ProfileState {}

class DeletingAccount extends ProfileState {}

class AccountDeleted extends ProfileState {}

class ProfileUpdateDto extends ProfileState {
  final ProfileDTO profileDTO;
  
  ProfileUpdateDto(this.profileDTO);
} 




