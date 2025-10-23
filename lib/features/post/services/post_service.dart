import 'package:briewview/core/constants/app_constants.dart';
import 'package:briewview/core/network/user_storage_services.dart';
import 'package:briewview/features/post/model/post_model.dart';
import 'package:briewview/features/post/model/post_mutation.dart';
import 'package:briewview/features/post/model/comment_mutation/post_comment.dart';
import 'package:briewview/features/post/model/comment_mutation/post_comment_mutation.dart';
import 'package:briewview/features/post/model/comment_mutation/toogle_comment_like.dart';
import 'package:briewview/features/post/model/comment_mutation/toogle_post_like.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'dart:io';

@injectable
class PostService {
  final Dio dio;
  final UserStorageServices userStorageServices;
  PostService(this.dio, this.userStorageServices);

  // Get posts with pagination and filters
  Future<Map<String, dynamic>> getPosts({
    int pageNumber = 1,
    int pageSize = 50,
    String? searchTerm,
    String? sortBy,
    String? sortDirection,
  }) async {
    try {
      final endpoint = AppConstants.getPostsEndpoint(
        pageNumber: pageNumber,
        pageSize: pageSize,
      );

      final response = await dio.get(endpoint);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['isSuccess'] == true && data['data'] != null) {
          final postData = data['data'] as Map<String, dynamic>;
          final posts =
              (postData['posts'] as List)
                  .map((postJson) => PostModel.fromJson(postJson))
                  .toList();

          return {
            'isSuccess': true,
            'posts': posts,
            'totalCount': postData['totalCount'] ?? posts.length,
            'currentPage': pageNumber,
            'pageSize': pageSize,
          };
        } else {
          throw Exception(data['message'] ?? 'Failed to load posts');
        }
      } else {
        throw Exception('Failed to load posts');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load posts: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load posts: $e');
    }
  }

  // Get post by ID
  Future<PostModel?> getPostById(String postId) async {
    try {
      final endpoint = AppConstants.getPostByIdEndpoint(postId);
      final response = await dio.get(endpoint);
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['isSuccess'] == true && data['data'] != null) {
          final postData = data['data']['post'] as Map<String, dynamic>;
          try {
            final comments = postData['comments'] as List<dynamic>? ?? [];
            final commentCount = comments.length;
            final modifiedPostData = {
              ...postData,
              'commentCount': commentCount,
            };
            modifiedPostData.remove('comments');
            final post = PostModel.fromJson(modifiedPostData);
            return post;
          } catch (parseError) {
            throw Exception('Failed to parse post data: $parseError');
          }
        }
      }
      return null;
    } on DioException catch (e) {
      throw Exception('Failed to get post: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get post: $e');
    }
  }

  // Create post
  Future<PostModel> createPost(
    PostCreate request, {
    List<File>? mediaFiles,
  }) async {
    try {
      final formData = FormData();

      // Add basic post data
      formData.fields.addAll([
        MapEntry('userId', request.userId),
        MapEntry('title', request.title),
        MapEntry('content', request.content),
      ]);

      if (request.cafeId != null) {
        formData.fields.add(MapEntry('cafeId', request.cafeId!));
      }

      // Add media files
      if (mediaFiles != null && mediaFiles.isNotEmpty) {
        for (int i = 0; i < mediaFiles.length; i++) {
          final file = mediaFiles[i];
          final fileName = file.path.split('/').last;
          final fileExtension = fileName.split('.').last.toLowerCase();

          // Determine media type based on file extension
          String mediaType = 'image';
          if (['mp4', 'mov', 'avi', 'mkv'].contains(fileExtension)) {
            mediaType = 'video';
          }

          formData.files.add(
            MapEntry(
              'mediaFiles',
              MultipartFile.fromFileSync(file.path, filename: fileName),
            ),
          );

          // Add media type and order
          formData.fields.add(MapEntry('mediaTypes[$i]', mediaType));
          formData.fields.add(MapEntry('mediaOrders[$i]', i.toString()));
        }
      }

      final response = await dio.post(
        AppConstants.createPostEndpoint,
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;
        print("✅ Create Post Response Data: $data");
        print("✅ Response Status Code: ${response.statusCode}");

        if (data['isSuccess'] == true && data['data'] != null) {
          print("✅ Parsing post data: ${data['data']}");
          try {
            final post = PostModel.fromJson(data['data']);
            print("✅ Post created successfully: ${post.postId}");
            return post;
          } catch (e) {
            print("❌ Error parsing PostModel: $e");
            throw Exception('Failed to parse post data: $e');
          }
        } else {
          print("❌ Server returned error: ${data['message']}");
          throw Exception(data['message'] ?? 'Failed to create post');
        }
      } else {
        print("❌ HTTP Error: ${response.statusCode}");
        throw Exception('Failed to create post - HTTP ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to create post: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  // Update post
  Future<PostModel> updatePost(PostUpdate request) async {
    try {
      final response = await dio.put(
        AppConstants.getUpdatePostEndpoint(request.postId),
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        print(" Response Data: $data");
        if (data['isSuccess'] == true && data['data'] != null) {
          return PostModel.fromJson(data['data']);
        } else {
          throw Exception(data['message'] ?? 'Failed to update post');
        }
      } else {
        throw Exception('Failed to update post');
      }
    } on DioException catch (e) {
      throw Exception('Failed to update post: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update post: $e');
    }
  }

  // Delete post
  Future<void> deletePost(String postId) async {
    try {
      final currentUser = await userStorageServices.getCurrentUser();
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final response = await dio.delete(
        AppConstants.getDeletePostEndpoint(postId),
        queryParameters: {'userId': currentUser.id},
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete post');
      }
    } on DioException catch (e) {
      throw Exception('Failed to delete post: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }

  // Like/Unlike post
  Future<TogglePostLike> togglePostLike(String postId) async {
    try {
      final currentUser = await userStorageServices.getCurrentUser();
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final response = await dio.post(
        AppConstants.getLikePostEndpoint(postId),
        queryParameters: {'userId': currentUser.id},
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // Handle different response formats
        if (data is Map<String, dynamic>) {
          if (data['isSuccess'] == true && data['data'] != null) {
            return TogglePostLike.fromJson(data['data']);
          } else if (data['postId'] != null) {
            // Direct toggle result
            return TogglePostLike.fromJson(data);
          } else {
            throw Exception(data['message'] ?? 'Failed to toggle post like');
          }
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to toggle post like');
      }
    } on DioException catch (e) {
      throw Exception('Failed to toggle post like: ${e.message}');
    } catch (e) {
      throw Exception('Failed to toggle post like: $e');
    }
  }

  // Like/Unlike comment
  Future<ToogleCommentLike> toggleCommentLike(String commentId) async {
    try {
      final currentUser = await userStorageServices.getCurrentUser();
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final response = await dio.post(
        AppConstants.getLikeCommentEndpoint(commentId),
        queryParameters: {'userId': currentUser.id},
      );
      if (response.statusCode == 200) {
        final data = response.data;

        // Handle different response formats
        if (data is Map<String, dynamic>) {

          if (data['isSuccess'] == true && data['data'] != null) {
            print('✅ PostService: Using data["data"] format');
            final result = ToogleCommentLike.fromJson(data['data']);
            print(
              '🔍 PostService: Parsed result - commentId: ${result.commentId}, isLiked: ${result.isLiked}, totalLikes: ${result.commentTotalLikes}',
            );
            return result;
          } else if (data['commentId'] != null) {
            // Direct toggle result
            print('✅ PostService: Using direct format');
            final result = ToogleCommentLike.fromJson(data);
            print(
              '🔍 PostService: Parsed result - commentId: ${result.commentId}, isLiked: ${result.isLiked}, totalLikes: ${result.commentTotalLikes}',
            );
            return result;
          } else {
            print('❌ PostService: Invalid response structure');
            throw Exception(data['message'] ?? 'Failed to toggle comment like');
          }
        } else {
          print('❌ PostService: Data is not Map, type: ${data.runtimeType}');
          throw Exception('Invalid response format');
        }
      } else {
        print('❌ PostService: Bad status code: ${response.statusCode}');
        throw Exception('Failed to toggle comment like');
      }
    } catch (e) {
      print('❌ PostService: Exception - $e');
      throw Exception('Failed to toggle comment like: $e');
    }
  }

  // Get post comments
  Future<List<PostComment>> getPostComments({required String postId}) async {
    try {
      final endpoint = AppConstants.getCommentsEndpoint(postId);
      final response = await dio.get(endpoint);

      if (response.statusCode == 200) {
        final data = response.data;

        // Handle different response formats
        if (data is Map<String, dynamic>) {
          if (data['isSuccess'] == true && data['data'] != null) {
            final commentData = data['data'];
            if (commentData is Map<String, dynamic> &&
                commentData['comments'] != null) {
              final comments =
                  (commentData['comments'] as List)
                      .map((commentJson) => PostComment.fromJson(commentJson))
                      .toList();
              return comments;
            } else if (commentData is List) {
              return commentData
                  .map((commentJson) => PostComment.fromJson(commentJson))
                  .toList();
            }
          } else if (data['comments'] != null) {
            // Direct comments array
            return (data['comments'] as List)
                .map((commentJson) => PostComment.fromJson(commentJson))
                .toList();
          }
        } else if (data is List) {
          // Direct list of comments
          return data
              .map((commentJson) => PostComment.fromJson(commentJson))
              .toList();
        }
      }
      return [];
    } on DioException catch (e) {
      throw Exception('Failed to get comments: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get comments: $e');
    }
  }

  // Create comment
  Future<PostComment> createComment(CreateComment request) async {
    try {
      final response = await dio.post(
        AppConstants.getCommentsEndpoint(request.postId),
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        // Handle different response formats
        if (data is Map<String, dynamic>) {
          if (data['isSuccess'] == true && data['data'] != null) {

            var resultData = PostComment.fromJson(data['data']);
            return resultData;
          }
          // else if (data['commentId'] != null) {
          //   // Direct comment object
          //   return PostComment.fromJson(data);
          // }
          else {
            throw Exception(data['message'] ?? 'Failed to create comment');
          }
        } else if (data is List && data.isNotEmpty) {
          // If response is a list, take the first item
          return PostComment.fromJson(data[0]);
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to create comment');
      }
    } on DioException catch (e) {
      throw Exception('Failed to create comment: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create comment: $e');
    }
  }

  // Update comment
  Future<PostComment> updateComment(UpdateComment request) async {
    try {
      final response = await dio.put(
        AppConstants.getMutationCommentEndpoint(request.commentId),
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['isSuccess'] == true && data['data'] != null) {
          return PostComment.fromJson(data['data']);
        } else {
          throw Exception(data['message'] ?? 'Failed to update comment');
        }
      } else {
        throw Exception('Failed to update comment');
      }
    } on DioException catch (e) {
      throw Exception('Failed to update comment: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update comment: $e');
    }
  }

  // Delete comment
  Future<void> deleteComment(String commentId) async {
    try {
      final currentUser = await userStorageServices.getCurrentUser();
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final response = await dio.delete(
        AppConstants.getMutationCommentEndpoint(commentId),
        queryParameters: {'userId': currentUser.id},
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete comment');
      }
    } on DioException catch (e) {
      throw Exception('Failed to delete comment: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete comment: $e');
    }
  }
}
