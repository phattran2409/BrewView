import 'package:briewview/core/utils/ShowImage.dart';
import 'package:briewview/core/utils/priceFormatter.dart';
import 'package:flutter/material.dart';
import 'package:briewview/core/widgets/dotIndicator.dart';
import 'package:go_router/go_router.dart';

class NearbyCoffeeShop extends StatefulWidget {
  final List<Map<String, dynamic>> coffeeShops;
  const NearbyCoffeeShop({super.key, required this.coffeeShops});
  
  @override
  _NearbyCoffeeShopState createState() => _NearbyCoffeeShopState();
}

class _NearbyCoffeeShopState extends State<NearbyCoffeeShop> {
  final PageController _pageController = PageController(); 
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    // ✅ Calculate total pages (4 items per page in 2x2 grid)
    final totalPages = (widget.coffeeShops.length / 4).ceil();
    
    return Column(
      children: [
        // ✅ PageView với 2x2 grid layout
        Column(
        
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20 , bottom: 10),
              child: Text(
                'Quán cà phê gần bạn',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),  
            Container(
              height: 420, // Increased for 2 rows
              padding: EdgeInsets.only(left: 10, right: 10),
              child: PageView.builder(
                controller: _pageController,
                itemCount: totalPages,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemBuilder: (context, pageIndex) {
                  return _buildPageWith2x2Grid(pageIndex);
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),

        // ✅ Dot Indicator
        if (totalPages > 1)
          DotIndicator(
            currentIndex: currentPage,
            dotCount: totalPages,
            pageController: _pageController,
            activeColor: Colors.white,
            inactiveColor: Colors.grey[600],
            activeWidth: 24,
            inactiveWidth: 8,
            height: 8,
            spacing: 4,
          ),
      ],
    );
  }

  Widget _buildPageWith2x2Grid(int pageIndex) {
    final startIndex = pageIndex * 4;
    final pageItems = <Map<String, dynamic>>[];
    
    // Get up to 4 items for this page
    for (int i = startIndex; i < startIndex + 4 && i < widget.coffeeShops.length; i++) {
      pageItems.add(widget.coffeeShops[i]);
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          // ✅ Top row (2 cards)
          Expanded(
            child: Row(
              children: [
                // Top Left Card
                Expanded(
                  child: pageItems.isNotEmpty 
                      ? _buildCoffeeShopCard(pageItems[0])
                      : Container(),
                ),
                const SizedBox(width: 12),
                // Top Right Card
                Expanded(
                  child: pageItems.length > 1 
                      ? _buildCoffeeShopCard(pageItems[1])
                      : Container(),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12), // Space between rows
          
          // ✅ Bottom row (2 cards)
          Expanded(
            child: Row(
              children: [
                // Bottom Left Card
                Expanded(
                  child: pageItems.length > 2 
                      ? _buildCoffeeShopCard(pageItems[2])
                      : Container(),
                ),
                const SizedBox(width: 12),
                // Bottom Right Card
                Expanded(
                  child: pageItems.length > 3 
                      ? _buildCoffeeShopCard(pageItems[3])
                      : Container(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Enhanced individual coffee shop card
  Widget _buildCoffeeShopCard(Map<String, dynamic> coffeeShop) {
    return GestureDetector(
      onTap: () {
       context.goNamed('cafe-detail', pathParameters: {'id': coffeeShop['cafeId'] ?? ''});
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image
              coffeeShop['imageUrl'] != null 
                  ? ShowImage.get(coffeeShop['imageUrl'] ?? '')
                  : ShowImage.asset('assets/images/placeholder.png'), 

              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              

              // Rating Badge (Top Right)
              if (coffeeShop['rating'] != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(10),
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
                          '${coffeeShop['rating']}',
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

              // Distance Badge (Top Left)
              if (coffeeShop['distance'] != null)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF763C0C).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${coffeeShop['distance']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              // Coffee Shop Info (Bottom)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        coffeeShop['name'] ?? 'Quán cà phê',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Type or Address
                          Expanded(
                            child: Text(
                              coffeeShop['type'] ?? 'Cà phê',
                              style: TextStyle(
                                color: Colors.grey[300],
                                fontSize: 10,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Price
                          Text(
                           '${PriceFormatter.formatWithSymbol(coffeeShop['priceMin'] ?? 0)} - ${PriceFormatter.formatWithSymbol(coffeeShop['priceMax'] ?? 0)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}