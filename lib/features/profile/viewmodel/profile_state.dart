import 'package:briewview/features/user_management/model/user_model.dart';

import '../model/profile.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel profile;

  ProfileLoaded(this.profile);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

class ProfileUpdating extends ProfileState {
  final UserModel profile;

  ProfileUpdating(this.profile);
}

class ProfileUpdated extends ProfileState {
  final UserModel profile;

  ProfileUpdated(this.profile);
}

class LanguageToggled extends ProfileState {
  final bool isVietnamese;

  LanguageToggled(this.isVietnamese);
}

class LoggingOut extends ProfileState {}

class LoggedOut extends ProfileState {}

class DeletingAccount extends ProfileState {}

class AccountDeleted extends ProfileState {}

