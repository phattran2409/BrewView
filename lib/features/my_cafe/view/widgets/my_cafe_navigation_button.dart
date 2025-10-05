import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Demo navigation button for My Cafe feature
/// You can add this button to any page where you want to access the my cafe feature
class MyCafeNavigationButton extends StatelessWidget {
  const MyCafeNavigationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Navigate to my cafes page
        context.pushNamed('my-cafes');
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
        'My Cafes',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
