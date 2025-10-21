import 'package:briewview/features/post/model/comment_mutation/post_comment.dart';
import 'package:briewview/features/post/model/post_model.dart';
import 'package:equatable/equatable.dart';

class PostLike extends Equatable {
  final String likeId;
  final String commentId;
  final PostComment? comment;
  final String userId;
  final UserBasicDto? user;
  final DateTime createdAt;

  PostLike({
    required this.likeId,
    required this.commentId,
    this.comment,
    required this.userId,
    this.user,
    required this.createdAt,
  });
  
  factory PostLike.fromJson(Map<String, dynamic> json) {
    return PostLike(
      likeId: json['likeId'] as String,
      commentId: json['commentId'] as String,
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      comment: json['comment'] != null
          ? PostComment.fromJson(json['comment'])
          : null,
      user: json['user'] != null ? UserBasicDto.fromJson(json['user']) : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'likeId': likeId,
      'commentId': commentId,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'comment': comment?.toJson(),
      'user': user?.toJson(),
    };
  }

  @override
  List<Object?> get props => [
        likeId,
        commentId,
        userId,
        comment,
        createdAt,
        user,
      ];
}