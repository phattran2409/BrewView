import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:briewview/core/widgets/dotIndicator.dart';
import 'package:briewview/core/widgets/navigation_bar.dart';
import 'package:briewview/features/post/model/post_model.dart';
import 'package:briewview/features/post/viewmodel/post_bloc.dart';
import 'package:briewview/features/post/viewmodel/post_event.dart';
import 'package:briewview/features/post/viewmodel/post_state.dart';
import 'package:briewview/features/post/view/post_create_form.dart';
import 'package:briewview/app/di/locator.dart';

class PostListPage extends StatefulWidget {
  const PostListPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PostListPageState();
  }
}

class _PostListPageState extends State<PostListPage> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  final int _pageSize = 10;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Load initial posts
    context.read<PostBloc>().add(const GetPostsEvent());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final currentState = context.read<PostBloc>().state;
    bool hasMore = true;

    if (currentState is PostListSuccessState) {
      hasMore = currentState.hasMore;
    }

    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.8 &&
        !_isLoadingMore &&
        hasMore) {
      _loadMorePosts();
    }
  }

  void _loadMorePosts() {
    setState(() {
      _isLoadingMore = true;
    });
    _currentPage++; // Tăng trang trước khi gọi API
    context.read<PostBloc>().add(
      GetPostsEvent(
        pageNumber: _currentPage,
        pageSize: _pageSize,
        isRefresh: false, // false = load more, true = refresh từ đầu
      ),
    );
  }

  void _refreshPosts() {
    setState(() {
      _currentPage = 1;
      _isLoadingMore = false;
    });
    context.read<PostBloc>().add(const GetPostsEvent(isRefresh: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5A2D09),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Bài viết mới',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              context.pushNamed('search');
            },
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (_) => BlocProvider(
                        create: (context) => getIt<PostBloc>(),
                        child: const PostCreateForm(),
                      ),
                ),
              );
              // Nếu tạo post thành công, refresh danh sách
              if (result == true && mounted) {
                _refreshPosts();
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocListener<PostBloc, PostState>(
        listener: (context, state) {
          if (state is PostUpdateSuccessState) {
            print("📝 Post updated in list, refreshing...");
            // Khi có post được update thành công, refresh danh sách
            _refreshPosts();
          }

          // Reset loading more flag khi load xong
          if (state is PostListSuccessState || state is PostListErrorState) {
            setState(() {
              _isLoadingMore = false;
            });
          }
        },
        child: BlocBuilder<PostBloc, PostState>(
          
          builder: (context, state) {
            if (state is PostListLoadingState && state.currentPosts.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            if (state is PostListErrorState && state.currentPosts.isEmpty) {
              return Center(
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
                      onPressed: _refreshPosts,
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              );
            }

            List<PostModel> posts = [];
            bool isLoading = false;

            if (state is PostListSuccessState) {
              posts = state.posts;
            } else if (state is PostListLoadingState) {
              posts = state.currentPosts;
              isLoading = true;
            } else if (state is PostListErrorState) {
              posts = state.currentPosts;
            }

            return RefreshIndicator(
              onRefresh: () async => _refreshPosts(),
              child: ListView.separated(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12,
                ),
                itemCount: posts.length + (isLoading ? 1 : 0),
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  if (index == posts.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    );
                  }

                  final post = posts[index];
                  return _PostCard(
                    post: post,
                    onTap: () async {
                      await context.pushNamed(
                        'post-detail',
                        pathParameters: {'id': post.postId},
                      );
                      // Refresh danh sách khi quay lại để cập nhật dữ liệu mới nhất
                      if (mounted) {
                        _refreshPosts();
                      }
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }
}

class _PostCard extends StatefulWidget {
  final PostModel post;
  final VoidCallback onTap;
  const _PostCard({required this.post, required this.onTap});

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  final PageController _mediaController = PageController();
  int _currentMediaPage = 0;

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
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 183, 145, 114).withOpacity(0.6),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      widget.post.user.avatarUrl != null
                          ? NetworkImage(widget.post.user.avatarUrl!)
                          : const AssetImage('assets/images/user.png')
                              as ImageProvider,
                  radius: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.user.fullName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _timeAgo(widget.post.createdAt),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.post.cafe != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.place, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          widget.post.cafe!.name,
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

            const SizedBox(height: 10),

            if (widget.post.title != null && widget.post.title!.isNotEmpty)
              Text(
                widget.post.title!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

            const SizedBox(height: 6),

            Text(
              widget.post.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white.withOpacity(0.9)),
            ),

            const SizedBox(height: 10),

            if (widget.post.medias.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 7 / 3,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildMediaPreview(),
                      if (widget.post.medias.length > 1)
                        Positioned(
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: DotIndicator(
                            currentIndex: _currentMediaPage,
                            dotCount: widget.post.medias.length,
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
              ),

            const SizedBox(height: 10),

            Row(
              children: [
                _iconStat(
                  icon: Icons.favorite,
                  label: widget.post.likeCount.toString(),
                ),
                const SizedBox(width: 18),
                _iconStat(
                  icon: Icons.mode_comment_outlined,
                  label: widget.post.commentCount.toString(),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaPreview() {
    final firstMedia = widget.post.medias.first;

    if (firstMedia.mediaType == 'image') {
      return Image.network(
        firstMedia.mediaUrl,
        fit: BoxFit.cover,
        errorBuilder:
            (c, e, s) => Container(
              color: const Color.fromARGB(255, 35, 24, 15),
              alignment: Alignment.center,
              child: const Icon(Icons.image_not_supported, color: Colors.white),
            ),
      );
    } else if (firstMedia.mediaType == 'video') {
      return Container(
        color: const Color.fromARGB(255, 35, 24, 15),
        alignment: Alignment.center,
        child: const Icon(
          Icons.play_circle_outline,
          color: Colors.white,
          size: 48,
        ),
      );
    } else {
      return Container(
        color: const Color.fromARGB(255, 35, 24, 15),
        alignment: Alignment.center,
        child: const Icon(Icons.mediation, color: Colors.white),
      );
    }
  }

  Widget _iconStat({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.25),
        borderRadius: BorderRadius.circular(10),
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
