import 'package:equatable/equatable.dart';

class OnboardingItem extends Equatable {
  final String title;
  final String description;
  final String imagePath;
  final String? animationPath; // For Lottie animations (optional)

  const OnboardingItem({
    required this.title,
    required this.description,
    required this.imagePath,
    this.animationPath,
  });

  @override
  List<Object?> get props => [title, description, imagePath, animationPath];
}
