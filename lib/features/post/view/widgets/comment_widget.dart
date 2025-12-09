import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:briewview/features/post/model/comment_mutation/post_comment.dart';
import 'package:briewview/features/post/viewmodel/comment_bloc.dart';
import 'package:briewview/features/post/viewmodel/comment_event.dart';
import 'package:briewview/features/post/viewmodel/comment_state.dart';
import 'package:briewview/core/network/user_storage_services.dart';

class CommentWidget extends StatefulWidget {
  final PostComment comment;
  final String postId;
  final bool isReply;
  final VoidCallback? onReplyPressed;

  const CommentWidget({
    super.key,
    required this.comment,
    required this.postId,
    this.isReply = false,
    this.onReplyPressed,
  });

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  bool _isEditing = false;
  bool _isReplying = false;
  bool _showReplies = false;
  final TextEditingController _editController = TextEditingController();
  final TextEditingController _replyController = TextEditingController();
  String? _currentUserId;
  PostComment? _currentComment;

  @override
  void initState() {
    super.initState();
    _currentComment = widget.comment;
    _getCurrentUserId();

    // Validate commentId on initialization
    if (widget.comment.commentId.isEmpty) {
      print('⚠️ WARNING: CommentWidget initialized with empty commentId!');
      print('⚠️ Comment data: ${widget.comment.toJson()}');
    } else {
      print(
        '✅ CommentWidget initialized with commentId: ${widget.comment.commentId}',
      );
      print('✅ Replies count: ${widget.comment.replies.length}');
    }
  }

