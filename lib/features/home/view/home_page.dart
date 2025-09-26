import 'package:briewview/app/di/locator.dart';
import 'package:briewview/app/theme/app_color.dart';
import 'package:briewview/core/network/user_storage_services.dart';
import 'package:briewview/core/utils/ShowImage.dart';
import 'package:briewview/core/widgets/navigation_bar.dart';
import 'package:briewview/features/cafe/model/cafeMode.dart';
import 'package:briewview/features/cafe/viewmodel/cafe_bloc.dart';
import 'package:briewview/features/cafe/viewmodel/cafe_event.dart';
import 'package:briewview/features/cafe/viewmodel/cafe_sate.dart';
import 'package:briewview/features/home/view/widgets/NearbyCoffeShop_widget.dart';
import 'package:briewview/features/home/view/widgets/Recomendation_widget.dart';
import 'package:briewview/features/home/view/widgets/rating_cafe_widget.dart';
import 'package:briewview/features/user_management/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CafeBloc _cafeBloc;
  // late ProfileBloc _profileBloc;
  UserModel? _currentUser;

  List<CafeModel> _recommendations = [];
  List<CafeModel> _nearbyCoffeeShop = [];
  List<CafeModel> _cafesRating = [];

  @override
  void initState() {
    super.initState();
    _cafeBloc = getIt<CafeBloc>();
    _loadCurrentUserAndCafes();
  }

  Future<void> _loadCurrentUserAndCafes() async {
    try{
      _currentUser = await getIt<UserStorageServices>().getCurrentUser();
    
       if  (mounted){
        setState(() {});
        final userId = _currentUser?.id ?? '';
        _cafeBloc.add(LoadRecommendedCafes(pageNumber: 1, pageSize: 5 ,userId: userId)); // Recommendations
        _cafeBloc.add(LoadCafesByDistance(pageNumber: 1, pageSize: 5)); // Nearby
        _cafeBloc.add(
          LoadCafesRating(
            pageNumber: 1,
            pageSize: 5,
            sortBy: 'rating',
            sortDirection: 'Descending',
          ),
        ); // Top Rated
      }
    }catch (e){
      // Handle error if needed
      print('Error loading user: $e');
       _cafeBloc.add(LoadCafes(pageNumber: 1, pageSize: 5)); // Load cafes without user context 
      _cafeBloc.add(LoadCafesByDistance(pageNumber: 1, pageSize: 5)); // Nearby
      _cafeBloc.add(LoadCafesRating(
            pageNumber: 1,
            pageSize: 5,
            sortBy: 'rating',
            sortDirection: 'Descending',
          ),
        ); // Top Rated 
    }
  }

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
                  child: BlocProvider(
                    create: (context) => _cafeBloc,
                    child: BlocConsumer<CafeBloc, CafeState>(
                      listener: (context, state) {
                        if (state is CafeError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }
                      },
                      builder: (context, state) {
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     RecomendationWidget(
                        //       recommendations:
                        //           _recommendations
                        //               .map((cafe) => cafe.toJson())
                        //               .toList(),
                        //     ),
                        //     NearbyCoffeeShop(
                        //       coffeeShops:
                        //           _nearbyCoffeeShop
                        //               .map((cafe) => cafe.toJson())
                        //               .toList(),
                        //     ),
                        //   ],
                        // ),
                        return SingleChildScrollView(
                          child: _buildContent(state),
                        );
                      },
                    ),
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

  Widget _buildContent(CafeState state) {
    if (state is CafeLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Handle different states and update corresponding lists
    // if (state is CafesLoaded) {
    //   _recommendations =  state.cafes;
    // }
    // if (state is CafesByDistanceLoaded) {
    //   _nearbyCoffeeShop = state.cafes;
    // }
    // if (state is CafesRatingLoaded) {
    //   _cafesRating =   state.cafes;
    // }

    // Show loading indicator if any of the lists are still empty
    // if (_recommendations.isEmpty ||
    //     _nearbyCoffeeShop.isEmpty ||
    //     _cafesRating.isEmpty) {
    //   return const Center(child: CircularProgressIndicator());
    // }
    if (state is CombinedCafesLoaded) {
      return Column(
        children: [
          RecomendationWidget(
            recommendations: state.recommendations,
          ),
          NearbyCoffeeShop( 
            coffeeShops: state.nearbyCafes.map((cafe) => cafe.toJson()).toList(),
          ),  
          RatingCafeWidget(cafes: state.topRatedCafes),
        ],
      );
    }
    return Column (
      children: [
          RecomendationWidget(
            recommendations:  [],
          ),
          NearbyCoffeeShop( 
            coffeeShops: [],
          ),  
          RatingCafeWidget(cafes: []),
        ],
    );
  }

  Widget _buildHeaderSection() {
    final userName = _currentUser?.name ?? 'Guest';
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
              child:
                  _currentUser?.profilePicture != null
                      ? ShowImage.get(_currentUser!.profilePicture!)
                      : ShowImage.asset('assets/images/user_profile.png'),
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
                  userName,
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
          // SizedBox(
          //   height: 40,
          //   child: ListView.builder(
          //     scrollDirection: Axis.horizontal,
          //     itemCount: _categories.length,
          //     itemBuilder: (context, index) {
          //       final isSelected = index == _selectedCategoryIndex;
          //       return Padding(
          //         padding: EdgeInsets.only(right: 12),
          //         child: GestureDetector(
          //           onTap: () {
          //             setState(() {
          //               _selectedCategoryIndex = index;
          //             });
          //           },
          //           child: Container(
          //             padding: const EdgeInsets.symmetric(
          //               horizontal: 20,
          //               vertical: 8,
          //             ),
          //             decoration: BoxDecoration(
          //               color: isSelected ? Colors.white : Colors.transparent,
          //               borderRadius: BorderRadius.circular(20),
          //               border: Border.all(
          //                 color:
          //                     isSelected ? Colors.white : Colors.grey.shade700,
          //                 width: 1,
          //               ),
          //             ),
          //             child: Text(
          //               _categories[index],
          //               style: TextStyle(
          //                 color: isSelected ? Colors.black : Colors.white,
          //                 fontWeight:
          //                     isSelected ? FontWeight.bold : FontWeight.normal,
          //               ),
          //             ),
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
