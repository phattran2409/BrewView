import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:briewview/app/di/locator.dart';
import 'package:briewview/core/widgets/navigation_bar.dart';
import 'package:briewview/features/cafe/viewmodel/cafe_bloc.dart';
import 'package:briewview/features/cafe/viewmodel/cafe_event.dart';
import 'package:briewview/features/cafe/viewmodel/cafe_sate.dart';
import 'package:briewview/features/cafe/view/cafes_detail.dart';
import 'package:briewview/features/cafe/model/cafeMode.dart';
import 'package:briewview/core/network/user_storage_services.dart';

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
  late UserStorageServices _userStorageServices;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _cafeBloc = getIt<CafeBloc>();
    _userStorageServices = getIt<UserStorageServices>();
    _loadCurrentUser();
    _cafeBloc.add(LoadCafeById(widget.cafeId));
  }

  @override
  void dispose() {
    _cafeBloc.close();
    super.dispose();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final user = await _userStorageServices.getCurrentUser();
      setState(() {
        _currentUserId = user?.id;
      });
    } catch (e) {
      print('Error loading current user: $e');
    }
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
                  content: Text('Xóa quán cà phê thành công'),
                  backgroundColor: Colors.green,
                ),
              );
              context.pop(true);
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
                return _buildCafeDetailWithActions(state.cafe);
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

  Widget _buildCafeDetailWithActions(CafeModel cafe) {
    // Check if current user is the owner
    final isOwner = _currentUserId != null && cafe.ownerId == _currentUserId;
    
    return Stack(
      children: [
        // Reuse the existing CafeDetail widget
        CafeDetail(cafeId: widget.cafeId),
        
        // Add action buttons overlay for owners
        if (isOwner)
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF8B4513),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => context.pushNamed('my-cafe-edit', pathParameters: {'id': cafe.cafeId ?? ''}),
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
            'Đã xảy ra lỗi',
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

  void _showDeleteDialog(CafeModel cafe) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa quán cà phê "${cafe.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _cafeBloc.add(DeleteCafe(cafe.cafeId ?? ''));
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
