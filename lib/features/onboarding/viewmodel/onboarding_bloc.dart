import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:briewview/features/onboarding/model/onboarding_item.dart';
import 'package:briewview/features/onboarding/viewmodel/onboarding_event.dart';
import 'package:briewview/features/onboarding/viewmodel/onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  static const int totalPages = 3;
  
  final List<OnboardingItem> onboardingItems = [
    const OnboardingItem(
      title: 'Welcome to BrewView',
      description: 'Discover amazing coffee experiences and connect with coffee lovers around the world.',
      imagePath: 'assets/images/onboarding_1.png',
    ),
    const OnboardingItem(
      title: 'Explore Coffee',
      description: 'Find the perfect coffee shops, read reviews, and discover new flavors.',
      imagePath: 'assets/images/onboarding_2.png',
    ),
    const OnboardingItem(
      title: 'Start Your Journey',
      description: 'Join our community and start your coffee adventure today!',
      imagePath: 'assets/images/onboarding_3.png',
    ),
  ];

  OnboardingBloc() : super(OnboardingInitial()) {
    on<OnboardingPageChanged>(_onPageChanged);
    on<OnboardingNextPressed>(_onNextPressed);
    on<OnboardingPreviousPressed>(_onPreviousPressed);
    on<OnboardingSkipPressed>(_onSkipPressed);
    on<OnboardingGetStartedPressed>(_onGetStartedPressed);
  }

  void _onPageChanged(OnboardingPageChanged event, Emitter<OnboardingState> emit) {
    emit(OnboardingPageState(
      currentPage: event.pageIndex,
      totalPages: totalPages,
      isLastPage: event.pageIndex == totalPages - 1,
      isFirstPage: event.pageIndex == 0,
    ));
  }

  void _onNextPressed(OnboardingNextPressed event, Emitter<OnboardingState> emit) {
    final currentState = state;
    if (currentState is OnboardingPageState && !currentState.isLastPage) {
      add(OnboardingPageChanged(currentState.currentPage + 1));
    }
  }

  void _onPreviousPressed(OnboardingPreviousPressed event, Emitter<OnboardingState> emit) {
    final currentState = state;
    if (currentState is OnboardingPageState && !currentState.isFirstPage) {
      add(OnboardingPageChanged(currentState.currentPage - 1));
    }
  }

  void _onSkipPressed(OnboardingSkipPressed event, Emitter<OnboardingState> emit) {
    emit(OnboardingCompleted());
  }

  void _onGetStartedPressed(OnboardingGetStartedPressed event, Emitter<OnboardingState> emit) {
    emit(OnboardingCompleted());
  }
}
