import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:briewview/app/di/locator.dart';
import 'package:briewview/core/widgets/navigation_bar.dart';
import 'package:briewview/features/cafe/viewmodel/cafe_bloc.dart';
import 'package:briewview/features/cafe/viewmodel/cafe_event.dart';
import 'package:briewview/features/cafe/viewmodel/cafe_sate.dart';

class MyCafeDetailPage extends StatefulWidget {
  final String cafeId;

  const MyCafeDetailPage({
    super.key,
    required this.cafeId,
  });

  @override
  State<MyCafeDetailPage> createState() => _MyCafeDetailPageState();
}

class _MyCafeDetailPageState extends State<MyCafeDetailPage> {
  late CafeBloc _cafeBloc;

  @override
  void initState() {
    super.initState();
    _cafeBloc = getIt<CafeBloc>();
    _cafeBloc.add(LoadCafeById(widget.cafeId));
  }

  @override
  void dispose() {
    _cafeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8B4513),
      body: BlocProvider(
        create: (context) => _cafeBloc,
        child: BlocListener<CafeBloc, CafeState>(
          listener: (context, state) {
            if (state is CafeOperationError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is CafeDeleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Xóa cafe thành công!'),
                  backgroundColor: Colors.green,
                ),
              );
              context.pop();
            }
          },
          child: BlocBuilder<CafeBloc, CafeState>(
            builder: (context, state) {
              if (state is CafeLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFF5F1EB),
                  ),
                );
              } else if (state is CafeDetailsLoaded) {
                return _buildCafeDetail(state.cafe);
              } else if (state is CafeOperationError) {
                return _buildErrorState(state.message);
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFF5F1EB),
                  ),
                );
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }

  Widget _buildCafeDetail(cafe) {
    return CustomScrollView(
      slivers: [
        // App bar with image
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            onPressed: () => context.pop(),
          ),
          actions: [
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit, color: Colors.white),
              ),
              onPressed: () => context.pushNamed(
                'my-cafe-edit',
                pathParameters: {'id': cafe.id},
              ),
            ),
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.delete, color: Colors.red),
              ),
              onPressed: () => _showDeleteDialog(cafe),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                // Background image
                cafe.imageUrl != null && cafe.imageUrl!.isNotEmpty
                    ? Image.network(
                        cafe.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[800],
                            child: const Icon(
                              Icons.local_cafe,
                              color: Colors.white,
                              size: 100,
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey[800],
                        child: const Icon(
                          Icons.local_cafe,
                          color: Colors.white,
                          size: 100,
                        ),
                      ),
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.9),
                      ],
                      stops: const [0.0, 0.6, 1.0],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Content
        SliverToBoxAdapter(
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF8B4513),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cafe name
                  Text(
                    cafe.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Address
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          cafe.address,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Opening hours
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.amber, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '${cafe.openingTime} - ${cafe.closingTime}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Price range
                  Row(
                    children: [
                      const Icon(Icons.attach_money, color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '${cafe.priceMin.toInt()}K - ${cafe.priceMax.toInt()}K',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  if (cafe.hotline != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.phone, color: Colors.blue, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          cafe.hotline!,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (cafe.linkPage != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.link, color: Colors.purple, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            cafe.linkPage!,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 20),
                  // Description
                  const Text(
                    'Mô tả',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    cafe.description,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Rating
                  if (cafe.rating != null) ...[
                    const Text(
                      'Đánh giá',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          if (index < (cafe.rating! ~/ 1)) {
                            return const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 24,
                            );
                          } else {
                            return const Icon(
                              Icons.star_border,
                              color: Colors.amber,
                              size: 24,
                            );
                          }
                        }),
                        const SizedBox(width: 8),
                        Text(
                          '${cafe.rating!.toStringAsFixed(1)} (${cafe.reviewCount ?? 0} đánh giá)',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => context.pushNamed(
                            'my-cafe-edit',
                            pathParameters: {'id': cafe.id},
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF5F1EB),
                            foregroundColor: const Color(0xFF8B4513),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Chỉnh sửa',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _showDeleteDialog(cafe),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Xóa',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100), // Space for bottom nav
                ],
              ),
            ),
          ),
        ),
      ],
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
            onPressed: () => _cafeBloc.add(LoadCafeById(widget.cafeId)),
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

  void _showDeleteDialog(cafe) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa cafe "${cafe.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _cafeBloc.add(DeleteCafe(cafe.id));
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }
}
