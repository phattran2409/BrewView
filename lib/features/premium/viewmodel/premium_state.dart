import 'package:equatable/equatable.dart';
import 'package:briewview/features/premium/model/premium_plan_model.dart';
import 'package:briewview/features/premium/model/subscription_model.dart';

abstract class PremiumState extends Equatable {
  const PremiumState();

  @override
  List<Object?> get props => [];
}

class PremiumInitial extends PremiumState {}

class PremiumLoading extends PremiumState {}

class PremiumLoaded extends PremiumState {
  final List<PremiumPlanModel> plans;
  final SubscriptionModel? currentSubscription;
  final bool hasPremiumAccess;
  final String? selectedPlanId;
  final bool showPopup;
  final String? popupFeature;
  final String? popupMessage;

  const PremiumLoaded({
    required this.plans,
    this.currentSubscription,
    required this.hasPremiumAccess,
    this.selectedPlanId,
    this.showPopup = false,
    this.popupFeature,
    this.popupMessage,
  });

  @override
  List<Object?> get props => [
    plans,
    currentSubscription,
    hasPremiumAccess,
    selectedPlanId,
    showPopup,
    popupFeature,
    popupMessage,
  ];

  PremiumLoaded copyWith({
    List<PremiumPlanModel>? plans,
    SubscriptionModel? currentSubscription,
    bool? hasPremiumAccess,
    String? selectedPlanId,
    bool? showPopup,
    String? popupFeature,
    String? popupMessage,
  }) {
    return PremiumLoaded(
      plans: plans ?? this.plans,
      currentSubscription: currentSubscription ?? this.currentSubscription,
      hasPremiumAccess: hasPremiumAccess ?? this.hasPremiumAccess,
      selectedPlanId: selectedPlanId ?? this.selectedPlanId,
      showPopup: showPopup ?? this.showPopup,
      popupFeature: popupFeature ?? this.popupFeature,
      popupMessage: popupMessage ?? this.popupMessage,
    );
  }
}

class PremiumError extends PremiumState {
  final String message;

  const PremiumError(this.message);

  @override
  List<Object?> get props => [message];
}

class PremiumProcessing extends PremiumState {
  final String message;

  const PremiumProcessing(this.message);

  @override
  List<Object?> get props => [message];
}

class PremiumSuccess extends PremiumState {
  final String message;
  final SubscriptionModel? subscription;

  const PremiumSuccess({required this.message, this.subscription});

  @override
  List<Object?> get props => [message, subscription];
}





