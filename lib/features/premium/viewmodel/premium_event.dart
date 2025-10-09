import 'package:equatable/equatable.dart';

abstract class PremiumEvent extends Equatable {
  const PremiumEvent();

  @override
  List<Object?> get props => [];
}

class LoadPremiumPlans extends PremiumEvent {}

class CheckPremiumStatus extends PremiumEvent {}

class SelectPlan extends PremiumEvent {
  final String planId;

  const SelectPlan(this.planId);

  @override
  List<Object?> get props => [planId];
}

class CreateSubscription extends PremiumEvent {
  final String userId;

  const CreateSubscription({
    required this.userId,
  });

  @override
  List<Object?> get props => [userId];
}

class CancelSubscription extends PremiumEvent {
  final String subscriptionId;

  const CancelSubscription(this.subscriptionId);

  @override
  List<Object?> get props => [subscriptionId];
}

class LoadSubscriptionHistory extends PremiumEvent {}

class ShowPremiumPopup extends PremiumEvent {
  final String feature;
  final String? message;

  const ShowPremiumPopup({required this.feature, this.message});

  @override
  List<Object?> get props => [feature, message];
}

class HidePremiumPopup extends PremiumEvent {}

class NavigateToPayment extends PremiumEvent {
  final String planId;

  const NavigateToPayment(this.planId);

  @override
  List<Object?> get props => [planId];
}

class ShowHomePagePopup extends PremiumEvent {
  final String? message;

  const ShowHomePagePopup({this.message});

  @override
  List<Object?> get props => [message];
}  
