import 'package:briewview/features/post/model/post_media.dart';

class PostCreate {
  final String userId;
  final String? cafeId;
  final String title;
  final String content;
  final List<PostMedia>? mediaFiles;

  PostCreate({
    required this.userId,
    this.cafeId,
    required this.title,
    required this.content,
    this.mediaFiles,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      if (cafeId != null) 'cafeId': cafeId,
      'title': title,
      'content': content,
      if (mediaFiles != null) 'mediaFiles': mediaFiles!.map((m) => m.toJson()).toList(),
    };
  }
  
}



class PostUpdate {
  final String postId;
  final String? cafeId;
  final String? title;
  final String? content;
  final bool? isVisible;
  final DateTime? updatedAt;

  PostUpdate({
    required this.postId,
    this.cafeId,
    this.title,
    this.content,
    this.isVisible,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      if (cafeId != null) 'cafeId': cafeId,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (isVisible != null) 'isVisible': isVisible,
    };
  }
  factory PostUpdate.fromJson(Map<String, dynamic> json) {
    return PostUpdate(
      postId: json['postId'],
      cafeId: json['cafeId'],
      title: json['title'],
      content: json['content'],
      isVisible: json['isVisible'],
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}
