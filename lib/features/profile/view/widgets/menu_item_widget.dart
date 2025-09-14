import 'package:flutter/material.dart';

class MenuItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final bool showDivider;

  const MenuItemWidget({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            icon,
            color: const Color(0xFFF5F1EB), // Light beige
            size: 24,
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Color(0xFFF5F1EB), // Light beige
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Color(0xFFF5F1EB), // Light beige
            size: 16,
          ),
          onTap: onTap,
        ),
        if (showDivider)
          const Divider(
            color: Color(0xFFF5F1EB), // Light beige
            height: 1,
            thickness: 0.5,
          ),
      ],
    );
  }
}

