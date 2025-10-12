import 'package:briewview/app/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.toString();
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 35, 35, 35),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(92, 255, 253, 253).withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context,
            Icons.home,
            'Trang chủ',
            RoutePaths.home,
            currentLocation,
          ),
          _buildNavItem(
            context,
            Icons.map,
            'Bản đồ',
            RoutePaths.map,
            currentLocation,
          ),
          _buildNavItem(
            context,
            Icons.search,
            'Tìm kiếm',
            RoutePaths.search,
            currentLocation,
          ),
          _buildNavItem(
            context,
            Icons.person,
            'Cá nhân',
            RoutePaths.profile,
            currentLocation,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    String route,
    String currentLocation,
  ) {
    final isSelected =
        currentLocation == route || currentLocation.startsWith(route);
    return GestureDetector(
      onTap: () {
        // Handle navigation on tap
        if (!isSelected) {
          context.go(route);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.black : Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[400],
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
