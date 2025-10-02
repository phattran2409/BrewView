import 'package:equatable/equatable.dart';

class Review extends Equatable {
  final String reviewId;
  final String userId;
  final String userName;
  final int  rating;
  final String content;
  final String? userAvatarUrl;
  final DateTime createdAt;
  final List<Medias>? medias;


  const Review({
    required this.reviewId,
    required this.userId,
    required this.userName,
    required this.userAvatarUrl,
    required this.rating,
    required this.content,
    required this.createdAt,
    this.medias,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewId: (json['reviewId'] ?? '').toString(),
      userId: (json['userId'] ?? '').toString(),
      userName:
          (json['userName'] ?? json['user']?['name'] ?? 'User').toString(),
      userAvatarUrl: json['userAvatarUrl'] ?? json['user']?['avatarUrl'],
      rating: json['rating'] as int,
      content: (json['content'] ?? json['comment'] ?? '').toString(),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      medias: (json['medias'] as List<dynamic>?)
          ?.map((media) => Medias.fromJson(media as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reviewId': reviewId,
      'userId': userId,
      'userName': userName,
      'userAvatarUrl': userAvatarUrl,
      'rating': rating,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [reviewId, userId, userName, userAvatarUrl, rating, content, createdAt, medias];
}

class Medias { 
  final String? reviewMediaId;
  final String? url;
  final String? caption;
  final String?   publicId; 
  final String? uploadedAt;
  
  const Medias({
     this.reviewMediaId,
     this.url,
     this.caption,
     this.publicId,
     this.uploadedAt,
  });
   
  factory Medias.fromJson(Map<String, dynamic> json) {
    return Medias(
      reviewMediaId: json['reviewMediaId'] as String?,
      url: json['url'] as String?,
      caption: json['caption'] as String?,
      publicId: json['publicId'] as String?,
      uploadedAt: json['uploadedAt'] as String?,
    );
  }
   
  Map<String, dynamic> toJson() {
    return {
      'reviewMediaId': reviewMediaId,
      'url': url,
      'caption': caption,
      'publicId': publicId,
      'uploadedAt': uploadedAt,
    };
  }
  @override
  List<Object?> get props => [reviewMediaId, url, caption, publicId, uploadedAt];
}