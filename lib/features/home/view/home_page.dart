import 'package:briewview/app/di/locator.dart';
import 'package:briewview/app/theme/app_color.dart';
import 'package:briewview/core/network/user_storage_services.dart';
import 'package:briewview/core/services/location_service.dart';
import 'package:briewview/core/utils/ShowImage.dart';
import 'package:briewview/core/utils/premium_helper.dart';
import 'package:briewview/core/widgets/navigation_bar.dart';
import 'package:briewview/features/cafe/viewmodel/cafe_bloc.dart';
import 'package:briewview/features/cafe/viewmodel/cafe_event.dart';
import 'package:briewview/features/cafe/viewmodel/cafe_sate.dart';
import 'package:briewview/features/home/view/widgets/NearbyCoffeShop_widget.dart';
import 'package:briewview/features/home/view/widgets/Recomendation_widget.dart';
import 'package:briewview/features/home/view/widgets/rating_cafe_widget.dart';
import 'package:briewview/features/premium/view/widgets/premium_popup_widget.dart';
import 'package:briewview/features/premium/viewmodel/premium_bloc.dart';
import 'package:briewview/features/premium/viewmodel/premium_event.dart';
import 'package:briewview/features/premium/viewmodel/premium_state.dart';
import 'package:briewview/features/user_management/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  late CafeBloc _cafeBloc;
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;
  // late ProfileBloc _profileBloc;
  UserModel? _currentUser;
  late LocationService _locationService;
  late PremiumBloc _premiumBloc;
  bool _locationInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
    _cafeBloc = getIt<CafeBloc>();
    _premiumBloc = GetIt.instance<PremiumBloc>();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowPopup();
    });
    _locationService = getIt<LocationService>();

    _loadCurrentUserAndCafes();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Khi app resume, check popup
    if (state == AppLifecycleState.resumed) {
      Future.delayed(const Duration(seconds: 2), () {
        _checkAndShowPopup();
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          print('Ad failed to load: $error');
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
  }

  void _checkAndShowPopup() {
    _premiumBloc.showHomePopupIfAllowed(
      message: 'Hãy khám phá các tính năng cao cấp!  ',
    );
  }

  Future<void> _loadCurrentUserAndCafes() async {
    try {
      _currentUser = await getIt<UserStorageServices>().getCurrentUser();

      // Delay location initialization slightly to avoid system startup conflicts
      Future.delayed(const Duration(milliseconds: 500), () async {
        try {
          _locationInitialized = await _locationService.initialize();
          print('🗺️ LocationService initialized: $_locationInitialized');
          print('⭐ Current User Premium Status: ${_currentUser?.isPremium}');
          // Load nearby cafes only after location is successfully initialized
          if (mounted && _locationInitialized) {
            _cafeBloc.add(
              LoadCafesByDistance(
                pageNumber: 1,
                pageSize: 10,
                maxDistanceKm: 10,
              ),
            ); // Nearby
          }
        } catch (e) {
          print('❌ LocationService initialization failed: $e');

          _locationInitialized = false;
          // Nếu có lỗi DeadSystemException, thử lại sau
          if (e.toString().contains('DeadSystemException') ||
              e.toString().contains('DEAD_OBJECT')) {
            print('⏳ Will retry location initialization in 10 seconds...');
            Future.delayed(const Duration(seconds: 10), () async {
              if (mounted) {
                try {
                  _locationInitialized = await _locationService.initialize();
                  if (_locationInitialized && mounted) {
                    _cafeBloc.add(
                      LoadCafesByDistance(
                        pageNumber: 1,
                        pageSize: 10,
                        maxDistanceKm: 10,
                      ),
                    );
                  }
                } catch (retryError) {
                  print('❌ Location retry failed: $retryError');
                }
              }
            });
          }
        }
      });

      if (mounted) {
        setState(() {});
        final userId = _currentUser?.id ?? '';
        _cafeBloc.add(
          LoadRecommendedCafes(pageNumber: 1, pageSize: 5, userId: userId),
        ); // Recommendations

        _cafeBloc.add(
          LoadCafesRating(
            pageNumber: 1,
            pageSize: 5,
            sortBy: 'rating',
            sortDirection: 'Descending',
          ),
        ); // Top Rated
      }
    } catch (e) {
      // Handle error if needed
      print('Error loading user: $e');
      _cafeBloc.add(
        LoadCafes(pageNumber: 1, pageSize: 5),
      ); // Load cafes without user context

      _cafeBloc.add(
        LoadCafesRating(
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
    return BlocProvider.value(
      value: _premiumBloc,
      child: Scaffold(
        backgroundColor: const Color(0xFF0D0D0D),
        body: Stack(
          children: [
            // Main home content
            _buildHomeContent(),
            if (_isAdLoaded && _currentUser?.isPremium == false)
              Positioned(
                bottom: 60, // Adjust based on your navigation bar height
                left: 0,
                right: 0,
                child: Container(
                  alignment: Alignment.center,
                  width: _bannerAd.size.width.toDouble(),
                  height: _bannerAd.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd),
                ),
              ),

            // Premium popup overlay
            BlocBuilder<PremiumBloc, PremiumState>(
              builder: (context, state) {
                if (state is PremiumLoaded && state.showPopup) {
                  return PremiumPopupWidget(
                    feature: state.popupFeature!,
                    message: state.popupMessage!,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
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

    if (state is CombinedCafesLoaded) {
      return Column(
        children: [
          RecomendationWidget(recommendations: state.recommendations),
          NearbyCoffeeShop(
            coffeeShops:
                state.nearbyCafes.map((cafe) => cafe.toJson()).toList(),
          ),
          RatingCafeWidget(cafes: state.topRatedCafes),
        ],
      );
    }
    return Column(
      children: [
        RecomendationWidget(recommendations: []),
        NearbyCoffeeShop(coffeeShops: []),
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
                      : ShowImage.asset('assets/images/user.png'),
            ),
          ),

          const SizedBox(width: 15),

          // User Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chào mừng trở lại,',
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
                Container(
                  child: BlocBuilder<PremiumBloc, PremiumState>(
                    builder: (context, state) {
                      final hasPremium = _currentUser?.isPremium ?? false;
                      return GestureDetector(
                        onTap: () {
                          _premiumBloc.add(
                            const ShowHomePagePopup(
                              message:
                                  'Khám phá các tính năng cao cấp như không quảng cáo, đánh giá chi tiết và nhiều hơn nữa!',
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: hasPremium ? Colors.amber : Colors.grey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child:
                              hasPremium
                                  ? PremiumHelper.premiumBadge(text: 'Premium')
                                  : const Text(
                                    'Free',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Wishlist Button
          IconButton(
            onPressed: () {
              context.goNamed('wishlist');
            },
            icon: const Icon(
              Icons.favorite_outline,
              color: Colors.white,
              size: 28,
            ),
            tooltip: 'Danh sách yêu thích',
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
                      hintText: 'Bạn muốn tìm quán nào?',
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

          const SizedBox(height: 12),

          // Map button
          GestureDetector(
            onTap: () {
              context.push('/map');
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B4513), Color(0xFFA0522D)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.map, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  const Text(
                    'Xem bản đồ quán cafe gần đây',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white.withOpacity(0.8),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
