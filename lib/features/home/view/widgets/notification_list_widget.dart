import 'package:briewview/features/home/model/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationListWidget extends StatefulWidget {
  const NotificationListWidget({super.key});

  @override
  State<NotificationListWidget> createState() => _NotificationListWidgetState();
}

class _NotificationListWidgetState extends State<NotificationListWidget> {
  // Mock data cho notifications
  List<NotificationModel> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Vừa xong';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks tuần trước';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months tháng trước';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years năm trước';
    }
  }

  void _loadNotifications() {
    final now = DateTime.now();
    _notifications = [
      NotificationModel(
        id: '1',
        title: '🎉 Khuyến mãi đặc biệt!',
        description:
            'Giảm 30% cho tất cả các đồ uống khi đặt qua ứng dụng. Áp dụng từ 14h-16h hàng ngày.',
        type: NotificationType.promotion,
        timestamp: now.subtract(const Duration(hours: 2)),
        actionLabel: 'Khám phá quán',
        actionRoute: '/search',
      ),
      NotificationModel(
        id: '2',
        title: '👑 Nâng cấp Premium ngay!',
        description:
            'Trải nghiệm không quảng cáo, đánh giá chi tiết và nhiều ưu đãi độc quyền. Chỉ 99.000đ/tháng!',
        type: NotificationType.premium,
        timestamp: now.subtract(const Duration(hours: 5)),
        actionLabel: 'Nâng cấp',
        actionRoute: '/premium-plans',
      ),
      NotificationModel(
        id: '3',
        title: '☕ Khuyến mãi cuối tuần',
        description:
            'Mua 2 tặng 1 cho tất cả các loại cafe. Áp dụng từ thứ 7 đến Chủ nhật.',
        type: NotificationType.promotion,
        timestamp: now.subtract(const Duration(days: 1)),
        actionLabel: 'Xem bản đồ',
        actionRoute: '/map',
      ),
      NotificationModel(
        id: '4',
        title: '💎 Đặc quyền Premium',
        description:
            'Thành viên Premium nhận thêm 10% giảm giá tại tất cả các quán cafe đối tác.',
        type: NotificationType.premium,
        timestamp: now.subtract(const Duration(days: 2)),
        actionLabel: 'Tìm hiểu thêm',
        actionRoute: '/premium-demo',
      ),
      NotificationModel(
        id: '5',
        title: '🎁 Ưu đãi sinh nhật',
        description:
            'Nhận voucher giảm 50% vào tháng sinh nhật của bạn. Đăng ký Premium để nhận ngay!',
        type: NotificationType.promotion,
        timestamp: now.subtract(const Duration(days: 3)),
        actionLabel: 'Đăng ký ngay',
        actionRoute: '/premium-plans',
      ),
      NotificationModel(
        id: '6',
        title: '🌟 Điểm thưởng tích lũy',
        description:
            'Thành viên Premium nhận gấp đôi điểm thưởng cho mỗi giao dịch.',
        type: NotificationType.premium,
        timestamp: now.subtract(const Duration(days: 4)),
        actionLabel: 'Xem demo',
        actionRoute: '/premium-demo',
      ),
      NotificationModel(
        id: '7',
        title: '🔥 Flash Sale!',
        description:
            'Giảm 40% cho menu đặc biệt. Chỉ trong hôm nay! Nhanh tay đặt ngay.',
        type: NotificationType.promotion,
        timestamp: now.subtract(const Duration(days: 5)),
        actionLabel: 'Tìm quán ngay',
        actionRoute: '/search',
      ),
      NotificationModel(
        id: '8',
        title: '📝 Chia sẻ trải nghiệm',
        description:
            'Đọc và chia sẻ những bài viết review từ cộng đồng yêu thích cafe.',
        type: NotificationType.general,
        timestamp: now.subtract(const Duration(days: 6)),
        actionLabel: 'Xem bài viết',
        actionRoute: '/posts',
      ),
      NotificationModel(
        id: '9',
        title: '❤️ Danh sách yêu thích',
        description:
            'Bạn có 5 quán cafe trong danh sách yêu thích. Hãy ghé thăm chúng nhé!',
        type: NotificationType.general,
        timestamp: now.subtract(const Duration(days: 7)),
        actionLabel: 'Xem danh sách',
        actionRoute: '/wishlist',
      ),
    ];
  }

  void _markAsRead(String id) {
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      _notifications =
          _notifications.map((n) => n.copyWith(isRead: true)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount =
        _notifications.where((n) => !n.isRead).length;

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A1A1A), Color(0xFF0D0D0D)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Thông báo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (unreadCount > 0) ...[
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$unreadCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                TextButton(
                  onPressed: _markAllAsRead,
                  child: Text(
                    'Đánh dấu đã đọc',
                    style: TextStyle(
                      color: Colors.blue[300],
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Notification List
          Expanded(
            child: _notifications.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      final notification = _notifications[index];
                      return _buildNotificationCard(notification);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: Colors.grey[700],
          ),
          const SizedBox(height: 16),
          Text(
            'Không có thông báo mới',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel notification) {
    final isPromotion = notification.type == NotificationType.promotion;
    final isPremium = notification.type == NotificationType.premium;

    return GestureDetector(
      onTap: () {
        _markAsRead(notification.id);
        if (notification.actionRoute != null) {
          context.pop();
          context.push(notification.actionRoute!);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: notification.isRead
                ? [Colors.grey[900]!, Colors.grey[850]!]
                : isPromotion
                    ? [
                        const Color(0xFF2D1B1B),
                        const Color(0xFF1A1010),
                      ]
                    : isPremium
                        ? [
                            const Color(0xFF2D2416),
                            const Color(0xFF1A1610),
                          ]
                        : [
                            Colors.grey[850]!,
                            Colors.grey[900]!,
                          ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: notification.isRead
                ? Colors.grey[800]!
                : isPromotion
                    ? Colors.red.withOpacity(0.3)
                    : isPremium
                        ? Colors.amber.withOpacity(0.3)
                        : Colors.grey[700]!,
            width: 1.5,
          ),
          boxShadow: [
            if (!notification.isRead)
              BoxShadow(
                color: isPromotion
                    ? Colors.red.withOpacity(0.1)
                    : isPremium
                        ? Colors.amber.withOpacity(0.1)
                        : Colors.transparent,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isPromotion
                          ? [Colors.red[400]!, Colors.red[600]!]
                          : isPremium
                              ? [Colors.amber[400]!, Colors.amber[700]!]
                              : [Colors.blue[400]!, Colors.blue[600]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isPromotion
                        ? Icons.local_offer
                        : isPremium
                            ? Icons.workspace_premium
                            : Icons.notifications,
                    color: Colors.white,
                    size: 24,
                  ),
                ),

                const SizedBox(width: 12),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: isPromotion
                                    ? Colors.red
                                    : isPremium
                                        ? Colors.amber
                                        : Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notification.description,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatTimeAgo(notification.timestamp),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          if (notification.actionLabel != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isPromotion
                                      ? [Colors.red[500]!, Colors.red[700]!]
                                      : isPremium
                                          ? [
                                              Colors.amber[500]!,
                                              Colors.amber[700]!
                                            ]
                                          : [
                                              Colors.blue[500]!,
                                              Colors.blue[700]!
                                            ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                notification.actionLabel!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

