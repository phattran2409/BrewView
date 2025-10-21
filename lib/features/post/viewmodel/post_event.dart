import 'package:equatable/equatable.dart';
import 'package:briewview/features/post/model/post_mutation.dart';
import 'dart:io';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => [];
}

// Get posts events
class GetPostsEvent extends PostEvent {
  final int pageNumber;
  final int pageSize;
  final String? searchTerm;
  final String? sortBy;
  final String? sortDirection;
  final bool isRefresh;

  const GetPostsEvent({
    this.pageNumber = 1,
    this.pageSize = 10,
    this.searchTerm,
    this.sortBy,
    this.sortDirection,
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [pageNumber, pageSize, searchTerm, sortBy, sortDirection, isRefresh];
}

class GetPostByIdEvent extends PostEvent {
  final String postId;

  const GetPostByIdEvent(this.postId);

  @override
  List<Object> get props => [postId];
}

// Create post events
class CreatePostEvent extends PostEvent {
  final PostCreate request;
  final List<File>? mediaFiles;

  const CreatePostEvent({
    required this.request,
    this.mediaFiles,
  });

  @override
  List<Object?> get props => [request, mediaFiles];
}

// Update post events
class UpdatePostEvent extends PostEvent {
  final PostUpdate request;

  const UpdatePostEvent(this.request);

  @override
  List<Object> get props => [request];
}

// Delete post events
class DeletePostEvent extends PostEvent {
  final String postId;

  const DeletePostEvent(this.postId);

  @override
  List<Object> get props => [postId];
}

// Like/Unlike post events
class LikePostEvent extends PostEvent {
  final String postId;

  const LikePostEvent(this.postId);

  @override
  List<Object> get props => [postId];
}

class UnlikePostEvent extends PostEvent {
  final String postId;

  const UnlikePostEvent(this.postId);

  @override
  List<Object> get props => [postId];
}


class TogglePostLikeEvent extends PostEvent {
  final String postId;

  const TogglePostLikeEvent(this.postId);

  @override
  List<Object> get props => [postId];
}


// Reset events
class ResetPostStateEvent extends PostEvent {
  const ResetPostStateEvent();
}

