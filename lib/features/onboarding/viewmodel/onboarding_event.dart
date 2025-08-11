import 'package:equatable/equatable.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object> get props => [];
}

class OnboardingPageChanged extends OnboardingEvent {
  final int pageIndex;

  const OnboardingPageChanged(this.pageIndex);

  @override
  List<Object> get props => [pageIndex];
}

class OnboardingNextPressed extends OnboardingEvent {}

class OnboardingPreviousPressed extends OnboardingEvent {}

class OnboardingSkipPressed extends OnboardingEvent {}

class OnboardingGetStartedPressed extends OnboardingEvent {}
