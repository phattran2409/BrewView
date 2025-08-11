import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object> get props => [];
}

class OnboardingInitial extends OnboardingState {}

class OnboardingPageState extends OnboardingState {
  final int currentPage;
  final int totalPages;
  final bool isLastPage;
  final bool isFirstPage;

  const OnboardingPageState({
    required this.currentPage,
    required this.totalPages,
    required this.isLastPage,
    required this.isFirstPage,
  });

  @override
  List<Object> get props => [currentPage, totalPages, isLastPage, isFirstPage];
}

class OnboardingCompleted extends OnboardingState {}
