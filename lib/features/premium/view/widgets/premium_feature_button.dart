import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:briewview/core/utils/premium_helper.dart';
import 'package:briewview/features/premium/viewmodel/premium_bloc.dart';
import 'package:briewview/features/premium/viewmodel/premium_event.dart';
import 'package:briewview/features/premium/viewmodel/premium_state.dart';
import 'package:briewview/features/premium/view/widgets/premium_popup_widget.dart';

class PremiumFeatureButton extends StatelessWidget {
  final String feature;
  final String? message;
  final Widget child;
  final VoidCallback? onPremiumAccess;
  final bool showBadge;

  const PremiumFeatureButton({
    super.key,
    required this.feature,
    this.message,
    required this.child,
    this.onPremiumAccess,
    this.showBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<PremiumBloc, PremiumState>(
      listener: (context, state) {
        if (state is PremiumLoaded && state.showPopup) {
          showDialog(
            context: context,
            builder:
                (context) => PremiumPopupWidget(
                  feature: state.popupFeature!,
                  message: state.popupMessage,
                ),
          );
          // Hide popup after showing
          context.read<PremiumBloc>().add(HidePremiumPopup());
        }
      },
      child: PremiumHelper.withPremiumCheck(
        feature: feature,
        message: message,
        onPremiumAccess: onPremiumAccess,
        child:
            showBadge
                ? Stack(
                  children: [
                    child,
                    Positioned(
                      top: 8,
                      right: 8,
                      child: PremiumHelper.premiumBadge(),
                    ),
                  ],
                )
                : child,
      ),
    );
  }
}

// Example usage widgets
class PremiumSearchButton extends StatelessWidget {
  final VoidCallback? onSearch;

  const PremiumSearchButton({super.key, this.onSearch});

  @override
  Widget build(BuildContext context) {
    return PremiumFeatureButton(
      feature: 'search',
      message: 'Bạn đã đạt giới hạn tìm kiếm miễn phí',
      onPremiumAccess: onSearch,
      child: ElevatedButton.icon(
        onPressed: null, // Will be handled by PremiumFeatureButton
        icon: const Icon(Icons.search),
        label: const Text('Tìm kiếm nâng cao'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}

class PremiumReviewsButton extends StatelessWidget {
  final VoidCallback? onViewReviews;

  const PremiumReviewsButton({super.key, this.onViewReviews});

  @override
  Widget build(BuildContext context) {
    return PremiumFeatureButton(
      feature: 'reviews',
      message: 'Xem đánh giá chi tiết là tính năng Premium',
      onPremiumAccess: onViewReviews,
      child: OutlinedButton.icon(
        onPressed: null, // Will be handled by PremiumFeatureButton
        icon: const Icon(Icons.star),
        label: const Text('Xem đánh giá chi tiết'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.brown,
          side: const BorderSide(color: Colors.brown),
        ),
      ),
    );
  }
}

class PremiumFavoritesButton extends StatelessWidget {
  final VoidCallback? onAddToFavorites;

  const PremiumFavoritesButton({super.key, this.onAddToFavorites});

  @override
  Widget build(BuildContext context) {
    return PremiumFeatureButton(
      feature: 'favorites',
      message: 'Lưu yêu thích là tính năng Premium',
      onPremiumAccess: onAddToFavorites,
      child: IconButton(
        onPressed: null, // Will be handled by PremiumFeatureButton
        icon: const Icon(Icons.favorite_border),
        color: Colors.red,
      ),
    );
  }
}