  @override
  void didUpdateWidget(CommentWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _editController.dispose();
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentUserId() async {
    final userStorageServices = UserStorageServices();
    final user = await userStorageServices.getCurrentUser();
    if (user != null) {
      setState(() {
        _currentUserId = user.id;
      });
    }
  }

  String _timeAgo(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }

  bool get _isCurrentUserComment => _currentUserId == _currentComment?.userId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommentBloc, CommentState>(
      listener: (context, state) {
        if (state is CommentUpdateSuccessState) {
          setState(() {
            _isEditing = false;
            _editController.clear();
            // Update local comment state with new content
            _currentComment = _currentComment?.copyWith(
              content: state.comment.content,
            );
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cập nhật bình luận thành công!')),
          );
        } else if (state is CommentDeleteSuccessState) {
          // Check if this delete event is for current comment
          if (state.commentId == _currentComment?.commentId) {
            setState(() {
              // Mark comment as deleted using deletedAt field
              _currentComment = _currentComment?.copyWith(
                content: '[Bình luận đã bị xóa]',
                deletedAt: DateTime.now(),
              );
            });
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Xóa bình luận thành công!')),
          );
        } else if (state is CommentCreateSuccessState) {
          print(
            '🔍 Listener: Reply created for comment: ${state.comment.parentCommentId}',
          );

          // Check if this reply belongs to current comment
          if (state.comment.parentCommentId == _currentComment?.commentId) {
            print('🔍 Listener: Adding reply to current comment');
            print(
              '🔍 Before - replies count: ${_currentComment?.replies.length}, replyCount: ${_currentComment?.replyCount}',
            );

            setState(() {
              // Add new reply to the replies list
              final updatedReplies = List<PostComment>.from(
                _currentComment?.replies ?? [],
              );
              updatedReplies.add(state.comment);

              // Update current comment with new reply
              _currentComment = _currentComment?.copyWith(
                replies: updatedReplies,
                replyCount: (_currentComment?.replyCount ?? 0) + 1,
              );

              // Close reply form and show replies
              _isReplying = false;
              _replyController.clear();
              _showReplies = true;
            });

            print(
              '🔍 After - replies count: ${_currentComment?.replies.length}, replyCount: ${_currentComment?.replyCount}',
            );
          } else {
            // Reply belongs to another comment, just close form
            setState(() {
              _isReplying = false;
              _replyController.clear();
            });
          }
          // Don't show snackbar here as it will be handled by CommentInputWidget
        } else if (state is CommentToggleLikeSuccessState) {
          // Update _currentComment và _toggledCommentId
          if (state.toggleResult.commentId == _currentComment?.commentId) {
            print(
              '🔍 Listener: Comment ${state.toggleResult.commentId} toggled',
            );
            print(
              '🔍 Before - isLiked: ${_currentComment?.isLikedByCurrentUser}, count: ${_currentComment?.likeCount}',
            );
            print(
              '🔍 New values - isLiked: ${state.toggleResult.isLiked}, count: ${state.toggleResult.commentTotalLikes}',
            );

            setState(() {
              _currentComment = _currentComment?.copyWith(
                isLikedByCurrentUser: state.toggleResult.isLiked,
                likeCount:
                    state.toggleResult.commentTotalLikes ??
                    _currentComment!.likeCount,
              );
            });

            print(
              '🔍 After - isLiked: ${_currentComment?.isLikedByCurrentUser}, count: ${_currentComment?.likeCount}',
            );

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.toggleResult.isLiked == true
                      ? 'Đã thích bình luận!'
                      : 'Đã bỏ thích bình luận!',
                ),
                duration: const Duration(milliseconds: 1500),
              ),
            );
          }
        }
      },
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.only(left: widget.isReply ? 24 : 0, bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color:
                widget.isReply
                    ? const Color(0xFF5A2D09).withOpacity(0.2)
                    : const Color(0xFF5A2D09).withOpacity(0.4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  widget.isReply
                      ? const Color(0xFF8B4513).withOpacity(0.2)
                      : const Color(0xFF8B4513).withOpacity(0.4),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Comment header
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: const Color(0xFF8B4513),
                    child: Text(
                      ((_currentComment?.userName ?? 'Người dùng').isNotEmpty
                              ? (_currentComment?.userName ?? 'Người dùng')[0]
                              : 'U')
                          .toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentComment?.userName ?? 'Người dùng',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          _timeAgo(
                            _currentComment?.createdAt ?? DateTime.now(),
                          ),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_isCurrentUserComment)
                    PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white70,
                        size: 18,
                      ),
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            _editController.text =
                                _currentComment?.content ?? '';
                            setState(() {
                              _isEditing = true;
                            });
                            break;
                          case 'delete':
                            _showDeleteDialog();
                            break;
                        }
                      },
                      itemBuilder:
                          (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Chỉnh sửa'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Xóa'),
                            ),
                          ],
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Comment content
              if (_isEditing)
                _buildEditForm()
              else
                Text(
                  _currentComment?.content ?? '',
                  style: const TextStyle(color: Colors.white, height: 1.4),
                ),

              const SizedBox(height: 8),

              // Comment actions
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      print(
                        '🔍 Toggle like clicked for comment: ${_currentComment?.commentId}',
                      );
                      print(
                        '🔍 Current like status: ${_currentComment?.isLikedByCurrentUser}',
                      );
                      print(
                        '🔍 Current like count: ${_currentComment?.likeCount}',
                      );

                      if (_currentComment?.commentId == null) {
                        print('❌ ERROR: commentId is null!');
                        return;
                      }

                      context.read<CommentBloc>().add(
                        ToggleCommentLikeEvent(_currentComment!.commentId),
                      );
                    },
                    child: BlocBuilder<CommentBloc, CommentState>(
                      buildWhen: (previous, current) {
                        // Chỉ rebuild khi toggle like thành công cho comment này
                        if (current is CommentToggleLikeSuccessState) {
                          final shouldRebuild =
                              current.toggleResult.commentId ==
                              _currentComment?.commentId;
                          if (shouldRebuild) {
                            print(
                              '🔍 BlocBuilder: Rebuilding like button for comment ${_currentComment?.commentId}',
                            );
                          }
                          return shouldRebuild;
                        }
                        return false;
                      },
                      builder: (context, state) {
                        // Lấy giá trị hiện tại từ _currentComment
                        bool isLiked =
                            _currentComment?.isLikedByCurrentUser ?? false;
                        int likeCount = _currentComment?.likeCount ?? 0;

                        print(
                          '🔍 BlocBuilder: Building icon - isLiked: $isLiked, count: $likeCount',
                        );

                        return Row(
                          children: [
                            Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Colors.red : Colors.white70,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              likeCount.toString(),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  if (!widget.isReply)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isReplying = true;
                        });
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.reply, color: Colors.white70, size: 16),
                          SizedBox(width: 4),
                          Text(
                            'Trả lời',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (!widget.isReply && (_currentComment?.replyCount ?? 0) > 0)
                    const SizedBox(width: 16),
                  if (!widget.isReply && (_currentComment?.replyCount ?? 0) > 0)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showReplies = !_showReplies;
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            _showReplies
                                ? Icons.expand_less
                                : Icons.expand_more,
                            color: Colors.white70,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _showReplies
                                ? 'Ẩn trả lời'
                                : '${_currentComment?.replyCount ?? 0} trả lời',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              // Reply form
              if (_isReplying) _buildReplyForm(),

              // Replies
              if ((_currentComment?.replies.isNotEmpty ?? false) &&
                  _showReplies)
                Column(
                  children:
                      (_currentComment?.replies ?? []).map((reply) {
                        return BlocProvider.value(
                          value: context.read<CommentBloc>(),
                          child: CommentWidget(
                            comment: reply,
                            postId: widget.postId,
                            isReply: true,
                          ),
                        );
                      }).toList(),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEditForm() {
    return Column(
      children: [
        TextField(
          controller: _editController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Chỉnh sửa bình luận...',
            hintStyle: TextStyle(color: Colors.white54),
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white54),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.amber),
            ),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  _isEditing = false;
                  _editController.clear();
                });
              },
              child: const Text('Hủy', style: TextStyle(color: Colors.white70)),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                if (_editController.text.trim().isNotEmpty) {
                  context.read<CommentBloc>().add(
                    UpdateCommentEvent(
                      commentId: _currentComment?.commentId ?? '',
                      content: _editController.text.trim(),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B4513),
                foregroundColor: Colors.white,
              ),
              child: const Text('Cập nhật'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReplyForm() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          TextField(
            controller: _replyController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Viết trả lời...',
              hintStyle: TextStyle(color: Colors.white54),
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white54),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.amber),
              ),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _isReplying = false;
                    _replyController.clear();
                  });
                },
                child: const Text(
                  'Hủy',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  // Validate all required fields before creating reply
                  if (_replyController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Vui lòng nhập nội dung trả lời!'),
                      ),
                    );
                    return;
                  }

                  if (_currentUserId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Vui lòng đăng nhập để trả lời!'),
                      ),
                    );
                    return;
                  }

                  if (_currentComment?.commentId == null ||
                      _currentComment!.commentId.isEmpty) {
                    print(
                      '❌ ERROR: Invalid commentId - ${_currentComment?.commentId}',
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Không thể trả lời bình luận này!'),
                      ),
                    );
                    return;
                  }

                  print(
                    '✅ Creating reply with commentId: ${_currentComment!.commentId}',
                  );
                  context.read<CommentBloc>().add(
                    CreateCommentEvent(
                      postId: widget.postId,
                      userId: _currentUserId!,
                      content: _replyController.text.trim(),
                      parentCommentId: _currentComment!.commentId,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B4513),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Trả lời'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Xóa bình luận'),
            content: const Text('Bạn có chắc chắn muốn xóa bình luận này?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<CommentBloc>().add(
                    DeleteCommentEvent(_currentComment?.commentId ?? ''),
                  );
                },
                child: const Text('Xóa', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }
}
