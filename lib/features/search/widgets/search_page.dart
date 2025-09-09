import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final List<Map<String, dynamic>> _nearbyCoffeeShop = [
    {
      'id': '1',
      'name': 'Nearby Coffee Shop 1',
      'distance': '1.2 km',
      'address': '123 Main St, City',
      'image': 'assets/images/coffee_shop_1.jpg',
    },
    {
      'id': '2',
      'name': 'Nearby Coffee Shop 2',
      'distance': '2.5 km',
      'address': '456 Elm St, City',
      'image': 'assets/images/coffee_shop_2.jpg',
    },
    {
      'id': '3',
      'name': 'Nearby Coffee Shop 3',
      'distance': '800 m',
      'address': '789 Oak St, City',
      'image': 'assets/images/coffe_shop_3.jpg',
    },
    {
      'id': '4',
      'name': 'Nearby Coffee Shop 4',
      'distance': '1.5 km',
      'address': '321 Pine St, City',
      'image': 'assets/images/coffe_shop_4.jpg',
    },
    {
      'id': '5',
      'name': 'Nearby Coffee Shop 5',
      'distance': '2.0 km',
      'address': '654 Maple St, City',
      'image': 'assets/images/coffe_shop_5.jpg',
    },
    {
      'id': '6',
      'name': 'Nearby Coffee Shop 6',
      'distance': '1.0 km',
      'address': '987 Cedar St, City',
      'image': 'assets/images/coffe_shop_6.jpg',
    },
    {
      'id': '7',
      'name': 'Nearby Coffee Shop 7',
      'distance': '1.0 km',
      'address': '987 Cedar St, City',
      'image': 'assets/images/coffe_shop_6.jpg',
    },
    {
      'id': '8',
      'name': 'Nearby Coffee Shop 8',
      'distance': '1.0 km',
      'address': '987 Cedar St, City',
      'image': 'assets/images/coffe_shop_6.jpg',
    },
    {
      'id': '9',
      'name': 'Nearby Coffee Shop 9',
      'distance': '1.0 km',
      'address': '987 Cedar St, City',
      'image': 'assets/images/coffe_shop_6.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Container(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildSearchAndFilters(),
            // Add more widgets here for search results, etc.
            _buildListView(),
          ],
        ),
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
        ],
      ),
    );
  }

  Widget _buildListView() {
    return Expanded(
      child: ListView.builder(
        itemCount: _nearbyCoffeeShop.length,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: _buildCafeCard(_nearbyCoffeeShop[index]),
          );
        },
      ),
    );
  }

  Widget _buildCafeCard(Map<String, dynamic>? cafeData) {
    return GestureDetector(
      onTap: () {
         context.pushNamed(
          'cafe-detail',
          pathParameters: {'id': cafeData?['id'] ?? '0'},
          extra: cafeData,
         );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cafeData?['name'] ?? 'Unknown Cafe',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(cafeData?['description'] ?? 'No description available.'),
            ],
          ),
        ),
      ),
    );
  }
}
