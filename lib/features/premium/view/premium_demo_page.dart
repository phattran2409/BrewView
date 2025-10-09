import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:briewview/features/premium/view/widgets/premium_feature_button.dart';
import 'package:briewview/core/utils/premium_helper.dart';

class PremiumDemoPage extends StatelessWidget {
  const PremiumDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium Demo'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => context.push('/premium-plans'),
            icon: const Icon(Icons.star),
            tooltip: 'Premium Plans',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B4513), Color(0xFFD2691E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 48),
                  const SizedBox(height: 16),
                  const Text(
                    'Trải nghiệm Premium',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Chạm vào các nút bên dưới để xem popup Premium',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Premium Features Demo
            const Text(
              'Tính năng Premium',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Search Feature
            const Text(
              'Tìm kiếm nâng cao',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            PremiumSearchButton(
              onSearch: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đang thực hiện tìm kiếm nâng cao...'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Reviews Feature
            const Text(
              'Xem đánh giá chi tiết',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            PremiumReviewsButton(
              onViewReviews: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đang mở đánh giá chi tiết...'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Favorites Feature
            const Text(
              'Lưu yêu thích',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                PremiumFavoritesButton(
                  onAddToFavorites: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Đã thêm vào danh sách yêu thích!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                const Text('Chạm vào icon tim để lưu yêu thích'),
              ],
            ),
            const SizedBox(height: 24),

            // Custom Premium Feature
            const Text(
              'Tính năng tùy chỉnh',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            PremiumFeatureButton(
              feature: 'notifications',
              message: 'Nhận thông báo ưu đãi độc quyền với Premium!',
              onPremiumAccess: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đang bật thông báo ưu đãi...'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange[300]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.notifications, color: Colors.orange[700]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Nhận thông báo ưu đãi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Premium Badge Demo
            const Text(
              'Premium Badge',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                PremiumHelper.premiumBadge(text: 'Premium'),
                const SizedBox(width: 12),
                PremiumHelper.premiumBadge(text: 'VIP'),
                const SizedBox(width: 12),
                PremiumHelper.premiumBadge(text: 'Pro'),
              ],
            ),
            const SizedBox(height: 24),

            // Go to Premium Plans Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => context.push('/premium-plans'),
                icon: const Icon(Icons.star),
                label: const Text('Xem gói Premium'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 100), // Bottom padding
          ],
        ),
      ),
    );
  }
}
