import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:briewview/app/di/locator.dart';
import 'package:briewview/core/widgets/navigation_bar.dart';
import 'package:briewview/features/my_cafe/viewmodel/my_cafe_bloc.dart';
import 'package:briewview/features/my_cafe/viewmodel/my_cafe_event.dart';
import 'package:briewview/features/my_cafe/viewmodel/my_cafe_state.dart';
import 'package:briewview/features/my_cafe/view/widgets/cafe_card_widget.dart';
import 'package:briewview/features/my_cafe/model/cafe_model.dart';

class MyCafesListPage extends StatefulWidget {
  const MyCafesListPage({super.key});

  @override
  State<MyCafesListPage> createState() => _MyCafesListPageState();
}

class _MyCafesListPageState extends State<MyCafesListPage> {
  late MyCafeBloc _myCafeBloc;

  @override
  void initState() {
    super.initState();
    _myCafeBloc = getIt<MyCafeBloc>();
    // Temporarily comment out real API call
    // _myCafeBloc.add(LoadMyCafes());
  }

  // Mock data for testing
  List<CafeModel> _getMockCafes() {
    return [
      CafeModel(
        id: '1',
        categoryId: 1,
        name: 'Cafe Trung Nguyên',
        address: '123 Nguyễn Huệ, Quận 1, TP.HCM',
        description: 'Cafe truyền thống với không gian ấm cúng, phục vụ các loại cà phê đặc sản Việt Nam.',
        priceMin: 25000,
        priceMax: 65000,
        openingTime: '06:00',
        closingTime: '22:00',
        hotline: '0123456789',
        linkPage: 'https://trungnguyenlegend.com',
        rating: 4.5,
        reviewCount: 128,
        mediaUrls: [
          'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=500',
          'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=500',
        ],
        selectedFeatureTagIds: [1, 2, 3],
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
      ),
      CafeModel(
        id: '2',
        categoryId: 2,
        name: 'Starbucks Coffee',
        address: '456 Lê Lợi, Quận 3, TP.HCM',
        description: 'Thương hiệu cà phê quốc tế với menu đa dạng và không gian hiện đại.',
        priceMin: 45000,
        priceMax: 120000,
        openingTime: '07:00',
        closingTime: '23:00',
        hotline: '0987654321',
        rating: 4.2,
        reviewCount: 89,
        mediaUrls: [
          'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=500',
          'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=500',
        ],
        selectedFeatureTagIds: [2, 4, 5],
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now(),
      ),
      CafeModel(
        id: '3',
        categoryId: 1,
        name: 'Cafe Cộng',
        address: '789 Điện Biên Phủ, Quận Bình Thạnh, TP.HCM',
        description: 'Cafe vintage với thiết kế độc đáo, không gian rộng rãi phù hợp cho làm việc và học tập.',
        priceMin: 30000,
        priceMax: 80000,
        openingTime: '06:30',
        closingTime: '23:30',
        hotline: '0369258147',
        rating: 4.7,
        reviewCount: 156,
        mediaUrls: [
          'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=500',
          'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=500',
        ],
        selectedFeatureTagIds: [1, 3, 6],
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  @override
  void dispose() {
    _myCafeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8B4513),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B4513),
        elevation: 0,
        title: const Text(
          'Cafe của tôi',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => context.pushNamed('my-cafe-create'),
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => _myCafeBloc,
        child: BlocListener<MyCafeBloc, MyCafeState>(
          listener: (context, state) {
            if (state is MyCafeError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is CafeCreated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tạo cafe thành công!'),
                  backgroundColor: Colors.green,
                ),
              );
              _myCafeBloc.add(LoadMyCafes());
            } else if (state is CafeUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cập nhật cafe thành công!'),
                  backgroundColor: Colors.green,
                ),
              );
              _myCafeBloc.add(LoadMyCafes());
            } else if (state is CafeDeleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Xóa cafe thành công!'),
                  backgroundColor: Colors.green,
                ),
              );
              _myCafeBloc.add(LoadMyCafes());
            }
          },
          child: Builder(
            builder: (context) {
              // Temporarily use mock data instead of bloc state
              final mockCafes = _getMockCafes();
              
              if (mockCafes.isEmpty) {
                return _buildEmptyState();
              }
              return _buildCafesList(mockCafes);
              
              // Original bloc builder code (commented out for mock data)
              // return BlocBuilder<MyCafeBloc, MyCafeState>(
              //   builder: (context, state) {
              //     if (state is MyCafeLoading) {
              //       return const Center(
              //         child: CircularProgressIndicator(
              //           color: Color(0xFFF5F1EB),
              //         ),
              //       );
              //     } else if (state is MyCafesLoaded) {
              //       if (state.cafes.isEmpty) {
              //         return _buildEmptyState();
              //       }
              //       return _buildCafesList(state.cafes);
              //     } else if (state is MyCafeError) {
              //       return _buildErrorState(state.message);
              //     } else {
              //       return const Center(
              //         child: CircularProgressIndicator(
              //           color: Color(0xFFF5F1EB),
              //         ),
              //       );
              //     }
              //   },
              // );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed('my-cafe-create'),
        backgroundColor: const Color(0xFFF5F1EB),
        child: const Icon(
          Icons.add,
          color: Color(0xFF8B4513),
        ),
      ),
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_cafe_outlined,
            size: 80,
            color: Colors.white.withOpacity(0.7),
          ),
          const SizedBox(height: 16),
          Text(
            'Chưa có cafe nào',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hãy tạo cafe đầu tiên của bạn',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.pushNamed('my-cafe-create'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF5F1EB),
              foregroundColor: const Color(0xFF8B4513),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Tạo cafe mới'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.white.withOpacity(0.7),
          ),
          const SizedBox(height: 16),
          Text(
            'Có lỗi xảy ra',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _myCafeBloc.add(LoadMyCafes()),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF5F1EB),
              foregroundColor: const Color(0xFF8B4513),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  Widget _buildCafesList(List<CafeModel> cafes) {
    return RefreshIndicator(
      onRefresh: () async {
        // Temporarily simulate refresh with mock data
        setState(() {
          // Force rebuild with mock data
        });
        // Original refresh code (commented out for mock data)
        // _myCafeBloc.add(RefreshCafes());
      },
      color: const Color(0xFF8B4513),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: cafes.length,
        itemBuilder: (context, index) {
          final cafe = cafes[index];
          return CafeCardWidget(
            cafe: cafe,
            onTap: () => context.pushNamed('my-cafe-detail', pathParameters: {'id': cafe.id!}),
          );
        },
      ),
    );
  }
}
