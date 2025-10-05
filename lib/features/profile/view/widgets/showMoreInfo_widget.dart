import 'package:briewview/features/user_management/model/user_model.dart';
import 'package:flutter/material.dart';
 

class ShowMoreInfoWidget extends StatelessWidget {
  final UserModel profile;
  final VoidCallback? toggleProfileExpanded;

  const ShowMoreInfoWidget({
    super.key,
    required this.profile,
    this.toggleProfileExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return _buildExpandedProfileOverlay();
  }

  Widget _buildExpandedProfileOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.5), // Background đen mờ
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color(0xFFEDE4DD),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header với nút đóng
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFF8B4513),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Thông tin chi tiết',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: toggleProfileExpanded,
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Profile picture
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color(0xFF8B4513),
                      backgroundImage: _getProfileImage(),
                      child:
                          _getProfileImage() == null
                              ? const Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.white,
                              )
                              : null,
                    ),
                    const SizedBox(height: 20),
                    // Profile info
                    _buildInfoRow('Name', profile.name ?? 'N/A'),
                    _buildInfoRow('Email', profile.email ?? 'N/A' ),
                    _buildInfoRow('Phone', profile.phoneNumber ?? 'N/A'),
                    _buildInfoRow('Gender', profile.gender ?? 'N/A'),
                    _buildInfoRow('Province', profile.provinceName ?? 'N/A' ),
                    _buildInfoRow('Role', profile.role ?? 'N/A' ),
                    if(profile.isPremium == true)
                      _buildInfoRow('Premium User', 'Yes'),
                    const SizedBox(height: 20),
                    // Action buttons
                    Row(
                      children: [
                        // Expanded(
                        //   child: ElevatedButton(
                        //     onPressed: () {
                        //       _toggleProfileExpanded();
                        //       _showEditDialog();
                        //     },
                        //     style: ElevatedButton.styleFrom(
                        //       backgroundColor: const Color(0xFF8B4513),
                        //       foregroundColor: Colors.white,
                        //       padding: const EdgeInsets.symmetric(vertical: 12),
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(8),
                        //       ),
                        //     ),
                        //     child: const Text('Chỉnh sửa'),
                        //   ),
                        // ),
                        // const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: toggleProfileExpanded,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF5F1EB),
                              foregroundColor: const Color(0xFF8B4513),
                              side: const BorderSide(
                                color: Color(0xFF8B4513),
                                width: 1,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Đóng'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF8B4513),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Color(0xFF8B4513)),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method để lấy profile image
  ImageProvider? _getProfileImage() {
    if (profile.profilePicture != null && profile.profilePicture!.isNotEmpty) {
      return NetworkImage(profile.profilePicture!);
    }
    return null; // Trả về null nếu không có ảnh
  }

}
