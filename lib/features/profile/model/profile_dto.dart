class ProfileDTO {
  final int age;
  final String? gender;
  final String phoneNumber;
  final String provinceName;

  ProfileDTO({
    required this.age,
    this.gender,
    required this.phoneNumber,
    required this.provinceName,
  });
  factory ProfileDTO.fromJson(Map<String, dynamic> json) {
    return ProfileDTO(
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '', 
      provinceName: json['provinceName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'age': age,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'provinceName': provinceName,
    };
  }
}
