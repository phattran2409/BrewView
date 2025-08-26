import 'package:flutter/material.dart';
import 'package:briewview/features/home/view/home_page.dart';
import 'package:briewview/features/home/model/user_info.dart';
import 'package:briewview/features/home/model/food_item.dart';

/// Demo page showing how to use the HomePage
class HomePageDemo extends StatelessWidget {
  const HomePageDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrewView Home Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        brightness: Brightness.dark,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Example of how to create sample data for the home page
class HomePageData {
  static UserInfo getSampleUser() {
    return UserInfo(
      id: '1',
      name: 'James Wilson',
      email: 'james.wilson@example.com',
      profileImageUrl: 'assets/images/user_profile.png',
      phoneNumber: '+1-555-0123',
      lastLoginAt: DateTime.now().subtract(const Duration(hours: 2)),
      preferences: ['Italian', 'Pizza', 'Pasta', 'Salad'],
      totalOrders: 47,
      totalSpent: 1250.75,
    );
  }

  static List<FoodItem> getSampleFoodItems() {
    return [
      FoodItem(
        id: '1',
        name: 'Civetta',
        description:
            'Authentic Italian spaghetti bolognese with rich meat sauce, fresh herbs, and grated parmesan cheese.',
        price: 80.00,
        rating: 4.5,
        reviewCount: 13000,
        imageUrl: 'assets/images/food_civetta.png',
        categories: ['Italian', 'Pasta', 'Main Course'],
        ingredients: [
          'Spaghetti',
          'Ground Beef',
          'Tomato Sauce',
          'Onions',
          'Garlic',
          'Herbs',
          'Parmesan',
        ],
        preparationTime: 25,
        chefName: 'Chef Marco',
        nutritionInfo: {'calories': 650, 'protein': 28, 'carbs': 85, 'fat': 22},
      ),
      FoodItem(
        id: '2',
        name: 'Creamy Salad',
        description:
            'Fresh mixed greens with creamy dressing, cherry tomatoes, cucumber, and croutons.',
        price: 45.00,
        rating: 4.2,
        reviewCount: 8000,
        imageUrl: 'assets/images/food_salad.png',
        categories: ['Salad', 'Healthy', 'Appetizer'],
        ingredients: [
          'Mixed Greens',
          'Cherry Tomatoes',
          'Cucumber',
          'Croutons',
          'Creamy Dressing',
        ],
        preparationTime: 15,
        chefName: 'Chef Sarah',
        nutritionInfo: {'calories': 180, 'protein': 6, 'carbs': 12, 'fat': 14},
      ),
      FoodItem(
        id: '3',
        name: 'Margherita Pizza',
        description:
            'Classic Neapolitan pizza with fresh mozzarella, tomato sauce, and basil.',
        price: 65.00,
        rating: 4.7,
        reviewCount: 21000,
        imageUrl: 'assets/images/food_pizza.png',
        categories: ['Italian', 'Pizza', 'Main Course'],
        ingredients: [
          'Pizza Dough',
          'Tomato Sauce',
          'Fresh Mozzarella',
          'Basil',
          'Olive Oil',
        ],
        preparationTime: 20,
        chefName: 'Chef Antonio',
        nutritionInfo: {'calories': 850, 'protein': 35, 'carbs': 95, 'fat': 38},
      ),
      FoodItem(
        id: '4',
        name: 'Chocolate Donut',
        description: 'Freshly baked chocolate glazed donut with sprinkles.',
        price: 12.00,
        rating: 4.3,
        reviewCount: 5600,
        imageUrl: 'assets/images/food_donut.png',
        categories: ['Dessert', 'Bakery', 'Sweet'],
        ingredients: ['Flour', 'Sugar', 'Chocolate', 'Milk', 'Eggs', 'Butter'],
        preparationTime: 30,
        chefName: 'Chef Emma',
        nutritionInfo: {'calories': 320, 'protein': 4, 'carbs': 45, 'fat': 15},
      ),
    ];
  }

  static List<String> getSampleCategories() {
    return [
      'All',
      'Italian',
      'Pizza',
      'Pasta',
      'Salad',
      'Dessert',
      'Bakery',
      'Healthy',
      'Fast Food',
      'Asian',
      'Mexican',
      'American',
    ];
  }
}

/// Example of how to integrate with BLoC pattern
class HomePageWithBloc extends StatelessWidget {
  const HomePageWithBloc({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page with BLoC'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: const HomePage(),
    );
  }
}

/// Example of how to create a custom home page with different data
class CustomHomePage extends StatefulWidget {
  const CustomHomePage({super.key});

  @override
  State<CustomHomePage> createState() => _CustomHomePageState();
}

class _CustomHomePageState extends State<CustomHomePage> {
  late UserInfo _currentUser;
  late List<FoodItem> _foodItems;
  late List<String> _categories;
  int _selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // Simulate loading data from API or database
    _currentUser = HomePageData.getSampleUser();
    _foodItems = HomePageData.getSampleFoodItems();
    _categories = HomePageData.getSampleCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            _buildCustomHeader(),

            // Custom Search
            _buildCustomSearch(),

            // Custom Categories
            _buildCustomCategories(),

            // Custom Food Items
            Expanded(child: _buildCustomFoodItems()),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage:
                _currentUser.profileImageUrl != null
                    ? AssetImage(_currentUser.profileImageUrl!)
                    : null,
            child:
                _currentUser.profileImageUrl == null
                    ? Icon(Icons.person, color: Colors.white, size: 30)
                    : null,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back, ${_currentUser.name.split(' ').first}!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'You have ${_currentUser.totalOrders} orders',
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // Handle notifications
            },
            icon: Icon(Icons.notifications_outlined, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(25),
        ),
        child: TextField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search for food...',
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomCategories() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = index == _selectedCategoryIndex;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategoryIndex = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.orange : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.orange : Colors.grey[700]!,
                ),
              ),
              child: Text(
                _categories[index],
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCustomFoodItems() {
    final filteredItems =
        _selectedCategoryIndex == 0
            ? _foodItems
            : _foodItems
                .where(
                  (item) => item.categories.contains(
                    _categories[_selectedCategoryIndex],
                  ),
                )
                .toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(item.imageUrl),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) {
                      // Handle image error
                    },
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item.description,
                      style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 5),
                        Text(
                          '${item.rating} (${item.formattedReviewCount})',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          item.formattedPrice,
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
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
    );
  }
}
