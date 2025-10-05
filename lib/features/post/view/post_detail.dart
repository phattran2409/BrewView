import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:briewview/core/widgets/dotIndicator.dart';

class PostDetailPage extends StatefulWidget {
  final String? postId;
  final Map<String, dynamic>? post;

  const PostDetailPage({super.key, this.postId, this.post});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final PageController _mediaController = PageController();
  int _currentMedia = 0;

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
    final post = widget.post ?? {};
    final media = (post['media'] as List? ?? []).cast<Map<String, dynamic>>();

    return Scaffold(
      backgroundColor: const  Color(0xFF763C0C),
      appBar: AppBar(
        backgroundColor:   Color(0xFF5A2D09),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Post Detail', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Media carousel
            AspectRatio(
              aspectRatio: 4/3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    controller: _mediaController,
                    itemCount: media.isEmpty ? 1 : media.length,
                    onPageChanged: (i) => setState(() => _currentMedia = i),
                    itemBuilder: (_, i) {
                      if (media.isEmpty) {
                        return Container(
                          color: Colors.grey[800],
                          alignment: Alignment.center,
                          child: const Icon(Icons.image, color: Colors.white, size: 48),
                        );
                      }
                      final m = media[i];
                      return Image.asset(
                        m['url'] as String,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(
                          color: Colors.grey[800],
                          alignment: Alignment.center,
                          child: const Icon(Icons.image_not_supported, color: Colors.white),
                        ),
                      );
                    },
                  ),
                  if (media.length > 1)
                    Positioned(
                      bottom: 12,
                      left: 0,
                      right: 0,
                      child: DotIndicator(
                        currentIndex: _currentMedia,
                        dotCount: media.length,
                        pageController: _mediaController,
                        activeColor: Colors.white,
                        inactiveColor: Colors.white54,
                        activeWidth: 20,
                        inactiveWidth: 6,
                        height: 6,
                        spacing: 4,
                      ),
                    )
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
                        backgroundImage: AssetImage((post['user']?['avatar'] as String?) ?? 'assets/images/user.png'),
                        radius: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (post['user']?['name'] as String?) ?? 'User',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            if (post['created_at'] != null)
                              Text(
                                _timeAgo(post['created_at'] as DateTime),
                                style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
                              ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.place, color: Colors.amber, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              (post['cafe']?['name'] as String?) ?? 'Cafe',
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 14),

                  if ((post['title'] as String?)?.isNotEmpty == true)
                    Text(
                      post['title'] as String,
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),

                  const SizedBox(height: 8),

                  Text(
                    (post['content'] as String?) ?? '',
                    style: const TextStyle(color: Colors.white, height: 1.5),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      _chipStat(icon: Icons.favorite, label: (post['likes'] ?? 0).toString()),
                      const SizedBox(width: 12),
                      _chipStat(icon: Icons.mode_comment_outlined, label: (post['comments'] ?? 0).toString()),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.white),
                        onPressed: () {},
                      )
                    ],
                  ),

                  const SizedBox(height: 24),

                  const Text('Comment', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),

                  ...List.generate(3, (i) => _commentItem(index: i)),
                ],
              ),
            )
          ],
        ),
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
  
  Widget _commentItem({required int index}) {
    return Container(    
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF5A2D09),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(radius: 16, backgroundColor: Colors.grey, child: Icon(Icons.person, color: Colors.white, size: 16)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('User $index', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    Text('2 giờ trước', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Quán đẹp quá, để cuối tuần mình ghé thử!', style: TextStyle(color: Colors.white.withOpacity(0.9))),
              ],
            ),
          )
        ],
      ),
    );
  }
}