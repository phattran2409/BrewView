import 'package:briewview/core/errors/failures.dart';
import 'package:briewview/features/post/model/post_model.dart';
import 'package:briewview/features/post/model/post_mutation.dart';
import 'package:briewview/features/post/model/comment_mutation/post_comment.dart';
import 'package:briewview/features/post/model/comment_mutation/post_comment_mutation.dart';
import 'package:briewview/features/post/model/comment_mutation/toogle_comment_like.dart';
import 'package:briewview/features/post/model/comment_mutation/toogle_post_like.dart';
import 'package:dartz/dartz.dart';
import 'dart:io';

abstract class PostRepository {
  // Get posts with pagination and filters
  Future<Either<Failure, List<PostModel>>> getPosts({
    int pageNumber = 1,
    int pageSize = 10,
    String? searchTerm,
    String? sortBy,
    String? sortDirection,
  });
  
  // Get post by ID
  Future<Either<Failure, PostModel>> getPostById(String postId);
  
  // Create post
  Future<Either<Failure, PostModel>> createPost(
    PostCreate request, 
    List<File>? mediaFiles
  );
  
  // Update post
  Future<Either<Failure, PostModel>> updatePost(PostUpdate request);
  
  // Delete post
  Future<Either<Failure, void>> deletePost(String postId);
  
  // Like/Unlike post
  Future<Either<Failure, TogglePostLike>> togglePostLike(String postId);
  
  // Get post comments
  Future<Either<Failure, List<PostComment>>> getPostComments({
    required String postId,
  });
  
  // Create comment
  Future<Either<Failure, PostComment>> createComment(CreateComment request);
  
  // Update comment
  Future<Either<Failure, PostComment>> updateComment(UpdateComment request);
  
  // Delete comment
  Future<Either<Failure, void>> deleteComment(String commentId);
  
  // Like/Unlike comment
  Future<Either<Failure, ToogleCommentLike>> toggleCommentLike(String commentId);
}

