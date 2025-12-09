import 'package:briewview/core/widgets/curvedBottom_clipper.dart';
import 'package:flutter/material.dart';
import 'package:briewview/features/user_management/model/user_model.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final UserModel profile;
  final VoidCallback? onEditPressed;
  final VoidCallback? onSeeMorePressed;
  final VoidCallback? onCameraPressed;

  const ProfileHeaderWidget({
    super.key,
    required this.profile,
    this.onEditPressed,
    this.onSeeMorePressed,
    this.onCameraPressed,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider? getProfileImage() {
      if (profile.profilePicture != null &&
          profile.profilePicture!.isNotEmpty) {
        return NetworkImage(profile.profilePicture!);
      } else {
        return AssetImage('assets/images/user.png');
      }
    }

    return ClipPath(
      clipper: CurvedBottomClipper(),
      child: Container(
        height: 300, // Giảm từ 400 xuống 280
        padding: const EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
          bottom: 20,
        ),
        decoration: BoxDecoration(color: Color(0xFFEDE4DD)),
        child: Column(
          children: [
            const SizedBox(height: 30), // Giảm từ 20 xuống 10
            // Profile info section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 35, // Giảm từ 40 xuống 35
                          backgroundColor: const Color(0xFF8B4513),
                          backgroundImage: getProfileImage(),
                          child:
                              profile.profilePicture == null
                                  ? const Icon(
                                    Icons.person,
                                    size: 35, // Giảm từ 40 xuống 35
                                    color: Colors.white,
                                  )
                                  : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: onCameraPressed,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFF8B4513),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name,
                        style: const TextStyle(
                          color: Color(0xFF8B4513),
                          fontSize: 18, // Giảm từ 20 xuống 18
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile.email,
                        style: const TextStyle(
                          color: Color(0xFF8B4513),
                          fontSize: 13, // Giảm từ 14 xuống 13
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onEditPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B4513), // Dark brown
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                      ), // Giảm từ 12 xuống 10
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Chỉnh sửa',
                      style: TextStyle(
                        fontSize: 15, // Giảm từ 16 xuống 15
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onSeeMorePressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF5F1EB), // Light beige
                      foregroundColor: const Color(0xFF8B4513), // Dark brown
                      side: const BorderSide(
                        color: Color(0xFF8B4513), // Dark brown
                        width: 1,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                      ), // Giảm từ 12 xuống 10
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Xem thêm',
                      style: TextStyle(
                        fontSize: 15, // Giảm từ 16 xuống 15
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
