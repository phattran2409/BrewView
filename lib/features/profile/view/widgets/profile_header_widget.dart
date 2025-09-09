import 'package:flutter/material.dart';
import 'package:briewview/features/user_management/model/user_model.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final UserModel profile;
  final VoidCallback? onEditPressed;
  final VoidCallback? onSeeMorePressed;
  final VoidCallback? onCameraPressed;

  const ProfileHeaderWidget({
    Key? key,
    required this.profile,
    this.onEditPressed,
    this.onSeeMorePressed,
    this.onCameraPressed,
  }) : super(key: key);

  
  @override
  Widget build(BuildContext context) { 
    ImageProvider? _getProfileImage() {
      if (profile.profilePicture != null && profile.profilePicture!.isNotEmpty) {
        return NetworkImage(profile.profilePicture!);
      } else {
        return AssetImage('assets/images/user.png');
      }
    } 
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFFF5F1EB), // Light beige color
      ),
      child: Column(
        children: [
          // Back button and language toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xFF8B4513),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Profile info section
          Row(
            children: [
              // Avatar with camera icon
              Stack(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(0xFF8B4513), // Dark brown
                    backgroundImage: _getProfileImage(),
                    child:
                        profile.profilePicture == null
                            ? const Icon(
                              Icons.person,
                              size: 40,
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
                          color: Color(0xFF8B4513), // Dark brown
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
              const SizedBox(width: 20),

              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name,
                      style: const TextStyle(
                        color: Color(0xFF8B4513), // Dark brown
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile.email,
                      style: const TextStyle(
                        color: Color(0xFF8B4513), // Dark brown
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // bio not available on UserModel by default
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onEditPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B4513), // Dark brown
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Chỉnh sửa',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Xem thêm',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
