import 'package:briewview/app/theme/app_color.dart';
import 'package:briewview/core/widgets/navigation_bar.dart';
import 'package:briewview/features/home/view/widgets/NearbyCoffeShop_widget.dart';
import 'package:briewview/features/home/view/widgets/Recomendation_widget.dart';
import 'package:flutter/material.dart';
import 'package:briewview/core/widgets/wave_clipper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedCategoryIndex = 0;
  final List<String> _categories = ['All', 'Salad', 'Donuts', 'Pizza', 'Pasta'];
  final List<Map<String, dynamic>> _recommendations = [
    {
      'name': 'Civetta',
      'rating': 4.5,
      'reviews': '13k',
      'price': '80.00',
      'image': 'assets/images/coffe_shop_1.jpg',
      'isFavorite': true,
    },
    {
      'name': 'Creamy Salad',
      'rating': 4.2,
      'reviews': '8k',
      'price': '45.00',
      'image': 'assets/images/coffe_shop_2.jpg',
      'isFavorite': false,
    },
    {
      'name': 'Pepperoni Pizza',
      'rating': 4.8,
      'reviews': '12k',
      'price': '90.00',
      'image': 'assets/images/coffe_shop_3.jpg',
      'isFavorite': true,
    },
    {
      'name': 'Pasta Primavera',
      'rating': 4.6,
      'reviews': '10k',
      'price': '70.00',
      'image': 'assets/images/coffe_shop_3.jpg',
      'isFavorite': false,
    },
  ];

  final List<Map<String, dynamic>> _nearbyCoffeShop = [
    {
      'name': 'Nearby Coffee Shop 1',
      'distance': '1.2 km',
      'address': '123 Main St, City',
      'image': 'assets/images/coffe_shop_1.jpg',
    },
    {
      'name': 'Nearby Coffee Shop 2',
      'distance': '2.5 km',
      'address': '456 Elm St, City',
      'image': 'assets/images/coffe_shop_2.jpg',
    },
    {
      'name': 'Nearby Coffee Shop 3',
      'distance': '800 m',
      'address': '789 Oak St, City',
      'image': 'assets/images/coffe_shop_3.jpg',
    },
    {
      'name': 'Nearby Coffee Shop 4',
      'distance': '1.5 km',
      'address': '321 Pine St, City',
      'image': 'assets/images/coffe_shop_4.jpg',
    },
    {
      'name': 'Nearby Coffee Shop 5',
      'distance': '2.0 km',
      'address': '654 Maple St, City',
      'image': 'assets/images/coffe_shop_5.jpg',
    },
    {
      'name' : 'Nearby Coffee Shop 6',
      'distance' : '1.0 km',
      'address' : '987 Cedar St, City',
      'image' : 'assets/images/coffe_shop_6.jpg',
    },
    {
        'name' : 'Nearby Coffee Shop 7',
        'distance' : '1.0 km',
        'address' : '987 Cedar St, City',
        'image' : 'assets/images/coffe_shop_6.jpg',
    },
    {
      'name' : 'Nearby Coffee Shop 8',
      'distance' : '1.0 km',
      'address' : '987 Cedar St, City',
      'image' : 'assets/images/coffe_shop_6.jpg',
    },
    {
      'name' : 'Nearby Coffee Shop 9',
      'distance' : '1.0 km',
      'address' : '987 Cedar St, City',
      'image' : 'assets/images/coffe_shop_6.jpg',
    }

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColor.primaryGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header Section with User Info
              _buildHeaderSection(),

              // Search and Filters Section
              _buildSearchAndFilters(),

              // Recommendations Section
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RecomendationWidget(recommendations: _recommendations),
                      NearbyCoffeeShop(coffeeShops: _nearbyCoffeShop)
                    ],
                  ),
                ),
              ),

              // Bottom Navigation
              const CustomNavigationBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // User Profile Picture
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24, width: 2),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/user_profile.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.person, color: Colors.white, size: 30),
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 15),

          // User Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back',
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  'Hello, James',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Notification Bell
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  // Handle notifications
                },
                icon: Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Search Bar
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.grey.shade800),
            ),
            child: Row(
              children: [
                const SizedBox(width: 20),
                Icon(Icons.search, color: Colors.grey[400], size: 24),
                const SizedBox(width: 15),
                Expanded(
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'What did you eat today?',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Handle filter
                  },
                  icon: Icon(Icons.tune, color: Colors.grey[400], size: 24),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Category Filters
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final isSelected = index == _selectedCategoryIndex;
                return Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategoryIndex = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              isSelected ? Colors.white : Colors.grey.shade700,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _categories[index],
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.white,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'Recommendation',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          // Featured Food Card
          _buildFeaturedFoodCard(_recommendations[0]),

          const SizedBox(height: 20),

          // More Recommendations
          _buildMoreRecommendations(),
        ],
      ),
    );
  }

  Widget _buildFeaturedFoodCard(Map<String, dynamic> food) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey[900]!, Colors.grey[800]!],
        ),
      ),
      child: Stack(
        children: [
          // Background Text
          Positioned(
            left: 20,
            top: 20,
            child: Text(
              food['name'],
              style: TextStyle(
                color: Colors.white.withOpacity(0.1),
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Rating and Reviews
          Positioned(
            left: 20,
            top: 20,
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 5),
                Text(
                  '${food['rating']} (${food['reviews']} reviews)',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Favorite Button
          Positioned(
            right: 20,
            top: 20,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  food['isFavorite'] = !food['isFavorite'];
                });
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: food['isFavorite'] ? Colors.white : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: food['isFavorite'] ? Colors.white : Colors.white24,
                    width: 1,
                  ),
                ),
                child: Icon(
                  food['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                  color: food['isFavorite'] ? Colors.black : Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),

          // Food Name
          Positioned(
            left: 20,
            bottom: 60,
            child: Text(
              food['name'],
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Price
          Positioned(
            left: 20,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Starting price',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
                Text(
                  '\$${food['price']}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Food Image
          Positioned(
            right: 20,
            bottom: 20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: AssetImage(food['image']),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {
                    // Handle image error
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreRecommendations() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _recommendations.length - 1,
        itemBuilder: (context, index) {
          final food = _recommendations[index + 1];
          return Container(
            width: 150,
            margin: const EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              color: Colors.amber[100],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(
              children: [
                // Food Image
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage(food['image']),
                        fit: BoxFit.cover,
                        onError: (exception, stackTrace) {
                          // Handle image error
                        },
                      ),
                    ),
                  ),
                ),

                // Food Info
                Positioned(
                  left: 15,
                  bottom: 15,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        food['name'],
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 5),
                          Text(
                            '${food['rating']}',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


