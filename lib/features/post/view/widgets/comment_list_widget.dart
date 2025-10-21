import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:briewview/features/post/model/comment_mutation/post_comment.dart';
import 'package:briewview/features/post/viewmodel/comment_bloc.dart';
import 'package:briewview/features/post/viewmodel/comment_state.dart';
import 'package:briewview/features/post/view/widgets/comment_widget.dart';
import 'package:briewview/features/post/repository/post_repository.dart';
import 'package:briewview/app/di/locator.dart';

class CommentListWidget extends StatefulWidget {
  final String postId;
  final VoidCallback? onCommentAdded;

  const CommentListWidget({
    super.key,
    required this.postId,
    this.onCommentAdded,
  });

  @override
  State<CommentListWidget> createState() => _CommentListWidgetState();
}

class _CommentListWidgetState extends State<CommentListWidget> {
  List<PostComment> _comments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    try {
      final postRepository = getIt<PostRepository>();
      final result = await postRepository.getPostComments(postId: widget.postId);
      
      result.fold(
        (failure) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi tải bình luận: ${failure.toString()}')),
          );
        },
        (comments) {
          setState(() {
            _comments = comments;
            _isLoading = false;
          });
        },
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi tải bình luận: $e')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<CommentBloc, CommentState>(
      listener: (context, state) {
        if (state is CommentErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: ${state.message}')),
          );
        } else if (state is CommentCreateSuccessState || 
                   state is CommentDeleteSuccessState) {
          // Only reload comments when creating or deleting comments
          // Don't reload for updates or likes to preserve UI state
          _loadComments();
          // Notify parent if comment was created
          if (state is CommentCreateSuccessState) {
            widget.onCommentAdded?.call();
          }
        }
      },
      child: Column(
        children: [
          // Comments list
          if (_isLoading)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF5A2D09).withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF8B4513).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  const CircularProgressIndicator(
                    color: Colors.amber,
                    strokeWidth: 2,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Đang tải bình luận...',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          else if (_comments.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFF5A2D09).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF8B4513).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.mode_comment_outlined,
                    color: Colors.white.withOpacity(0.5),
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Chưa có bình luận nào',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Hãy là người đầu tiên bình luận!',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                final comment = _comments[index];
                return BlocProvider.value(
                  value: context.read<CommentBloc>(),
                  child: CommentWidget(
                    key: ValueKey(comment.commentId),
                    comment: comment,
                    postId: widget.postId,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
