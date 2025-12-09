import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:briewview/features/onboarding/model/onboarding_item.dart';
import 'package:briewview/features/onboarding/viewmodel/onboarding_event.dart';
import 'package:briewview/features/onboarding/viewmodel/onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  static const int totalPages = 3;
  
  final List<OnboardingItem> onboardingItems = [
    const OnboardingItem(
      title: 'Chào mừng đến với BrewView',
      description: 'Khám phá những trải nghiệm cà phê tuyệt vời và kết nối với những người yêu thích cà phê trên khắp thế giới.',
      imagePath: 'assets/images/onboarding_1.png',
    ),
    const OnboardingItem(
      title: 'Khám Phá Các Quán Cà Phê',
      description: 'Tìm kiếm quán cà phê hoàn hảo, đọc đánh giá và khám phá hương vị mới.',
      imagePath: 'assets/images/onboarding_2.png',
    ),
    const OnboardingItem(
      title: 'Bắt Đầu Hành Trình Của Bạn',
      description: 'Tham gia cộng đồng của chúng tôi và bắt đầu cuộc phiêu lưu cà phê của bạn ngay hôm nay!',
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
