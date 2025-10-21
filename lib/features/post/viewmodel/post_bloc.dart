import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:briewview/core/errors/failures.dart';
import 'package:briewview/features/post/model/post_model.dart';
import 'package:briewview/features/post/repository/post_repository.dart';
import 'package:briewview/features/post/viewmodel/post_event.dart';
import 'package:briewview/features/post/viewmodel/post_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;

  PostBloc({required this.postRepository}) : super(const PostInitialState()) {
    on<GetPostsEvent>(_onGetPosts);
    on<GetPostByIdEvent>(_onGetPostById);
    on<CreatePostEvent>(_onCreatePost);
    on<UpdatePostEvent>(_onUpdatePost);
    on<DeletePostEvent>(_onDeletePost);
    on<TogglePostLikeEvent>(_onTogglePostLike);
    on<ResetPostStateEvent>(_onResetPostState);
  }

  Future<void> _onGetPosts(GetPostsEvent event, Emitter<PostState> emit) async {
    try {
      if (event.isRefresh) {
        emit(PostListLoadingState(isRefresh: true));
      } else {
        final currentState = state;
        List<PostModel> currentPosts = [];
        if (currentState is PostListSuccessState) {
          currentPosts = currentState.posts;
        }
        emit(PostListLoadingState(currentPosts: currentPosts));
      }

      final result = await postRepository.getPosts(
        pageNumber: event.pageNumber,
        pageSize: event.pageSize,
        searchTerm: event.searchTerm,
        sortBy: event.sortBy,
        sortDirection: event.sortDirection,
      );

      result.fold(
        (failure) {
          final currentState = state;
          List<PostModel> currentPosts = [];
          if (currentState is PostListLoadingState) {
            currentPosts = currentState.currentPosts;
          }
          emit(
            PostListErrorState(
              message: _mapFailureToMessage(failure),
              currentPosts: currentPosts,
            ),
          );
        },
        (posts) {
          final currentState = state;
          List<PostModel> allPosts = posts;

          if (currentState is PostListLoadingState && !event.isRefresh) {
            allPosts = [...currentState.currentPosts, ...posts];
          }

          final hasMore = posts.length == event.pageSize;

          emit(
            PostListSuccessState(
              posts: allPosts,
              totalCount: allPosts.length,
              currentPage: event.pageNumber,
              pageSize: event.pageSize,
              hasMore: hasMore,
              isRefresh: event.isRefresh,
            ),
          );
        },
      );
    } catch (e) {
      final currentState = state;
      List<PostModel> currentPosts = [];
      if (currentState is PostListLoadingState) {
        currentPosts = currentState.currentPosts;
      }
      emit(
        PostListErrorState(message: e.toString(), currentPosts: currentPosts),
      );
    }
  }

  Future<void> _onGetPostById(
    GetPostByIdEvent event,
    Emitter<PostState> emit,
  ) async {
    try {
      print("🏗️ PostBloc: _onGetPostById called with ID: ${event.postId}");
      emit(const PostDetailLoadingState());
      print("🏗️ PostBloc: Emitted loading state");

      final result = await postRepository.getPostById(event.postId);
      print("🏗️ PostBloc: Repository result received");

      result.fold(
        (failure) {
          print("❌ PostBloc: Failure: ${failure.toString()}");
          emit(PostDetailErrorState(_mapFailureToMessage(failure)));
        },
        (post) {
          print("✅ PostBloc: Success with post: ${post.postId}");
          emit(PostDetailSuccessState(post));
        },
      );
    } catch (e) {
      print("💥 PostBloc: Exception: $e");
      emit(PostDetailErrorState(e.toString()));
    }
  }

  Future<void> _onCreatePost(
    CreatePostEvent event,
    Emitter<PostState> emit,
  ) async {
    try {
      print("🚀 PostBloc: Starting post creation...");
      emit(const PostCreateLoadingState());

      final result = await postRepository.createPost(
        event.request,
        event.mediaFiles,
      );

      result.fold(
        (failure) {
          print("❌ PostBloc: Create post failed: ${failure.toString()}");
          emit(PostCreateErrorState(_mapFailureToMessage(failure)));
        },
        (post) {
          print("✅ PostBloc: Post created successfully: ${post.postId}");
          emit(PostCreateSuccessState(post));
        },
      );
    } catch (e) {
      print("💥 PostBloc: Exception during post creation: $e");
      emit(PostCreateErrorState(e.toString()));
    }
  }

  Future<void> _onUpdatePost(
    UpdatePostEvent event,
    Emitter<PostState> emit,
  ) async {
    try {
      emit(const PostUpdateLoadingState());

      final result = await postRepository.updatePost(event.request);

      result.fold(
        (failure) => emit(PostUpdateErrorState(_mapFailureToMessage(failure))),
        (post) => emit(PostUpdateSuccessState(post)),
      );
    } catch (e) {
      emit(PostUpdateErrorState(e.toString()));
    }
  }

  Future<void> _onDeletePost(
    DeletePostEvent event,
    Emitter<PostState> emit,
  ) async {
    try {
      emit(const PostDeleteLoadingState());

      final result = await postRepository.deletePost(event.postId);

      result.fold(
        (failure) => emit(PostDeleteErrorState(_mapFailureToMessage(failure))),
        (_) => emit(PostDeleteSuccessState(event.postId)),
      );
    } catch (e) {
      emit(PostDeleteErrorState(e.toString()));
    }
  }


  Future<void> _onTogglePostLike(
    TogglePostLikeEvent event,
    Emitter<PostState> emit,
  ) async {
    try {
      emit(const PostLikeLoadingState());

      final result = await postRepository.togglePostLike(event.postId);

      result.fold(
        (failure) =>
            emit(PostToggleLikeErrorState(_mapFailureToMessage(failure))),
        (toggleResult) => emit(PostToggleLikeSuccessState(toggleResult)),
      );
    } catch (e) {
      emit(PostToggleLikeErrorState(e.toString()));
    }
  }


  Future<void> _onResetPostState(
    ResetPostStateEvent event,
    Emitter<PostState> emit,
  ) async {
    emit(const PostInitialState());
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
