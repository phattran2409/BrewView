import 'package:equatable/equatable.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();

  @override
  List<Object?> get props => [];
}

class ToggleCommentLikeEvent extends CommentEvent {
  final String commentId;

  const ToggleCommentLikeEvent(this.commentId);

  @override
  List<Object> get props => [commentId];
}

class UpdateCommentEvent extends CommentEvent {
  final String commentId;
  final String content;

  const UpdateCommentEvent({
    required this.commentId,
    required this.content,
  });

  @override
  List<Object> get props => [commentId, content];
}

class DeleteCommentEvent extends CommentEvent {
  final String commentId;

  const DeleteCommentEvent(this.commentId);

  @override
  List<Object> get props => [commentId];
}

class CreateCommentEvent extends CommentEvent {
  final String postId;
  final String userId;
  final String content;
  final String? parentCommentId;

  const CreateCommentEvent({
    required this.postId,
    required this.userId,
    required this.content,
    this.parentCommentId,
  });

  @override
  List<Object?> get props => [postId, userId, content, parentCommentId];
}
