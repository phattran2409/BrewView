import 'package:briewview/features/post/model/comment_mutation/post_comment_like.dart';
import 'package:briewview/features/post/model/post_model.dart';
import 'package:equatable/equatable.dart';

class PostComment extends Equatable {
  final String commentId;
  final String postId;
  final PostModel? post;
  final String userId;
  final bool? isLikedByCurrentUser;
  final UserBasicDto? user;
  final String? parentCommentId;
  final PostComment? parentComment;
  final String content;
  final int likeCount;
  final int replyCount;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final List<PostComment> replies;
  // final List<CommentLikeModel> likes;
  final String? userName;
  final String? avatarUser;

  const PostComment({
    required this.commentId,
    required this.postId,
    required this.userId,
    required this.content,
    required this.likeCount,
    required this.replyCount,
    required this.createdAt,
    required this.replies,
    // required this.likes,
    this.isLikedByCurrentUser,
    this.post,
    this.parentCommentId,
    this.parentComment,
    this.user,
    this.updatedAt,
    this.deletedAt,
    this.userName,
    this.avatarUser,
  });

  factory PostComment.fromJson(Map<String, dynamic> json) {
    return PostComment(
      commentId: json['commentId'] as String,
      postId: json['postId'] as String,
      userId: json['userId'] as String,
      content: json['content'] as String,
      likeCount: json['likeCount'] as int,
      replyCount: json['replyCount'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt'] as String) : null,
      replies: (json['replies'] as List<dynamic>? ?? [])
          .map((reply) => PostComment.fromJson(reply))
          .toList(),
      // likes: (json['likes'] as List<dynamic>? ?? [])
      //     .map((like) => CommentLikeModel.fromJson(like))
      //     .toList(),
      post: json['post'] != null ? PostModel.fromJson(json['post']) : null,
      parentCommentId: json['parentCommentId'] as String?,
      parentComment: json['parentComment'] != null
          ? PostComment.fromJson(json['parentComment'])
          : null,
      user: json['user'] != null ? UserBasicDto.fromJson(json['user']) : null,
      userName: json['userName'] as String?,
      avatarUser: json['avatarUser'] as String?,
      isLikedByCurrentUser: json['isLikedByCurrentUser'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'postId': postId,
      'userId': userId,
      'content': content,
      'likeCount': likeCount,
      'replyCount': replyCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'replies': replies.map((reply) => reply.toJson()).toList(),
      // 'likes': likes.map((like) => like.toJson()).toList(),
      'post': post?.toJson(),
      'parentCommentId': parentCommentId,
      'parentComment': parentComment?.toJson(),
      'user': user?.toJson(),
      'userName': userName,
      'avatarUser': avatarUser,
      'isLikedByCurrentUser': isLikedByCurrentUser,
    };
  }

  @override
  List<Object?> get props => [
        commentId,
        postId,
        userId,
        content,
        likeCount,
        replyCount,
        createdAt,
        updatedAt,
        deletedAt,
        replies,
        // likes,
        post,
        parentCommentId,
        parentComment,
        user,
        userName,
        avatarUser,
        isLikedByCurrentUser,
      ];

  PostComment copyWith({
    String? commentId,
    String? postId,
    PostModel? post,
    String? userId,
    bool? isLikedByCurrentUser,
    UserBasicDto? user,
    String? parentCommentId,
    PostComment? parentComment,
    String? content,
    int? likeCount,
    int? replyCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    List<PostComment>? replies,
    // List<CommentLikeModel>? likes,
    String? userName,
    String? avatarUser,
  }) {
    return PostComment(
      commentId: commentId ?? this.commentId,
      postId: postId ?? this.postId,
      post: post ?? this.post,
      userId: userId ?? this.userId,
      isLikedByCurrentUser: isLikedByCurrentUser ?? this.isLikedByCurrentUser,
      user: user ?? this.user,
      parentCommentId: parentCommentId ?? this.parentCommentId,
      parentComment: parentComment ?? this.parentComment,
      content: content ?? this.content,
      likeCount: likeCount ?? this.likeCount,
      replyCount: replyCount ?? this.replyCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      replies: replies ?? this.replies,
      // likes: likes ?? this.likes,
      userName: userName ?? this.userName,
      avatarUser: avatarUser ?? this.avatarUser,
    );
  }

}