import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class PostNavigation extends StatelessWidget {
  const PostNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () {
      context.pushNamed('post-list');
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
      'Xem tất cả bài viết',
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    )
    );
  }
}
