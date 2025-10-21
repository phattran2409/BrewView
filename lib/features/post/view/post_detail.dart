import 'package:briewview/features/post/model/post_media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:briewview/core/widgets/dotIndicator.dart';
import 'package:briewview/features/post/model/post_model.dart';
import 'package:briewview/features/post/viewmodel/post_bloc.dart';
import 'package:briewview/features/post/viewmodel/post_event.dart';
import 'package:briewview/features/post/viewmodel/post_state.dart';
import 'package:briewview/features/post/viewmodel/comment_bloc.dart';
import 'package:briewview/features/post/view/post_edit_form.dart';
import 'package:briewview/features/post/view/widgets/comment_list_widget.dart';
import 'package:briewview/features/post/view/widgets/comment_input_widget.dart';
import 'package:briewview/core/network/user_storage_services.dart';
import 'package:briewview/features/post/model/comment_mutation/post_comment.dart';
import 'package:briewview/app/di/locator.dart';

class PostDetailPage extends StatefulWidget {
  final String? postId;

  const PostDetailPage({super.key, this.postId});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final PageController _mediaController = PageController();
  int _currentMedia = 0;
  String? _currentUserId;
  PostModel? _currentPost;

  @override
  void initState() {
    super.initState();
    print("🚀 PostDetailPage: initState with postId: ${widget.postId}");
    _getCurrentUserId();

    // Always load post details from API using the postId
    if (widget.postId != null) {
      print("🔍 Loading post by ID: ${widget.postId}");
      context.read<PostBloc>().add(GetPostByIdEvent(widget.postId!));

    } else {
      print("❌ No postId provided");
    }
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
  void dispose() {
    _mediaController.dispose();
    super.dispose();
  }

  String _timeAgo(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostBloc, PostState>(
      listener: (context, state) {
        if (state is PostDeleteSuccessState) {
          // Hiển thị thông báo
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Xóa bài viết thành công!')),
          );
          context.pop(); 
        } else if (state is PostDeleteErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Xóa thất bại: ${state.message}')),
          );
        } else if (state is PostUpdateSuccessState) {
          print("🔄 Post updated successfully, reloading post detail...");
          // Khi update thành công, load lại post detail
          if (widget.postId != null) {
            context.read<PostBloc>().add(GetPostByIdEvent(widget.postId!));
          }
        } else if (state is PostToggleLikeSuccessState) {
          // Reload post details after toggling like
          final postId = widget.postId;
          if (postId != null) {
            context.read<PostBloc>().add(GetPostByIdEvent(postId));
          }
        }
      },
      child: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          // Handle different states and update _currentPost
          if (state is PostDetailSuccessState) {
            _currentPost = state.post;
          } else if (state is PostDetailLoadingState && _currentPost == null) {
            return const Scaffold(
              backgroundColor: Color(0xFF763C0C),
              body: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            );
          } else if (state is PostDetailErrorState && _currentPost == null) {
            return Scaffold(
              backgroundColor: const Color(0xFF763C0C),
              appBar: AppBar(
                backgroundColor: const Color(0xFF5A2D09),
                foregroundColor: Colors.white,
                elevation: 0,
                title: const Text(
                  'Chi tiết bài viết',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.white, size: 64),
                    const SizedBox(height: 16),
                    Text(
                      'Lỗi: ${state.message}',
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (widget.postId != null) {
                          context.read<PostBloc>().add(
                            GetPostByIdEvent(widget.postId!),
                          );
                        }
                      },
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (_currentPost == null) {
            return const Scaffold(
              backgroundColor: Color(0xFF763C0C),
              body: Center(
                child: Text(
                  'Không tìm thấy bài viết',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }

          return _buildPostDetail(_currentPost!);
        },
      ),
    );
  }

  Widget _buildPostDetail(PostModel post) {
    return Scaffold(
      backgroundColor: const Color(0xFF763C0C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5A2D09),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Chi tiết bài viết',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) async {
              switch (value) {
                case 'edit':
                  final result = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (_) => BlocProvider.value(
                            value: context.read<PostBloc>(),
                            child: PostEditForm(post: post),
                          ),
                    ),
                  );
                  if (result == true && mounted) {
                    context.pop();
                  }
                  break;
                case 'delete':
                  _showDeleteDialog(post);
                  break;
              }
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Chỉnh sửa')),
                  const PopupMenuItem(value: 'delete', child: Text('Xóa')),
                ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Media carousel
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    controller: _mediaController,
                    itemCount: post.medias.isEmpty ? 1 : post.medias.length,
                    onPageChanged: (i) => setState(() => _currentMedia = i),
                    itemBuilder: (_, i) {
                      if (post.medias.isEmpty) {
                        return Container(
                          color: Colors.grey[800],
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.image,
                            color: Colors.white,
                            size: 48,
                          ),
                        );
                      }
                      final media = post.medias[i];
                      return _buildMediaWidget(media);
                    },
                  ),
                  if (post.medias.length > 1)
                    Positioned(
                      bottom: 12,
                      left: 0,
                      right: 0,
                      child: DotIndicator(
                        currentIndex: _currentMedia,
                        dotCount: post.medias.length,
                        pageController: _mediaController,
                        activeColor: Colors.white,
                        inactiveColor: Colors.white54,
                        activeWidth: 20,
                        inactiveWidth: 6,
                        height: 6,
                        spacing: 4,
                      ),
                    ),
                ],
              ),
            ),

            // Body
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            post.user.avatarUrl != null
                                ? NetworkImage(post.user.avatarUrl!)
                                : const AssetImage('assets/images/user.png')
                                    as ImageProvider,
                        radius: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.user.fullName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              _timeAgo(post.createdAt),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (post.cafe != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.place,
                                color: Colors.amber,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                post.cafe!.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  if (post.title != null && post.title!.isNotEmpty)
                    Text(
                      post.title!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  const SizedBox(height: 8),

                  Text(
                    post.content,
                    style: const TextStyle(color: Colors.white, height: 1.5),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      _chipStat(
                        icon: Icons.favorite,
                        label: post.likeCount.toString(),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          post.isLikedByCurrentUser == true
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color:
                              post.isLikedByCurrentUser == true
                                  ? Colors.red
                                  : Colors.white,
                        ),
                        onPressed: () => _toggleLike(post),
                      ),
                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.white),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Chức năng chia sẻ đang được phát triển.',
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Comments section header
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5A2D09).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF8B4513).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.mode_comment_outlined,
                          color: Colors.amber,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Bình luận',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B4513).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${post.commentCount}',
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Comments section with shared CommentBloc
                  BlocProvider(
                    create: (context) => getIt<CommentBloc>(),
                    child: Column(
                      children: [
                        // Comments list
                        CommentListWidget(
                          postId: post.postId,
                          onCommentAdded: () {
                            // Comments will be reloaded automatically via BlocListener in CommentListWidget
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Comment input
                        if (_currentUserId != null)
                          CommentInputWidget(
                            postId: post.postId,
                            onCommentAdded: () {
                              // Comments will be reloaded automatically via BlocListener in CommentListWidget
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaWidget(PostMedia media) {
    if (media.mediaType == 'image') {
      return Image.network(
        media.mediaUrl,
        fit: BoxFit.cover,
        errorBuilder:
            (c, e, s) => Container(
              color: Colors.grey[800],
              alignment: Alignment.center,
              child: const Icon(Icons.image_not_supported, color: Colors.white),
            ),
      );
    } else if (media.mediaType == 'video') {
      return Container(
        color: Colors.grey[800],
        alignment: Alignment.center,
        child: const Icon(
          Icons.play_circle_outline,
          color: Colors.white,
          size: 48,
        ),
      );
    } else {
      return Container(
        color: Colors.grey[800],
        alignment: Alignment.center,
        child: const Icon(Icons.mediation, color: Colors.white),
      );
    }
  }

  void _toggleLike(PostModel post) {
    context.read<PostBloc>().add(TogglePostLikeEvent(post.postId));
  }

  void _showDeleteDialog(PostModel post) {
    // Lưu lại context cha
    final parentContext = context;
    showDialog(
      context: parentContext,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Xóa bài viết'),
            content: const Text('Bạn có chắc chắn muốn xóa bài viết này?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  parentContext.read<PostBloc>().add(
                    DeletePostEvent(post.postId),
                  );
                  // Không pop ngay ở đây, để BlocListener xử lý
                },
                child: const Text('Xóa', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  Widget _chipStat({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF8B4513).withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.amber, size: 16),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
