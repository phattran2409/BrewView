import 'package:briewview/features/post/model/post_media.dart';
import 'package:equatable/equatable.dart';

class PostModel extends Equatable {
  final String postId;
  final String userId;
  final UserBasicDto user;
  final String? cafeId;
  final CafeBasicDto? cafe;
  final String? title;
  final String content;
  final bool isVisible;
  final int likeCount;
  final int commentCount;
  final bool isLikedByCurrentUser;
  final DateTime createdAt;
  final String createdById;
  final UserBasicDto? createdBy;
  final DateTime? updatedAt;
  final String? updatedById;
  final UserBasicDto? updatedBy;
  final DateTime? deletedAt;
  final List<PostMedia> medias;
  // Note: Likes và Comments sẽ được handle riêng trong các model khác

  PostModel({
    required this.postId,
    required this.userId,
    required this.user,
    this.cafeId,
    this.cafe,
    this.title,
    required this.content,
    required this.isVisible,
    required this.likeCount,
    required this.commentCount,
    required this.isLikedByCurrentUser,
    required this.createdAt,
    required this.createdById,
    this.createdBy,
    this.updatedAt,
    this.updatedById,
    this.updatedBy,
    this.deletedAt,
    required this.medias,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    // Calculate comment count from comments array if available
    int calculatedCommentCount = json['commentCount'] ?? 0;
    if (json['comments'] is List) {
      calculatedCommentCount = (json['comments'] as List).length;
    }

    return PostModel(
      postId: json['postId']?.toString() ?? '',
      userId:
          json['userId']?.toString() ?? json['createdById']?.toString() ?? json['createdBy']?.toString() ?? '',
      user:
          json['user'] != null
              ? UserBasicDto.fromJson(json['user'])
              : UserBasicDto(
                userId:
                    json['userId']?.toString() ??
                    json['createdById']?.toString() ??
                    json['createdBy']?.toString() ??
                    '',
                fullName: json['user']?['fullName']?.toString() ?? '',
                avatarUrl: json['user']?['avatarUrl']?.toString(),
              ),
      cafeId: json['cafeId']?.toString(),
      cafe: json['cafe'] != null ? CafeBasicDto.fromJson(json['cafe']) : null,
      title: json['title']?.toString(),
      content: json['content']?.toString() ?? '',
      isVisible: json['isVisible'] ?? true,
      likeCount: json['likeCount'] ?? 0,
      commentCount: calculatedCommentCount,
      isLikedByCurrentUser: json['isLikedByCurrentUser'] ?? false,
      createdAt:
          DateTime.tryParse(
            json['createdAt']?.toString() ??
                json['updatedAt']?.toString() ??
                DateTime.now().toIso8601String(),
          ) ??
          DateTime.now(),
      createdById:
          json['createdById']?.toString() ?? json['userId']?.toString() ?? json['createdBy']?.toString() ?? '',
      createdBy:
          json['createdBy'] != null && json['createdBy'] is Map<String, dynamic>
              ? UserBasicDto.fromJson(json['createdBy'])
              : null,
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.tryParse(json['updatedAt'].toString())
              : null,
      updatedById: json['updatedById']?.toString(),
      updatedBy:
          json['updatedBy'] != null && json['updatedBy'] is Map<String, dynamic>
              ? UserBasicDto.fromJson(json['updatedBy'])
              : null,
      deletedAt:
          json['deletedAt'] != null
              ? DateTime.tryParse(json['deletedAt'].toString())
              : null,
      medias:
          (json['medias'] as List<dynamic>? ?? [])
              .map((e) => PostMedia.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'userId': userId,
      'user': {
        'userId': user.userId,
        'fullName': user.fullName,
        'avatarUrl': user.avatarUrl,
      },
      if (cafeId != null) 'cafeId': cafeId,
      if (cafe != null)
        'cafe': {
          'cafeId': cafe!.cafeId,
          'name': cafe!.name,
          'address': cafe!.address,
        },
      'title': title,
      'content': content,
      'isVisible': isVisible,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'isLikedByCurrentUser': isLikedByCurrentUser,
      'createdAt': createdAt.toIso8601String(),
      'createdById': createdById,
      if (createdBy != null)
        'createdBy': {
          'userId': createdBy!.userId,
          'fullName': createdBy!.fullName,
          'avatarUrl': createdBy!.avatarUrl,
        },
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (updatedById != null) 'updatedById': updatedById,
      if (updatedBy != null)
        'updatedBy': {
          'userId': updatedBy!.userId,
          'fullName': updatedBy!.fullName,
          'avatarUrl': updatedBy!.avatarUrl,
        },
      if (deletedAt != null) 'deletedAt': deletedAt!.toIso8601String(),
      'medias': medias.map((m) => m.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
    postId,
    userId,
    user,
    cafeId,
    cafe,
    title,
    content,
    isVisible,
    likeCount,
    commentCount,
    isLikedByCurrentUser,
    createdAt,
    createdById,
    createdBy,
    updatedAt,
    updatedById,
    updatedBy,
    deletedAt,
    medias,
  ];
}

class UserBasicDto {
  final String userId;
  final String fullName;
  final String? avatarUrl;

  UserBasicDto({required this.userId, required this.fullName, this.avatarUrl});

  factory UserBasicDto.fromJson(Map<String, dynamic> json) {
    return UserBasicDto(
      userId: json['userId']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      avatarUrl: json['avatarUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'userId': userId, 'fullName': fullName, 'avatarUrl': avatarUrl};
  }
}

class CafeBasicDto {
  final String cafeId;
  final String name;
  final String address;

  CafeBasicDto({
    required this.cafeId,
    required this.name,
    required this.address,
  });

  factory CafeBasicDto.fromJson(Map<String, dynamic> json) {
    return CafeBasicDto(
      cafeId: json['cafeId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
    );
  }
}
