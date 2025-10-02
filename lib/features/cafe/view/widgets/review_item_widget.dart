import 'package:briewview/core/utils/ShowImage.dart';
import 'package:briewview/features/cafe/model/review.dart';
import 'package:flutter/material.dart';

class ReviewItemWidget extends StatelessWidget {
  final Review review;

  const ReviewItemWidget({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info and Rating
          _buildUserInfo(),
          const SizedBox(height: 12),
          // Review Content
          _buildReviewContent(),
          // Review Media (if any)
          if (review.medias != null && review.medias!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildReviewMedia(),
          ],
          const SizedBox(height: 12),
          // Action Buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage:
              review.userAvatarUrl != null
                  ? NetworkImage(review.userAvatarUrl!)
                  : null,
          backgroundColor: Colors.grey[300],
          child:
              review.userAvatarUrl == null
                  ? const Icon(Icons.person, color: Colors.white)
                  : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                review.userName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  ...List.generate(5, (index) {
                    // Ensure rating is within valid range (1-5)
                    final safeRating = review.rating.clamp(1, 5);
                    return Icon(
                      Icons.star,
                      size: 14,
                      color:
                          index < safeRating
                              ? Colors.amber[600]
                              : Colors.grey[300],
                    );
                  }),
                  const SizedBox(width: 6),
                  Text(
                    '${review.rating.clamp(1, 5)}/5',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Text(
          _formatDate(review.createdAt),
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
      ],
    );
  }

  Widget _buildReviewContent() {
    return Text(
      review.content,
      style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
    );
  }

  Widget _buildReviewMedia() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: review.medias!.length,
        itemBuilder: (context, index) {
          final media = review.medias![index];
          return Container(
            margin: const EdgeInsets.only(right: 8),
            width: 80,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child:
                media.url != null
                    ? ShowImage.get(media.url!)
                    : const Icon(Icons.image, color: Colors.grey),
          );
        },
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        _buildActionButton(Icons.thumb_up_outlined, 'Hữu ích'),
        const SizedBox(width: 16),
        _buildActionButton(Icons.reply_outlined, 'Trả lời'),
        const Spacer(),
        _buildActionButton(Icons.more_vert, ''),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.grey[600]),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }
}
