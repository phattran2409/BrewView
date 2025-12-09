import 'package:equatable/equatable.dart';
import 'package:briewview/features/post/model/comment_mutation/post_comment.dart';
import 'package:briewview/features/post/model/comment_mutation/toogle_comment_like.dart';

abstract class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object?> get props => [];
}

// Initial state
class CommentInitialState extends CommentState {
  const CommentInitialState();
}

// Loading states
class CommentLoadingState extends CommentState {
  const CommentLoadingState();
}

// Success states
class CommentToggleLikeSuccessState extends CommentState {
  final ToogleCommentLike toggleResult;

  const CommentToggleLikeSuccessState(this.toggleResult);

  @override
  List<Object> get props => [toggleResult];
}

class CommentUpdateSuccessState extends CommentState {
  final PostComment comment;

  const CommentUpdateSuccessState(this.comment);

  @override
  List<Object> get props => [comment];
}

class CommentDeleteSuccessState extends CommentState {
  final String commentId;

  const CommentDeleteSuccessState(this.commentId);

  @override
  List<Object> get props => [commentId];
}

class CommentCreateSuccessState extends CommentState {
  final PostComment comment;

  const CommentCreateSuccessState(this.comment);

  @override
  List<Object> get props => [comment];
}

// Error states
class CommentErrorState extends CommentState {
  final String message;

  const CommentErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class CommentToggleLikeErrorState extends CommentState {
  final String message;

  const CommentToggleLikeErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class CommentUpdateErrorState extends CommentState {
  final String message;

  const CommentUpdateErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class CommentDeleteErrorState extends CommentState {
  final String message;

  const CommentDeleteErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class CommentCreateErrorState extends CommentState {
  final String message;

  const CommentCreateErrorState(this.message);

  @override
  List<Object> get props => [message];
}
