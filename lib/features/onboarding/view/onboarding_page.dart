import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:briewview/app/router/route_paths.dart';
import 'package:briewview/features/onboarding/viewmodel/onboarding_bloc.dart';
import 'package:briewview/features/onboarding/viewmodel/onboarding_event.dart';
import 'package:briewview/features/onboarding/viewmodel/onboarding_state.dart';
import 'package:briewview/features/onboarding/view/widgets/onboarding_item_widget.dart';
import 'package:briewview/features/onboarding/view/widgets/page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingBloc()..add(const OnboardingPageChanged(0)),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocConsumer<OnboardingBloc, OnboardingState>(
            listener: (context, state) {
              if (state is OnboardingCompleted) {
                // Navigate to login screen
                context.go(RoutePaths.login);
              }
              if (state is OnboardingPageState) {
                // Only animate if PageController is attached
                if (_pageController.hasClients) {
                  _pageController.animateToPage(
                    state.currentPage,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              }
            },
            builder: (context, state) {
              if (state is OnboardingPageState) {
                final bloc = context.read<OnboardingBloc>();
                
                return Stack(
                  children: [
                    // PageView - Full Screen Background
                    PageView.builder(
                      controller: _pageController,
                      itemCount: bloc.onboardingItems.length,
                      onPageChanged: (index) {
                        bloc.add(OnboardingPageChanged(index));
                      },
                      itemBuilder: (context, index) {
                        return OnboardingItemWidget(
                          item: bloc.onboardingItems[index],
                        );
                      },
                    ),

                    // Top Controls - Skip Button
                    Positioned(
                      top: 16,
                      right: 16,
                      child: SafeArea(
                        child: !state.isLastPage
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: GestureDetector(
                                  onTap: () => bloc.add(OnboardingSkipPressed()),
                                  child: Text(
                                    'Skip',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),

                    // Bottom Controls
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: SafeArea(
                        child: Container(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Page Indicator
                              const SizedBox(height: 15),
                              PageIndicator(
                                currentPage: state.currentPage,
                                totalPages: state.totalPages,
                              ),

                              const SizedBox(height: 10),

                              // Navigation Buttons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Previous Button
                                  if (!state.isFirstPage)
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: TextButton(
                                        onPressed: () => bloc.add(OnboardingPreviousPressed()),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.arrow_back_ios,
                                              size: 16,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              'Previous',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  else
                                    const SizedBox(width: 100),

                                  // Next/Get Started Button
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.orange[400]!,
                                          Colors.orange[600]!,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(25),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.orange.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (state.isLastPage) {
                                          bloc.add(OnboardingGetStartedPressed());
                                        } else {
                                          bloc.add(OnboardingNextPressed());
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        foregroundColor: Colors.white,
                                        shadowColor: Colors.transparent,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 32,
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            state.isLastPage ? 'Get Started' : 'Next',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          if (!state.isLastPage) ...[
                                            const SizedBox(width: 8),
                                            const Icon(Icons.arrow_forward_ios, size: 16),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
