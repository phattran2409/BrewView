class TogglePostLike {
    final String postId;
    final String userId;
    final bool? isLiked;
    final int? postTotalLikes;
    
    TogglePostLike({
        required this.postId,
        required this.userId,
        this.isLiked,
        this.postTotalLikes,
    });

    Map<String, dynamic> toJson() {
        return {
            'postId': postId,
            'userId': userId,
            if (isLiked != null) 'isLiked': isLiked,
            if (postTotalLikes != null) 'postTotalLikes': postTotalLikes,
        };
    }

    factory TogglePostLike.fromJson(Map<String, dynamic> json) {
        return TogglePostLike(
            postId: json['postId'],
            userId: json['userId'],
        );
    }
}