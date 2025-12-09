class CreateComment {
  final String postId;
  final String userId;
  final String? parentCommentId;
  final String content;
  final String? name;
  final String? userAvatar;
  final int? likeCount;
  final int? replyCount;
  final DateTime? createdAt;

  CreateComment({
    required this.postId,
    required this.userId,
    required this.content,
    this.parentCommentId,
    this.name,
    this.userAvatar,
    this.likeCount,
    this.replyCount,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      // 'postId': postId,
      'userId': userId,
      'parentCommentId': parentCommentId,
      'content': content,
      // 'name': name,
      // 'userAvatar': userAvatar,
      // 'likeCount': likeCount,
      // 'replyCount': replyCount,
      // 'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory CreateComment.fromJson(Map<String, dynamic> json) {
    return CreateComment(
      postId: json['postId'],
      userId: json['userId'],
      parentCommentId: json['parentCommentId'],
      content: json['content'],
    );
  }
}

class UpdateComment {
  final String commentId;
  final String? content;
  final DateTime? updatedAt;

  UpdateComment({required this.commentId, this.content, this.updatedAt});

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory UpdateComment.fromJson(Map<String, dynamic> json) {
    return UpdateComment(
      commentId: json['commentId'],
      content: json['content'],
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}
