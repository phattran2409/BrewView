import 'package:equatable/equatable.dart';
import 'package:briewview/features/post/model/post_model.dart';
import 'package:briewview/features/post/model/comment_mutation/toogle_post_like.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object?> get props => [];
}

// Initial state
class PostInitialState extends PostState {
  const PostInitialState();
}

// Loading states
class PostLoadingState extends PostState {
  const PostLoadingState();
}

class PostListLoadingState extends PostState {
  final List<PostModel> currentPosts;
  final bool isRefresh;

  const PostListLoadingState({
    this.currentPosts = const [],
    this.isRefresh = false,
  });

  @override
  List<Object> get props => [currentPosts, isRefresh];
}

class PostDetailLoadingState extends PostState {
  const PostDetailLoadingState();
}

class PostCreateLoadingState extends PostState {
  const PostCreateLoadingState();
}

class PostUpdateLoadingState extends PostState {
  const PostUpdateLoadingState();
}

class PostDeleteLoadingState extends PostState {
  const PostDeleteLoadingState();
}

class PostLikeLoadingState extends PostState {
  const PostLikeLoadingState();
}


// Success states
class PostListSuccessState extends PostState {
  final List<PostModel> posts;
  final int totalCount;
  final int currentPage;
  final int pageSize;
  final bool hasMore;
  final bool isRefresh;

  const PostListSuccessState({
    required this.posts,
    required this.totalCount,
    required this.currentPage,
    required this.pageSize,
    required this.hasMore,
    this.isRefresh = false,
  });

  @override
  List<Object> get props => [posts, totalCount, currentPage, pageSize, hasMore, isRefresh];
}

class PostDetailSuccessState extends PostState {
  final PostModel post;

  const PostDetailSuccessState(this.post);

  @override
  List<Object> get props => [post];
}

class PostCreateSuccessState extends PostState {
  final PostModel post;

  const PostCreateSuccessState(this.post);

  @override
  List<Object> get props => [post];
}

class PostUpdateSuccessState extends PostState {
  final PostModel post;

  const PostUpdateSuccessState(this.post);

  @override
  List<Object> get props => [post];
}

class PostDeleteSuccessState extends PostState {
  final String postId;

  const PostDeleteSuccessState(this.postId);

  @override
  List<Object> get props => [postId];
}

class PostLikeSuccessState extends PostState {
  final String postId;
  final bool isLiked;

  const PostLikeSuccessState({
    required this.postId,
    required this.isLiked,
  });

  @override
  List<Object> get props => [postId, isLiked];
}


class PostToggleLikeSuccessState extends PostState {
  final TogglePostLike toggleResult;

  const PostToggleLikeSuccessState(this.toggleResult);

  @override
  List<Object> get props => [toggleResult];
}


// Error states
class PostErrorState extends PostState {
  final String message;

  const PostErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class PostListErrorState extends PostState {
  final String message;
  final List<PostModel> currentPosts;

  const PostListErrorState({
    required this.message,
    this.currentPosts = const [],
  });

  @override
  List<Object> get props => [message, currentPosts];
}

class PostDetailErrorState extends PostState {
  final String message;

  const PostDetailErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class PostCreateErrorState extends PostState {
  final String message;

  const PostCreateErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class PostUpdateErrorState extends PostState {
  final String message;

  const PostUpdateErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class PostDeleteErrorState extends PostState {
  final String message;

  const PostDeleteErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class PostLikeErrorState extends PostState {
  final String message;

  const PostLikeErrorState(this.message);

  @override
  List<Object> get props => [message];
}


class PostToggleLikeErrorState extends PostState {
  final String message;

  const PostToggleLikeErrorState(this.message);

  @override
  List<Object> get props => [message];
}


