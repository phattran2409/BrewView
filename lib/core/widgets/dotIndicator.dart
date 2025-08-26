
import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  final int currentIndex;
  final int dotCount;
  final PageController? pageController;
  final Color? activeColor;
  final Color? inactiveColor;
  final double? activeWidth;
  final double? inactiveWidth;
  final double? height;
  final double? spacing;
  final Duration? animationDuration;
  final Curve? animationCurve;
  final VoidCallback? onTap;
  final Function(int)? onDotTap;

  const DotIndicator({
    Key? key,
    required this.currentIndex,
    required this.dotCount,
    this.pageController,
    this.activeColor,
    this.inactiveColor,
    this.activeWidth,
    this.inactiveWidth,
    this.height,
    this.spacing,
    this.animationDuration,
    this.animationCurve,
    this.onTap,
    this.onDotTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(dotCount, (index) {
        return GestureDetector(
          onTap: () {
            // Handle individual dot tap
            if (onDotTap != null) {
              onDotTap!(index);
            }
            
            // Auto navigate if pageController provided
            if (pageController != null) {
              pageController!.animateToPage(
                index,
                duration: animationDuration ?? const Duration(milliseconds: 300),
                curve: animationCurve ?? Curves.easeInOut,
              );
            }
            
            // General tap callback
            if (onTap != null) {
              onTap!();
            }
          },
          child: AnimatedContainer(
            duration: animationDuration ?? const Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(horizontal: spacing ?? 4),
            width: currentIndex == index 
                ? (activeWidth ?? 24) 
                : (inactiveWidth ?? 8),
            height: height ?? 8,
            decoration: BoxDecoration(
              color: currentIndex == index 
                  ? (activeColor ?? Colors.white)
                  : (inactiveColor ?? Colors.grey[600]),
              borderRadius: BorderRadius.circular((height ?? 8) / 2),
            ),
          ),
        );
      }),
    );
  }
}