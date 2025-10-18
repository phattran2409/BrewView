import 'package:briewview/features/cafe/model/cafeMode.dart';
import 'package:briewview/features/wishlist/viewmodel/wishlist_bloc.dart';
import 'package:briewview/features/wishlist/viewmodel/wishlist_event.dart';
import 'package:briewview/features/wishlist/viewmodel/wishlist_state.dart';
import 'package:briewview/app/di/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CafeHeaderWidget extends   StatefulWidget {
  final CafeModel cafe;

  const CafeHeaderWidget({super.key, required this.cafe});

  @override
  State<CafeHeaderWidget> createState() => _CafeHeaderWidgetState();
}

class _CafeHeaderWidgetState extends State<CafeHeaderWidget> {
  bool _isInWishlist = false;
  late WishlistBloc _wishlistBloc;

  @override
  void initState() {
    super.initState();
    _wishlistBloc = getIt<WishlistBloc>();
    _checkWishlistStatus();
  }

  void _checkWishlistStatus() {
    _wishlistBloc.add(const LoadWishlist());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _wishlistBloc,
      child: BlocListener<WishlistBloc, WishlistState>(
        listener: (context, state) {
          if (state is WishlistLoaded) {
            setState(() {
              _isInWishlist = state.wishlist.favoriteCafes
                  .any((cafe) => cafe.cafeId == widget.cafe.cafeId);
            });
          } else if (state is WishlistOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            // Reload wishlist to update status
            _checkWishlistStatus();
          } else if (state is WishlistError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Container(
          child: Column(
            children: [
               _buildCafeHeader(widget.cafe),
                const SizedBox(height: 16), 
               _buildTimeOpenAndDistance(widget.cafe),
               const SizedBox(height: 16), 
               _buildTags(widget.cafe),
               const SizedBox(height: 16), 
               _buildRatingSection(widget.cafe),
               const SizedBox(height: 16), 
               _buildVoucherSection(),
               const SizedBox(height: 16), 
            ]
          ),
        ),
      ),
    );
  }

      Widget _buildTimeOpenAndDistance(CafeModel? cafeData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Row(
            children: [
              Icon(Icons.access_time, color: Colors.white, size: 24),
              SizedBox(width: 8),
              Text(
                cafeData?.openingTime ?? 'Cả ngày',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(' - '),
              Text(
                cafeData?.closingTime ?? 'Cả ngày',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            children: [
              Icon(Icons.location_on, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                '0.5 km',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTags(CafeModel? cafeData) {
    final tags = cafeData?.cafeFeatureTags?.map((tag) => tag.name).toList() ?? [];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, 
      child: Row(
        children: tags.map((tag) {
          return Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                tag,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
    ));
  }

  Widget _buildRatingSection(CafeModel? cafeData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Rating stars
        Row(
          children: [
            ...List.generate(
              (cafeData?.rating?.toInt() ?? 0).clamp(0, 5),
              (index) => const Icon(Icons.star, color: Colors.amber, size: 20),
            ),
            const Icon(Icons.star_border, color: Colors.amber, size: 20),
            const SizedBox(width: 8),
            Text(
              '${(cafeData?.rating ?? 0.0).clamp(0.0, 5.0).toStringAsFixed(1)} (50 đánh giá)',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Address
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.red, size: 16),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                cafeData?.address ?? 'N/A',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVoucherSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Text(
            'Voucher',
            style: TextStyle(
              color: Colors.amber,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            'Liên hệ ngay',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white.withOpacity(0.8),
            size: 14,
          ),
        ],
      ),
    );
  }

    Widget _buildCafeHeader(CafeModel? cafeData) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cafeData?.name ?? 'N/A',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // Favorite button
        GestureDetector(
          onTap: () {
            if (_isInWishlist) {
              // Already in wishlist, show message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Quán cà phê đã có trong danh sách yêu thích'),
                  backgroundColor: Colors.orange,
                ),
              );
            } else {
              // Add to wishlist
              _wishlistBloc.add(AddToWishlist(widget.cafe.cafeId ?? ''));
            }
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isInWishlist ? Icons.favorite : Icons.favorite_border,
              color: _isInWishlist ? Colors.red : Colors.white.withOpacity(0.6),
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

}