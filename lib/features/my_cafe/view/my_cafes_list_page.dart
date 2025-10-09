import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:briewview/app/di/locator.dart';
import 'package:briewview/core/widgets/navigation_bar.dart';
import 'package:briewview/features/cafe/viewmodel/cafe_bloc.dart';
import 'package:briewview/features/cafe/viewmodel/cafe_event.dart';
import 'package:briewview/features/cafe/viewmodel/cafe_sate.dart';
import 'package:briewview/features/my_cafe/view/widgets/cafe_card_widget.dart';
import 'package:briewview/features/cafe/model/cafeMode.dart';

class MyCafesListPage extends StatefulWidget {
  const MyCafesListPage({super.key});

  @override
  State<MyCafesListPage> createState() => _MyCafesListPageState();
}

class _MyCafesListPageState extends State<MyCafesListPage> {
  late CafeBloc _cafeBloc;

  @override
  void initState() {
    super.initState();
    _cafeBloc = getIt<CafeBloc>();
    _cafeBloc.add(LoadMyCafes());
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B4513),
        elevation: 0,
        title: const Text(
          'My Cafes',
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
        
      ),
      body: BlocProvider(
        create: (context) => _cafeBloc,
        child: BlocListener<CafeBloc, CafeState>(
          listener: (context, state) {
            if (state is CafeOperationError) {
              print(state.message);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is CafeCreated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Create cafe success!'),
                  backgroundColor: Colors.green,
                ),
              );
              _cafeBloc.add(LoadMyCafes());
            } else if (state is CafeUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Update cafe success!'),
                  backgroundColor: Colors.green,
                ),
              );
              _cafeBloc.add(LoadMyCafes());
            } else if (state is CafeDeleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Delete cafe success!'),
                  backgroundColor: Colors.green,
                ),
              );
              _cafeBloc.add(LoadMyCafes());
            }
          },
          child: Builder(
            builder: (context) {
              return BlocBuilder<CafeBloc, CafeState>(
                builder: (context, state) {
                  if (state is MyCafesLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFF5F1EB),
                      ),
                    );
                  } else if (state is MyCafesLoaded) {
                    if (state.cafes.isEmpty) {
                      return _buildEmptyState();
                    }
                    return _buildCafesList(state.cafes);
                  } else if (state is MyCafesEmpty) {
                    return _buildEmptyState();
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
              );
            },
          ),
        ),
      ),
     floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await context.pushNamed('my-cafe-create');

          // Nếu có thay đổi, refresh data
          if (result == true) {
            _cafeBloc.add(LoadMyCafes());
          }
        },
        backgroundColor: const Color(0xFFF5F1EB),
        foregroundColor: const Color(0xFF8B4513),
        child: const Icon(Icons.add),
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
            'You have no cafes yet',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first cafe',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.goNamed('my-cafe-create'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF5F1EB),
              foregroundColor: const Color(0xFF8B4513),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Create new cafe'),
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
            'An error occurred',
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
            onPressed: () => _cafeBloc.add(LoadMyCafes()),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF5F1EB),
              foregroundColor: const Color(0xFF8B4513),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildCafesList(List<CafeModel> cafes) {
    return RefreshIndicator(
      onRefresh: () async {
        _cafeBloc.add(LoadMyCafes());
        await Future.delayed(const Duration(milliseconds: 500));
      },
      color: const Color(0xFF8B4513),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: cafes.length,
        itemBuilder: (context, index) {
          final cafe = cafes[index];
          return CafeCardWidget(
            cafe: cafe,
            onTap: () async {
              final result = await context.pushNamed(
                'my-cafe-detail',
                pathParameters: {'id': cafe.cafeId!},
              );
              
              // Nếu có thay đổi, refresh data
              if (result == true) {
                _cafeBloc.add(LoadMyCafes());
              }
            },
          );
        },
      ),
    );
  }
}
