class User {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? avatarUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.avatarUrl,
  });

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, phoneNumber: $phoneNumber, avatarUrl: $avatarUrl)';
  }
}
