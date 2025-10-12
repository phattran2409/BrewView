import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:briewview/features/premium/viewmodel/premium_bloc.dart';
import 'package:briewview/features/premium/viewmodel/premium_event.dart';

class PremiumPopupWidget extends StatelessWidget {
  final String feature;
  final String? message;

  const PremiumPopupWidget({super.key, required this.feature, this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF8B4513), // Brown
              Color(0xFFD2691E), // Chocolate
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Crown Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.star, color: Colors.amber, size: 48),
            ),
            const SizedBox(height: 16),

            // Title
            const Text(
              'Nâng cấp Premium',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Feature description
            Text(
              _getFeatureDescription(feature),
              style: const TextStyle(fontSize: 16, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Custom message if provided
            if (message != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  message!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Premium features list
            _buildFeaturesList(),
            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      context.read<PremiumBloc>().add(HidePremiumPopup());
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Colors.white70),
                      ),
                    ),
                    child: const Text(
                      'Để sau',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<PremiumBloc>().add(HidePremiumPopup());
                      context.push('/premium-plans');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.brown,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Nâng cấp ngay',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget _buildFeaturesList() {
    final features = [
      'Không quảng cáo',
      'Xem đánh giá chi tiết',
      'Lưu danh sách yêu thích',
      'Nhận thông báo ưu đãi',
      'Hỗ trợ 24/7',
    ];

    return Column(
      children:
          features
              .map(
                (feature) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feature,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
    );
  }

  String _getFeatureDescription(String feature) {
    switch (feature) {
      case 'search':
        return 'Bạn đã đạt giới hạn tìm kiếm miễn phí. Nâng cấp Premium để tìm kiếm không giới hạn!';
      case 'reviews':
        return 'Xem đánh giá chi tiết là tính năng Premium. Nâng cấp để trải nghiệm đầy đủ!';
      case 'favorites':
        return 'Lưu danh sách yêu thích là tính năng Premium. Nâng cấp để lưu không giới hạn!';
      case 'notifications':
        return 'Nhận thông báo ưu đãi độc quyền với Premium!';
      default:
        return 'Tính năng này chỉ dành cho thành viên Premium. Nâng cấp để sử dụng!';
    }
  }
}




