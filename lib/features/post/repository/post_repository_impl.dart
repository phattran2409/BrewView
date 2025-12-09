import 'package:briewview/core/errors/failures.dart';
import 'package:briewview/features/post/model/post_model.dart';
import 'package:briewview/features/post/model/post_mutation.dart';
import 'package:briewview/features/post/model/comment_mutation/post_comment.dart';
import 'package:briewview/features/post/model/comment_mutation/post_comment_mutation.dart';
import 'package:briewview/features/post/model/comment_mutation/toogle_comment_like.dart';
import 'package:briewview/features/post/model/comment_mutation/toogle_post_like.dart';
import 'package:briewview/features/post/repository/post_repository.dart';
import 'package:briewview/features/post/services/post_service.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'dart:io';

@Singleton(as: PostRepository)
class PostRepositoryImpl implements PostRepository {
  final PostService postService;
  PostRepositoryImpl(this.postService);

  @override
  Future<Either<Failure, List<PostModel>>> getPosts({
    int pageNumber = 1,
    int pageSize = 10,
    String? searchTerm,
    String? sortBy,
    String? sortDirection,
  }) async {
    try {
      final result = await postService.getPosts(
        pageNumber: pageNumber,
        pageSize: pageSize,
        searchTerm: searchTerm,
        sortBy: sortBy,
        sortDirection: sortDirection,
      );
      
      final posts = result['posts'] as List<PostModel>;
      return Right(posts);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PostModel>> getPostById(String postId) async {
    try {
      final result = await postService.getPostById(postId);
      if (result == null) {
        return Left(ServerFailure('Post not found'));
      }
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PostModel>> createPost(
    PostCreate request, 
    List<File>? mediaFiles
  ) async {
    try {
      print("📦 PostRepository: Creating post with request: ${request.toJson()}");
      final result = await postService.createPost(request, mediaFiles: mediaFiles);
      print("📦 PostRepository: Post created successfully: ${result.postId}");
      return Right(result);
    } catch (e) {
      print("❌ PostRepository: Error creating post: $e");
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PostModel>> updatePost(PostUpdate request) async {
    try {
      final result = await postService.updatePost(request);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePost(String postId) async {
    try {
      await postService.deletePost(postId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TogglePostLike>> togglePostLike(String postId) async {
    try {
      final result = await postService.togglePostLike(postId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PostComment>>> getPostComments({
    required String postId,
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    try {
      final result = await postService.getPostComments(
        postId: postId,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PostComment>> createComment(CreateComment request) async {
    try {
      final result = await postService.createComment(request);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PostComment>> updateComment(UpdateComment request) async {
    try {
      final result = await postService.updateComment(request);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteComment(String commentId) async {
    try {
      await postService.deleteComment(commentId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ToogleCommentLike>> toggleCommentLike(String commentId) async {
    try {
      print('🔍 PostRepositoryImpl: Calling toggleCommentLike for commentId: $commentId');
      final result = await postService.toggleCommentLike(commentId);
      print('🔍 PostRepositoryImpl: Got result - commentId: ${result.commentId}, isLiked: ${result.isLiked}');
      return Right(result);
    } catch (e) {
      print('❌ PostRepositoryImpl: Error - $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}

