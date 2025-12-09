import 'package:briewview/features/premium/model/premium_plan_model.dart';

class PremiumData {
  // Hardcoded premium plans data
  static List<PremiumPlanModel> getPremiumPlans() {
    return [
      PremiumPlanModel(
        id: 'basic_monthly',
        name: 'Premium',
        description: 'Tất cả tính năng trong 1 tháng',
        price: 29000,
        currency: 'VND',
        durationDays: 30,
        features: [
          'Không quảng cáo',
          'Đăng bài và đánh giá chi tiết',
          'Lưu không giới hạn quán yêu thích',
          'Hỗ trợ qua email',
        ],
        isPopular: false,
      ),
      PremiumPlanModel(
        id: 'premium_monthly',
        name: 'Premium owner for cafes',
        description: 'Nổi bật - Tất cả tính năng trong 1 tháng',
        price: 149000,
        currency: 'VND',
        durationDays: 30,
        features: [
          'Không quảng cáo',
          'Xem đánh giá chi tiết',
          'Lưu không giới hạn quán yêu thích',
          'Nhận thông báo ưu đãi',
          'Hỗ trợ 24/7',
          'Tính năng độc quyền',
        ],
        isPopular: true,
        originalPrice: '199000',
        discountPercentage: 25,
      ),
      // PremiumPlanModel(
      //   id: 'premium_yearly',
      //   name: 'Gói Premium Năm',
      //   description: 'Tiết kiệm nhất - Thanh toán 1 lần',
      //   price: 1290000,
      //   currency: 'VND',
      //   durationDays: 365,
      //   features: [
      //     'Tìm kiếm không giới hạn',
      //     'Xem đánh giá chi tiết',
      //     'Lưu không giới hạn quán yêu thích',
      //     'Nhận thông báo ưu đãi',
      //     'Hỗ trợ 24/7',
      //     'Tính năng độc quyền',
      //     'Ưu đãi đặc biệt',
      //     'Quà tặng độc quyền',
      //   ],
      //   isPopular: false,
      //   originalPrice: '1788000',
      //   discountPercentage: 28,
      // ),
      // PremiumPlanModel(
      //   id: 'vip_lifetime',
      //   name: 'Gói VIP Trọn Đời',
      //   description: 'Một lần thanh toán, sử dụng mãi mãi',
      //   price: 2990000,
      //   currency: 'VND',
      //   durationDays: 36500, // 100 years
      //   features: [
      //     'Tất cả tính năng Premium',
      //     'Sử dụng trọn đời',
      //     'Hỗ trợ VIP 24/7',
      //     'Tính năng beta sớm nhất',
      //     'Quà tặng độc quyền hàng tháng',
      //     'Ưu đãi đặc biệt từ đối tác',
      //     'Tư vấn cá nhân',
      //   ],
      //   isPopular: false,
      //   originalPrice: '5990000',
      //   discountPercentage: 50,
      // ),
    ];
  }

  // Mock user subscription status
  static bool hasUserPremiumAccess() {
    // For testing, return false to show premium popup
    return false;
  }

  // Mock current subscription
  static Map<String, dynamic>? getCurrentSubscription() {
    // For testing, return null (no active subscription)
    return null;
  }
}
