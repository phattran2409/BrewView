import 'package:briewview/features/premium/viewmodel/premium_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:briewview/features/premium/viewmodel/premium_bloc.dart';
import 'package:briewview/features/premium/viewmodel/premium_event.dart';
import 'package:briewview/features/premium/view/widgets/premium_popup_widget.dart';

class PremiumHelper {
  // Check if user has premium access and show popup if not
  static bool checkPremiumAccess(
    BuildContext context, {
    required String feature,
    String? message,
    VoidCallback? onPremiumAccess,
  }) {
    final premiumBloc = context.read<PremiumBloc>();

    if (premiumBloc.hasPremiumAccess) {
      // User has premium access, execute the action
      onPremiumAccess?.call();
      return true;
    } else {
      // User doesn't have premium access, show popup
      premiumBloc.add(ShowPremiumPopup(feature: feature, message: message));
      return false;
    }
  }

  // Show premium popup directly
  static void showPremiumPopup(
    BuildContext context, {
    required String feature,
    String? message,
  }) {
    final premiumBloc = context.read<PremiumBloc>();
    premiumBloc.add(ShowPremiumPopup(feature: feature, message: message));
  }

  // Wrap a widget with premium check
  static Widget withPremiumCheck({
    required Widget child,
    required String feature,
    String? message,
    VoidCallback? onPremiumAccess,
  }) {
    return Builder(
      builder: (context) {
        return BlocListener<PremiumBloc, dynamic>(
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
          child: GestureDetector(
            onTap: () {
              checkPremiumAccess(
                context,
                feature: feature,
                message: message,
                onPremiumAccess: onPremiumAccess,
              );
            },
            child: child,
          ),
        );
      },
    );
  }

  // Create a premium badge widget
  static Widget premiumBadge({String? text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Colors.white, size: 12),
          const SizedBox(width: 4),
          Text(
            text ?? 'Premium',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Create a premium feature widget that shows popup when tapped
  static Widget premiumFeature({
    required Widget child,
    required String feature,
    String? message,
    bool showBadge = true,
  }) {
    return Stack(
      children: [
        child,
        if (showBadge) Positioned(top: 8, right: 8, child: premiumBadge()),
      ],
    );
  }
}






