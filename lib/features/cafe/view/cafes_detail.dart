import 'package:flutter/material.dart';
import 'package:briewview/app/theme/app_color.dart';
import 'package:go_router/go_router.dart';

class CafeDetail extends StatefulWidget {
  final String? coffeeId;
  final Map<String, dynamic>? coffeeData;

  const CafeDetail({super.key, this.coffeeId, this.coffeeData});

  @override
  _CafeDetailState createState() => _CafeDetailState();
}

class _CafeDetailState extends State<CafeDetail> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset > 100 && !_isScrolled) {
      setState(() => _isScrolled = true);
    } else if (_scrollController.offset <= 100 && _isScrolled) {
      setState(() => _isScrolled = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ✅ Main scrollable content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // ✅ Image header với parallax effect
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                backgroundColor: Colors.transparent,
                leading: _buildBackButton(),
                actions: [_buildShareButton()],
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildCafeImage(),
                ),
              ),

              // ✅ Cafe details content
              SliverToBoxAdapter(
                child: _buildCafeDetailsContent(),
              ),
            ],
          ),
          
          // ✅ Floating elements
          _buildFloatingElements(),
        ],
      ),
    );
  }

  // ✅ Coffee image với gradient overlay
  Widget _buildCafeImage() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image
        Image.asset(
          widget.coffeeData?['image'] ?? 'assets/images/coffe_shop_3.jpg',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[800],
              child: const Icon(
                Icons.local_cafe,
                color: Colors.white,
                size: 100,
              ),
            );
          },
        ),
        
        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.6),
                Colors.black.withOpacity(0.9),
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
        ),
        
        // Dots indicator ở giữa
        const Positioned(
          bottom: 120,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(radius: 4, backgroundColor: Colors.white),
              SizedBox(width: 8),
              CircleAvatar(radius: 4, backgroundColor: Colors.white54),
              SizedBox(width: 8),
              CircleAvatar(radius: 4, backgroundColor: Colors.white54),
            ],
          ),
        ),
      ],
    );
  }

  // ✅ Cafe details content section
  Widget _buildCafeDetailsContent() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF8B4513), // Coffee brown background
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cafe name và favorite
            _buildCafeHeader(),
            
            const SizedBox(height: 16),
            
            // Tags (Yên tĩnh, Chill, HCM)
            _buildTags(),
            
            const SizedBox(height: 16),
            
            // Rating và address
            _buildRatingSection(),
            
            const SizedBox(height: 20),
            
            // Voucher section
            _buildVoucherSection(),
            
            const SizedBox(height: 20),
            
            // Reviews section
            _buildReviewsSection(),
            
            const SizedBox(height: 100), // Space for bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildCafeHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.coffeeData?['name'] ?? 'Quán Bé Bò',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // Favorite button
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.favorite,
            color: Colors.red,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildTags() {
    final tags = ['Yên tĩnh', 'Chill', 'HCM'];
    return Row(
      children: tags.map((tag) {
        return Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            tag,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Rating stars
        Row(
          children: [
            ...List.generate(4, (index) => const Icon(
              Icons.star, 
              color: Colors.amber, 
              size: 20,
            )),
            const Icon(Icons.star_border, color: Colors.amber, size: 20),
            const SizedBox(width: 8),
            Text(
              '4.5 (50 đánh giá)',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        // Address
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.red, size: 16),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                'Số 1 đường Nguyễn Văn Bảo, Phường 4, Gò Vấp, Hồ Chí Minh',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVoucherSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Text(
            'Voucher',
            style: TextStyle(
              color: Colors.amber,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            'Liên hệ ngay',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white.withOpacity(0.8),
            size: 14,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Đánh giá',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.8),
              size: 16,
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Sample reviews
        ...List.generate(2, (index) => _buildReviewItem()),
      ],
    );
  }

  Widget _buildReviewItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, color: Colors.white),
          ),
          
          const SizedBox(width: 12),
          
          // Review content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'My Linh Khoang in truoc',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: List.generate(5, (index) => const Icon(
                        Icons.star, 
                        color: Colors.amber, 
                        size: 12,
                      )),
                    ),
                  ],
                ),
                
                const SizedBox(height: 4),
                
                Text(
                  'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem...',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => _handleBackNavigation(context),
      ),
    );
  }
  void _handleBackNavigation(BuildContext context) {
     if(GoRouter.of(context).canPop()) {
       context.pop();
     } else {
       print('No back route available');
       context.goNamed('home');
     }
  }
  Widget _buildShareButton() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(Icons.share, color: Colors.white),
        onPressed: () {
          // Share functionality
        },
      ),
    );
  }

  Widget _buildFloatingElements() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 30,
          children: [
            // Home button
            _buildBottomNavButton(Icons.home, () {}),
            const SizedBox(width: 20),
            // Search button  
            _buildBottomNavButton(Icons.search, () {}),
            const SizedBox(width: 20),
            // Profile button
            _buildBottomNavButton(Icons.person, () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF8B4513),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
