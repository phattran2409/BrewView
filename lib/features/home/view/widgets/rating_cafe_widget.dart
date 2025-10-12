import 'package:briewview/core/utils/priceFormatter.dart';
import 'package:flutter/material.dart';
import 'package:briewview/features/cafe/model/cafeMode.dart';
import 'package:go_router/go_router.dart';

class RatingCafeWidget extends StatelessWidget {
  final List<CafeModel> cafes;

  const RatingCafeWidget({super.key, required this.cafes});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Quán được đánh giá cao',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to all cafes page
                },
                child: const Text(
                  'Xem tất cả',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
            ],
          ),
        ),

        // Cafes list
        SizedBox(
          height: 200, // Fixed height for horizontal scrolling
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: cafes.length,
            itemBuilder: (context, index) {
              final cafe = cafes[index];
              return _buildCafeCard(context, cafe);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCafeCard(BuildContext context, CafeModel cafe) {
    return GestureDetector(
      onTap: () {
          context.goNamed('cafe-detail', pathParameters: {'id': cafe.cafeId ?? ''});
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    image:
                        cafe.imageUrl != null
                            ? DecorationImage(
                              image: NetworkImage(cafe.imageUrl!),
                              fit: BoxFit.cover,
                            )
                            : const DecorationImage(
                              image: AssetImage('assets/images/coffe_shop_1.jpg'),
                              fit: BoxFit.cover,
                            ),
                  ),
                  child: Stack(
                    children: [
                      // Rating badge
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 12,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                cafe.rating?.toStringAsFixed(1) ?? '0.0',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      
              // Content section
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Cafe name
                      Text(
                        cafe.name ?? 'N/A',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
      
                      const SizedBox(height: 4),
      
                      // Address
                      Expanded(
                        child: Text(
                          cafe.address ?? 'N/A',
                          style: TextStyle(color: Colors.grey[600], fontSize: 11),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
      
                      // Price range
                      if (cafe.priceMin != null && cafe.priceMax != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                           '${PriceFormatter.formatWithSymbol(cafe.priceMin ?? 0)} - ${PriceFormatter.formatWithSymbol(cafe.priceMax ?? 0)}', 
                            style: TextStyle(
                              color: Colors.green[700],
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
