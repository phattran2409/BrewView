class Profile {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? profilePicture;
  final String? bio;
  final bool isVietnameseLanguage;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Profile({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.profilePicture,
    this.bio,
    this.isVietnameseLanguage = true,
    this.createdAt,
    this.updatedAt,
  });

  Profile copyWith({
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
    return Profile(
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

  @override
  String toString() {
    return 'Profile(id: $id, name: $name, email: $email, phoneNumber: $phoneNumber, profilePicture: $profilePicture, bio: $bio, isVietnameseLanguage: $isVietnameseLanguage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Profile &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.profilePicture == profilePicture &&
        other.bio == bio &&
        other.isVietnameseLanguage == isVietnameseLanguage;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        phoneNumber.hashCode ^
        profilePicture.hashCode ^
        bio.hashCode ^
        isVietnameseLanguage.hashCode;
  }
}

