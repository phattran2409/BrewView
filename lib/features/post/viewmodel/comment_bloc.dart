import 'package:briewview/core/errors/failures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:briewview/core/network/failures/failure.dart';
import 'package:briewview/features/post/model/comment_mutation/post_comment.dart';
import 'package:briewview/features/post/model/comment_mutation/post_comment_mutation.dart';
import 'package:briewview/features/post/model/comment_mutation/toogle_comment_like.dart';
import 'package:briewview/features/post/repository/post_repository.dart';
import 'package:briewview/features/post/viewmodel/comment_event.dart';
import 'package:briewview/features/post/viewmodel/comment_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final PostRepository postRepository;

  CommentBloc({required this.postRepository}) : super(const CommentInitialState()) {
    on<ToggleCommentLikeEvent>(_onToggleCommentLike);
    on<UpdateCommentEvent>(_onUpdateComment);
    on<DeleteCommentEvent>(_onDeleteComment);
    on<CreateCommentEvent>(_onCreateComment);
  }

  Future<void> _onToggleCommentLike(
    ToggleCommentLikeEvent event,
    Emitter<CommentState> emit,
  ) async {
    try {
      print('🔍 CommentBloc: Received ToggleCommentLikeEvent for commentId: ${event.commentId}');
      emit(const CommentLoadingState());

      final result = await postRepository.toggleCommentLike(event.commentId);
      print('🔍 CommentBloc: Got result from repository');

      result.fold(
        (failure) {
          print('❌ CommentBloc: Toggle like failed - ${_mapFailureToMessage(failure)}');
          emit(CommentToggleLikeErrorState(_mapFailureToMessage(failure)));
        },
        (toggleResult) {
          print('✅ CommentBloc: Toggle like success!');
          print('🔍 Toggle result - commentId: ${toggleResult.commentId}');
          print('🔍 Toggle result - isLiked: ${toggleResult.isLiked}');
          print('🔍 Toggle result - totalLikes: ${toggleResult.commentTotalLikes}');
          emit(CommentToggleLikeSuccessState(toggleResult));
          print('🔍 CommentBloc: State emitted!');
        },
      );
    } catch (e) {
      print('❌ CommentBloc: Exception - $e');
      emit(CommentToggleLikeErrorState(e.toString()));
    }
  }

  Future<void> _onUpdateComment(
    UpdateCommentEvent event,
    Emitter<CommentState> emit,
  ) async {
    try {
      emit(const CommentLoadingState());

      final request = UpdateComment(
        commentId: event.commentId,
        content: event.content,
      );

      final result = await postRepository.updateComment(request);

      result.fold(
        (failure) =>
            emit(CommentUpdateErrorState(_mapFailureToMessage(failure))),
        (comment) => emit(CommentUpdateSuccessState(comment)),
      );
    } catch (e) {
      emit(CommentUpdateErrorState(e.toString()));
    }
  }

  Future<void> _onDeleteComment(
    DeleteCommentEvent event,
    Emitter<CommentState> emit,
  ) async {
    try {
      emit(const CommentLoadingState());

      final result = await postRepository.deleteComment(event.commentId);

      result.fold(
        (failure) =>
            emit(CommentDeleteErrorState(_mapFailureToMessage(failure))),
        (_) => emit(CommentDeleteSuccessState(event.commentId)),
      );
    } catch (e) {
      emit(CommentDeleteErrorState(e.toString()));
    }
  }

  Future<void> _onCreateComment(
    CreateCommentEvent event,
    Emitter<CommentState> emit,
  ) async {
    try {
      emit(const CommentLoadingState());

      final request = CreateComment(
        postId: event.postId,
        userId: event.userId,
        content: event.content,
        parentCommentId: event.parentCommentId,
      );

      final result = await postRepository.createComment(request);

      result.fold(
        (failure) =>
            emit(CommentCreateErrorState(_mapFailureToMessage(failure))),
        (comment) => emit(CommentCreateSuccessState(comment)),
      );
    } catch (e) {
      emit(CommentCreateErrorState(e.toString()));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error occurred. Please try again.';
      case NetworkFailure:
        return 'Network error occurred. Please check your connection.';
      case CacheFailure:
        return 'Cache error occurred. Please try again.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
