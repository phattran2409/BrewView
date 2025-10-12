import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:briewview/core/widgets/dotIndicator.dart';
import 'post_detail.dart';

class PostListPage extends StatefulWidget {
  const PostListPage({super.key});
  
  @override
  State<StatefulWidget> createState() {
    return _PostListPageState();
  }
}

class _PostListPageState extends State<PostListPage> {
  final List<Map<String, dynamic>> _posts = [
    {
      'post_id': 1,
      'user': {
        'name': 'Linh Nguyen',
        'avatar': 'assets/images/user.png',
      },
      'cafe': {
        'id': 101,
        'name': 'Quán Bé Bò',
      },
      'title': 'Góc chill cuối tuần ☕️',
      'content': 'Hôm nay mình ghé lại quán quen, không gian yên tĩnh, nhạc nhẹ, rất phù hợp để đọc sách và làm việc. Latte ở đây béo vừa phải, thơm mùi hạt rang mới. Highly recommended! ',
      'is_visible': true,
      'created_at': DateTime.now().subtract(const Duration(hours: 3)),
      'media': [
        {
          'media_id': 1,
          'post_id': 1,
          'media_type': 'image',
          'url': 'assets/images/coffee_shop_1.jpg',
          'caption': 'View từ bàn cạnh cửa sổ',
          'uploaded_at': DateTime.now().subtract(const Duration(hours: 3)),
        },
        {
          'media_id': 2,
          'post_id': 1,
          'media_type': 'image',
          'url': 'assets/images/coffee_shop_2.jpg',
          'caption': 'Ly latte nóng',
          'uploaded_at': DateTime.now().subtract(const Duration(hours: 3)),
        },
        {
          'media_id': 3,
          'post_id': 1,
          'media_type': 'image',
          'url': 'assets/images/coffe_shop_3.jpg',
          'caption': 'Quầy bar',
          'uploaded_at': DateTime.now().subtract(const Duration(hours: 3)),
        },
      ],
      'likes': 128,
      'comments': 34,
    },
    {
      'post_id': 2,
      'user': {
        'name': 'Minh Tran',
        'avatar': 'assets/images/user.png',
      },
      'cafe': {
        'id': 102,
        'name': 'Hidden Coffee',
      },
      'title': 'Địa điểm làm việc lý tưởng',
      'content': 'Ổ cắm đầy đủ, wifi mạnh, nhân viên thân thiện. Mình thường đến đây mỗi khi cần tập trung cao độ. Cappuccino và cold brew đều ổn.',
      'is_visible': true,
      'created_at': DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      'media': [
        {
          'media_id': 4,
          'post_id': 2,
          'media_type': 'image',
          'url': 'assets/images/onboarding_1.png',
          'caption': 'Không gian tầng 2',
          'uploaded_at': DateTime.now().subtract(const Duration(days: 1)),
        },
        {
          'media_id': 5,
          'post_id': 2,
          'media_type': 'image',
          'url': 'assets/images/onboarding_2.png',
          'caption': 'Bàn gần cửa',
          'uploaded_at': DateTime.now().subtract(const Duration(days: 1)),
        }
      ],
      'likes': 82,
      'comments': 12,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF5A2D09),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Bài viết mới', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
           actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Sử dụng GoRouter để navigate đến search page
              context.pushNamed('search');
            },
          ),
          const SizedBox(width: 8), // Thêm khoảng cách từ edge
        ],
  
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        itemCount: _posts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final post = _posts[index];
          return _PostCard(
            post: post,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PostDetailPage(postId: post['post_id'].toString(), post: post),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _PostCard extends StatefulWidget {
  final Map<String, dynamic> post;
  final VoidCallback onTap;
  const _PostCard({required this.post, required this.onTap});

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  final PageController _mediaController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _mediaController.dispose();
    super.dispose();
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    return '${diff.inDays} ngày trước';
  }

  @override
  Widget build(BuildContext context) {
    final media = (widget.post['media'] as List).cast<Map<String, dynamic>>();
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
                  backgroundImage: AssetImage(widget.post['user']['avatar'] as String),
                  radius: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post['user']['name'] ?? 'User',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        _timeAgo(widget.post['created_at'] as DateTime),
                        style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.place, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        widget.post['cafe']['name'] ?? 'Cafe',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                )
              ],
            ),

            const SizedBox(height: 10),

            if ((widget.post['title'] as String).isNotEmpty)
              Text(
                widget.post['title'],
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),

            const SizedBox(height: 6),

            Text(
              widget.post['content'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white.withOpacity(0.9)),
            ),

            const SizedBox(height: 10),

            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 7/3,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      media.isNotEmpty ? media[0]['url'] as String : '',
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(
                      color: const Color.fromARGB(255, 35, 24, 15),
                      alignment: Alignment.center,
                      child: const Icon(Icons.image_not_supported, color: Colors.white),
                      ),
                    ),
                    // if (media.length > 1)
                    //   Positioned(
                    //     bottom: 10,
                    //     left: 0,
                    //     right: 0,
                    //     child: DotIndicator(
                    //       currentIndex: _currentPage,
                    //       dotCount: media.length,
                    //       pageController: _mediaController,
                    //       activeColor: Colors.white,
                    //       inactiveColor: Colors.white54,
                    //       activeWidth: 20,
                    //       inactiveWidth: 6,
                    //       height: 6,
                    //       spacing: 4,
                    //     ),
                    //   ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                _iconStat(icon: Icons.favorite, label: widget.post['likes'].toString()),
                const SizedBox(width: 18),
                _iconStat(icon: Icons.mode_comment_outlined, label: widget.post['comments'].toString()),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: () {},
                )
              ],
            ),
          ],
        ),
      ),
    );
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
