import 'package:briewview/core/utils/ShowImage.dart';
import 'package:briewview/core/utils/priceFormatter.dart';
import 'package:briewview/core/widgets/dotIndicator.dart';
import 'package:briewview/features/cafe/model/cafeMode.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RecomendationWidget extends StatefulWidget {
  const RecomendationWidget({super.key, required this.recommendations});
  final List<CafeModel> recommendations;
  @override
  State<RecomendationWidget> createState() => _RecomendationWidgetState();
}

class _RecomendationWidgetState extends State<RecomendationWidget> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Section Title
          Row(
            spacing: 10,
            children: [
              Text(
                'Recommendation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              if (widget.recommendations.length > 1)
                Text(
                  '${_currentIndex + 1}/${widget.recommendations.length}',
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
            ],
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 250, // Fixed height for the card
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: widget.recommendations.length,
              itemBuilder: (context, index) {
                return Padding(
                  // Space between cards
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: _buildFeaturedCafeCard(widget.recommendations[index]),
                );
              },
            ),
          ),

          const SizedBox(height: 20),
          DotIndicator(
            currentIndex: _currentIndex,
            dotCount: widget.recommendations.length,
            pageController: _pageController,
            onDotTap: (index) {
               print('Tapped on dot $index');
            },
          ),
        ],
      ),
    );
  }


  Widget _buildFeaturedCafeCard(CafeModel cafe) {
    return GestureDetector(
      onTap: () {
        // Handle card tap
        print('Tapped on ${cafe.cafeId}');
        context.goNamed('cafe-detail', pathParameters: {'id': cafe.cafeId ?? ''});
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Food Image
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child:ShowImage.isValidImageUrl(cafe.imageUrl ?? '')
                    ? ShowImage.get(cafe.imageUrl ?? '')
                    : ShowImage.asset('assets/images/placeholder.png'),
              ),
            ),

            // ✅ Favorite Button (Top Right)
            Positioned(
              top: 12,
              right: 12,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    // cafe.isFavorite = !cafe.isFavorite;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    // cafe.isFavorite == true
                    //     ? Icons.favorite
                    //     : Icons.favorite_border,
                      Icons.favorite,   
                    color:
                        // cafe.isFavorite == true ? Colors.red : Colors.white,
                        Colors.red,
                    size: 20,
                  ),
                ),
              ),
            ),

            // Food Details (Bottom)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.9),
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(15),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      cafe.name ?? 'N/A',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${cafe.rating ?? 0.0}',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Text(
                          '${PriceFormatter.formatWithSymbol(cafe.priceMin ?? 0)} - ${PriceFormatter.formatWithSymbol(cafe.priceMax ?? 0)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ✅ Card Index Badge (Top Left)
            // Positioned(
            //   top: 12,
            //   left: 12,
            //   child: Container(
            //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            //     decoration: BoxDecoration(
            //       color: Colors.black.withOpacity(0.6),
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //     child: Text(
            //       '${widget.recommendations.indexOf(cafe) + 1}',
            //       style: const TextStyle(
            //         color: Colors.white,
            //         fontSize: 12,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
