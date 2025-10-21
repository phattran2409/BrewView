import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:briewview/features/post/viewmodel/comment_bloc.dart';
import 'package:briewview/features/post/viewmodel/comment_event.dart';
import 'package:briewview/features/post/viewmodel/comment_state.dart';
import 'package:briewview/core/network/user_storage_services.dart';

class CommentInputWidget extends StatefulWidget {
  final String postId;
  final String? parentCommentId;
  final VoidCallback? onCommentAdded;

  const CommentInputWidget({
    super.key,
    required this.postId,
    this.parentCommentId,
    this.onCommentAdded,
  });

  @override
  State<CommentInputWidget> createState() => _CommentInputWidgetState();
}

class _CommentInputWidgetState extends State<CommentInputWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isLoading = false;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _getCurrentUserId();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      // Trigger rebuild when text changes
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<CommentBloc, CommentState>(
      listener: (context, state) {
        if (state is CommentCreateSuccessState) {
          setState(() {
            _isLoading = false;
            _controller.clear();
            _focusNode.unfocus();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Thêm bình luận thành công!'),
              backgroundColor: Colors.green,
            ),
          );
          widget.onCommentAdded?.call();
        } else if (state is CommentCreateErrorState) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: ${state.message}')),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF5A2D09).withOpacity(0.4),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          border: Border.all(
            color: const Color(0xFF8B4513).withOpacity(0.4),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          children: [
            if (widget.parentCommentId != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B4513).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.reply, color: Colors.amber, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Đang trả lời bình luận',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: widget.parentCommentId != null 
                          ? 'Viết trả lời...' 
                          : 'Viết bình luận...',
                      hintStyle: const TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: Colors.white54),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: Colors.white54),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: Colors.amber),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.newline,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: _controller.text.trim().isNotEmpty && !_isLoading
                        ? const Color(0xFF8B4513)
                        : Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: _controller.text.trim().isNotEmpty && !_isLoading
                        ? [
                            BoxShadow(
                              color: const Color(0xFF8B4513).withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: IconButton(
                    onPressed: _controller.text.trim().isNotEmpty && !_isLoading && _currentUserId != null
                        ? _submitComment
                        : null,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Icon(
                            Icons.send,
                            color: _controller.text.trim().isNotEmpty && !_isLoading
                                ? Colors.white
                                : Colors.white54,
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submitComment() {
    if (_controller.text.trim().isNotEmpty && _currentUserId != null) {
      setState(() {
        _isLoading = true;
      });

      context.read<CommentBloc>().add(
        CreateCommentEvent(
          postId: widget.postId,
          userId: _currentUserId!,
          content: _controller.text.trim(),
          parentCommentId: widget.parentCommentId,
        ),
      );
    }
  }
}
