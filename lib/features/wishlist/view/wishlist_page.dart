import 'package:briewview/app/di/locator.dart';
import 'package:briewview/features/cafe/model/cafeMode.dart';
import 'package:briewview/features/cafe/view/cafes_detail.dart';
import 'package:briewview/features/wishlist/viewmodel/wishlist_bloc.dart';
import 'package:briewview/features/wishlist/viewmodel/wishlist_event.dart';
import 'package:briewview/features/wishlist/viewmodel/wishlist_state.dart';
import 'package:briewview/features/wishlist/view/widgets/wishlist_item_widget.dart';
import 'package:briewview/features/wishlist/view/widgets/wishlist_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  late WishlistBloc _wishlistBloc;

  @override
  void initState() {
    super.initState();
    _wishlistBloc = getIt<WishlistBloc>();
    _wishlistBloc.add(const LoadWishlist());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: const Color(0xFF8B4513),
    appBar: AppBar(
        backgroundColor: const Color(0xFF8B4513),
        elevation: 0,
        title: const Text(
          'Danh sách yêu thích',
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
      body: BlocProvider.value(
        value: _wishlistBloc,
        child: BlocConsumer<WishlistBloc, WishlistState>(
          listener: (context, state) {
            if (state is WishlistError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is WishlistOperationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is WishlistLoading) {
              return const WishlistLoadingWidget();
            } else if (state is WishlistLoaded) {
              if (state.wishlist.favoriteCafes.isEmpty) {
                return WishlistEmptyWidget(
                  onExplorePressed: () => context.goNamed('home'),
                );
              }
              return _buildWishlistContent(state.wishlist.favoriteCafes);
            } else if (state is WishlistError) {
              return WishlistErrorWidget(
                message: state.message,
                onRetry: () => _wishlistBloc.add(const LoadWishlist()),
              );
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
    );
  }


  Widget _buildWishlistContent(List<CafeModel> cafes) {
    return RefreshIndicator(
      onRefresh: () async {
        _wishlistBloc.add(const RefreshWishlist());
      },
      color: const Color.fromARGB(255, 52, 46, 41),
      backgroundColor: const Color.fromARGB(255, 221, 169, 74),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: cafes.length,
        itemBuilder: (context, index) {
          final cafe = cafes[index];
          return WishlistItemWidget(
            cafe: cafe,
            onTap: () => _navigateToCafeDetail(cafe.cafeId ?? ''),
            onRemove: () => _removeFromWishlist(cafe.cafeId ?? ''),
          );
        },
      ),
    );
  }


  void _navigateToCafeDetail(String cafeId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CafeDetail(cafeId: cafeId),
      ),
    );
  }

  void _removeFromWishlist(String cafeId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2C),
        title: const Text(
          'Xóa khỏi danh sách yêu thích',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Bạn có chắc chắn muốn xóa quán cà phê này khỏi danh sách yêu thích?',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Hủy',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _wishlistBloc.add(RemoveFromWishlist(cafeId));
            },
            child: const Text(
              'Xóa',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
