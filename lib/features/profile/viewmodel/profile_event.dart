abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final String name;
  final String email;
  final String? phoneNumber;
  final String? bio;

  UpdateProfile({
    required this.name,
    required this.email,
    this.phoneNumber,
    this.bio,
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

