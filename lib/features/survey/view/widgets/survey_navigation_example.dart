import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:briewview/app/router/route_paths.dart';

/// Example widget showing how to navigate to the survey page
/// You can add this button to any page where you want to access the survey
class SurveyNavigationButton extends StatelessWidget {
  const SurveyNavigationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Navigate to survey page
        context.pushNamed('survey');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF763C0C),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        'Khảo sát',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// Alternative navigation method using context.go()
class SurveyNavigationButtonAlt extends StatelessWidget {
  const SurveyNavigationButtonAlt({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Alternative navigation method
        context.go(RoutePaths.survey);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF763C0C),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        'Take Survey (Alt)',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
