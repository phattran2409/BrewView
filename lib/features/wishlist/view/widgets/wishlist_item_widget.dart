import 'package:briewview/features/cafe/model/cafeMode.dart';
import 'package:flutter/material.dart';

class WishlistItemWidget extends StatelessWidget {
  final CafeModel cafe;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const WishlistItemWidget({
    super.key,
    required this.cafe,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 52, 36, 18),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cafe image
                _buildCafeImage(),
                const SizedBox(width: 12),
                
                // Cafe info
                Expanded(
                  child: _buildCafeInfo(),
                ),
                
                // Remove button
                _buildRemoveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCafeImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[800],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: cafe.imageUrl != null && cafe.imageUrl!.isNotEmpty
            ? Image.network(
                cafe.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[800],
                    child: const Icon(
                      Icons.local_cafe,
                      color: Colors.white,
                      size: 32,
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[800],
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
              )
            : Container(
                color: Colors.grey[800],
                child: const Icon(
                  Icons.local_cafe,
                  color: Colors.white,
                  size: 32,
                ),
              ),
      ),
    );
  }

  Widget _buildCafeInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cafe name
        Text(
          cafe.name ?? 'Tên không xác định',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        
        // Address
        Text(
          cafe.address ?? 'Địa chỉ không xác định',
          style: TextStyle(
            color: const Color.fromARGB(255, 255, 255, 255),
            fontSize: 12,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        
        // Rating and price
        Row(
          children: [
            // Rating
            if (cafe.rating != null && cafe.rating! > 0) ...[
              const Icon(
                Icons.star,
                color: Colors.amber,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                cafe.rating!.toStringAsFixed(1),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 12),
            ],
            
            // Price range
            if (cafe.priceMin != null && cafe.priceMax != null) ...[
              Text(
                '${_formatPrice(cafe.priceMin!)} - ${_formatPrice(cafe.priceMax!)}',
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
        
        const SizedBox(height: 4),
        
        // Opening hours
        if (cafe.openingTime != null && cafe.closingTime != null) ...[
          Text(
            '${cafe.openingTime} - ${cafe.closingTime}',
            style: TextStyle(
              color: const Color.fromARGB(255, 255, 253, 253),
              fontSize: 11,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRemoveButton() {
    return IconButton(
      onPressed: onRemove,
      icon: const Icon(
        Icons.remove_circle,
        color: Colors.orange,
        size: 30,
      ),
      tooltip: 'Xóa khỏi danh sách yêu thích',
    );
  }

  String _formatPrice(int price) {
    if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)}k';
    }
    return price.toString();
  }
}
