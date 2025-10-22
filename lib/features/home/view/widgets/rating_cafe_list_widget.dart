import 'dart:ffi';

import 'package:briewview/app/di/locator.dart';
import 'package:briewview/app/theme/app_color.dart';
import 'package:briewview/features/cafe/model/cafeMode.dart';
import 'package:briewview/features/cafe/viewmodel/cafe_bloc.dart';
import 'package:briewview/features/cafe/viewmodel/cafe_event.dart';
import 'package:briewview/features/cafe/viewmodel/cafe_sate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RatingCafeListWidget extends StatefulWidget {
  const RatingCafeListWidget({super.key});

  @override
  State<RatingCafeListWidget> createState() => _RatingCafeListWidgetState();
}

class _RatingCafeListWidgetState extends State<RatingCafeListWidget> {
  List<CafeModel> cafes = <CafeModel>[]; // Replace with actual data source
  late final _cafeBloc;

  @override
  void initState() {
    super.initState();
    _cafeBloc = getIt<CafeBloc>();
    _loadTopRatedCafes();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _loadTopRatedCafes() {
    _cafeBloc.add(
      LoadCafesRating(
        pageSize: 1,
        pageNumber: 10,
        sortBy: 'rating',
        sortDirection: 'desc',
      ),
    );
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
              _buildHeader(context),
              Expanded(
                child: BlocConsumer<CafeBloc, CafeState>(
                  bloc: _cafeBloc,
                  listener: (context, state) {
                    if (state is CafeError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Lỗi: ${state.message}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is CafeLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is CombinedCafesLoaded) {
                      cafes = state.topRatedCafes;
                      if (cafes.isEmpty) {
                        return _cafeEmpty();
                      }
                      return _buildCafeList(cafes, context);
                    } else {
                      return const Center(
                        child: Text(
                          'Không có dữ liệu',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
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
              Navigator.pop(context);
            },
            child: const Text(
              'Đóng',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cafeEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.local_cafe_outlined,
            size: 80,
            color: Colors.white70,
          ),
          SizedBox(height: 16),
          Text(
            'Không có quán nào được đánh giá cao',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }
  Widget _buildCafeList(List<CafeModel> cafes , BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),  
      itemCount: cafes.length,
      itemBuilder: (context, index) {
        final cafe = cafes[index];
        return  Container(
           margin: const EdgeInsets.only(bottom: 12.0),
           decoration:  BoxDecoration(
             color: Colors.white.withOpacity(0.1),
             borderRadius: BorderRadius.circular(10.0),
             border: Border.all(color: Colors.white24 , width: 1),
            boxShadow: [
               BoxShadow(
                 color: Colors.black.withOpacity(0.2),
                 blurRadius: 4,
                 offset: const Offset(0, 2),
               ),
             ],
           ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                // ✅ Navigate to cafe detail
                context.goNamed('cafe-detail', pathParameters: {'id': cafe.cafeId ?? ''});  
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Cafe image
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white.withOpacity(0.2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: cafe.imageUrl != null
                            ? Image.network(
                                cafe.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.local_cafe,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  );
                                },
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.local_cafe,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Cafe info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Cafe name
                          Text(
                            cafe.name ?? 'Unknown Cafe',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          
                          const SizedBox(height: 4),
                          
                          // Address
                          if (cafe.address != null)
                            Text(
                              cafe.address!,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          
                          const SizedBox(height: 8),
                          
                          // Rating and ranking
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8, 
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.star, 
                                      color: Colors.white, 
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${cafe.rating?.toStringAsFixed(1) ?? 'N/A'}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              const SizedBox(width: 8),
                              
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8, 
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '#${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Arrow icon
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white.withOpacity(0.6),
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        },
      );
    }
}
