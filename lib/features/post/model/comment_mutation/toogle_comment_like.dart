class ToogleCommentLike {
  final String commentId;
  final String userId;
  final bool? isLiked;
  final int? commentTotalLikes;

  ToogleCommentLike({
    required this.commentId,
    required this.userId,
    this.isLiked,
    this.commentTotalLikes,
  });

  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'userId': userId,
      if (isLiked != null) 'isLiked': isLiked,
      if (commentTotalLikes != null) 'commentTotalLikes': commentTotalLikes,
    };
  }

  factory ToogleCommentLike.fromJson(Map<String, dynamic> json) {
    return ToogleCommentLike(
      commentId: json['commentId'],
      userId: json['userId'],
      isLiked: json['isLiked'] as bool?,
      commentTotalLikes: json['commentTotalLikes'] as int?,
    );
  }
}