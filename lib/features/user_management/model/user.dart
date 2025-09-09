class User {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? profilePicture;
  final String? accessToken;
  final String? refreshToken;
  User({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.profilePicture,
    this.accessToken,
    this.refreshToken,
  });

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, phoneNumber: $phoneNumber, profilePicture: $profilePicture)';
  }
}
