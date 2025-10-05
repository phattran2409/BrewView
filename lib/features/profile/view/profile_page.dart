import 'package:briewview/app/di/locator.dart';
import 'package:briewview/core/widgets/navigation_bar.dart';
import 'package:briewview/features/profile/view/widgets/image_picker_dialog.dart';
import 'package:briewview/features/profile/view/widgets/showMoreInfo_widget.dart';
import 'package:briewview/features/user_management/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../viewmodel/profile_bloc.dart';
import '../viewmodel/profile_event.dart';
import '../viewmodel/profile_state.dart';
import 'widgets/profile_header_widget.dart';
import 'widgets/menu_item_widget.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileBloc _profileBloc;
  bool _isProfileExpanded = false;
  UserModel? currentProfile; 

  @override
  void initState() {
    super.initState();
    _profileBloc = getIt<ProfileBloc>();
    _profileBloc.add(LoadProfile());
  }

  @override
  void dispose() {
    _profileBloc.close();
    super.dispose();
  }

  // Hàm để toggle expanded profile
  void _toggleProfileExpanded() {
    setState(() {
      _isProfileExpanded = !_isProfileExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8B4513),
      body: Stack(
        children: [
          // Main content
          BlocProvider(
            create: (context) => _profileBloc,
            child: BlocListener<ProfileBloc, ProfileState>(
              listener: (context, state) {
                if (state is ProfileError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (state is LoggedOut) {
                  context.go('/login');
                } else if (state is AccountDeleted) {
                  context.go('/login');
                }
                if (state is ProfilePictureUpdatedSuccess) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cập nhật ảnh đại diện thành công!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  _profileBloc.add(LoadProfile());
                }
              },
              child: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFF5F1EB),
                      ),
                    );
                  } else if (state is ProfileLoaded ||
                      state is ProfileUpdated) {
                    final profile =
                        state is ProfileLoaded
                            ? state.profile
                            : (state as ProfileUpdated).profile;

                    // return _buildProfileContent(profile);
                    currentProfile = profile as UserModel;
                    return Stack(
                      children: [
                        _buildProfileContent(profile),
                        // Hiển thị ShowMoreInfo khi có state ShowMoreInfoState
                        if (_isProfileExpanded && currentProfile != null)
                          ShowMoreInfoWidget(
                            profile: currentProfile!,
                            toggleProfileExpanded: _toggleProfileExpanded,
                          ),  
                      ],
                    );
                  } else if (state is ProfileError) {
                    return _buildErrorWidget(state.message);
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFF5F1EB),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          // Expanded Profile Overlay
          // if (_isProfileExpanded) ShowMoreInfoWidget(
          //   profile: profile,
          //   toggleProfileExpanded: _toggleProfileExpanded,
          // ),
        ],
      ),
    );
  }

  Widget _buildProfileContent(profile) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: const [Color(0xFF8B4513), Color(0xFF3F2700)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Profile header
          ProfileHeaderWidget(
            profile: profile,
            onEditPressed: () => _showEditDialog(),
            onSeeMorePressed: () => _toggleProfileExpanded(),
            onCameraPressed: () => _showImagePicker(),
          ),
          // Menu section
          Expanded(
            child: Container(
              child: ListView(
                children: [
                  MenuItemWidget(
                    icon: Icons.settings,
                    title: 'Cài đặt',
                    onTap: () => _navigateToSettings(),
                  ),
                  MenuItemWidget(
                    icon: Icons.local_offer,
                    title: 'Voucher của tôi',
                    onTap: () => _navigateToVouchers(),
                  ),
                  MenuItemWidget(
                    icon: Icons.local_cafe,
                    title: 'Quán Cafe của tôi',
                    onTap: () => _navigateToCafes(),
                  ),
                  MenuItemWidget(
                    icon: Icons.favorite_border,
                    title: 'Yêu thích',
                    onTap: () => _navigateToFavorites(),
                  ),
                  MenuItemWidget(
                    icon: Icons.history,
                    title: 'Gần đây',
                    onTap: () => _navigateToRecent(),
                  ),
                  MenuItemWidget(
                    icon: Icons.rate_review,
                    title: 'Viết review',
                    onTap: () => _navigateToWriteReview(),
                  ),
                  MenuItemWidget(
                    icon: Icons.payment,
                    title: 'Thông tin thanh toán',
                    onTap: () => _navigateToPaymentInfo(),
                  ),
                  MenuItemWidget(
                    icon: Icons.logout,
                    title: 'Logout',
                    onTap: () => _showLogoutDialog(),
                    showDivider: false,
                  ),
                ],
              ),
            ),
          ),
          CustomNavigationBar(),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Color(0xFFF5F1EB), // Light beige
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'Có lỗi xảy ra',
            style: const TextStyle(
              color: Color(0xFFF5F1EB), // Light beige
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(
              color: Color(0xFFF5F1EB), // Light beige
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _profileBloc.add(LoadProfile()),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF5F1EB), // Light beige
              foregroundColor: const Color(0xFF8B4513), // Dark brown
            ),
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog() {
    context.goNamed('profile-edit');
  }

  void _showImagePicker() {
    showDialog(
      context: context,
      builder:
          (context) => ImagePickerDialog(
            onImageSelected: (File imageFile) {
              _handleImageUpload(imageFile);
            },
          ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Đăng xuất'),
            content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  _profileBloc.add(Logout());
                },
                child: const Text('Đăng xuất'),
              ),
            ],
          ),
    );
  }

  void _navigateToSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tính năng cài đặt sẽ được phát triển')),
    );
  }

  void _navigateToVouchers() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tính năng voucher sẽ được phát triển')),
    );
  }

  void _navigateToCafes() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tính năng quán cafe sẽ được phát triển')),
    );
  }
  void _navigateToFavorites() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tính năng yêu thích sẽ được phát triển')),
    );
  }

  void _navigateToRecent() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tính năng gần đây sẽ được phát triển')),
    );
  }

  void _navigateToWriteReview() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tính năng viết review sẽ được phát triển')),
    );
  }

  void _navigateToPaymentInfo() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tính năng thanh toán sẽ được phát triển')),
    );
  }

  // Method xử lý upload ảnh
  void _handleImageUpload(File imageFile) {
    // TODO: Implement upload logic to server
    print('Selected image: ${imageFile.path}');

    // Hiển thị loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    _profileBloc.add(UpdateProfilePicture(imageFile.path));
  }

  // Widget overlay mở rộng profile
  // Widget _buildExpandedProfileOverlay() {
  //   return Container(
  //     color: Colors.black.withOpacity(0.5), // Background đen mờ
  //     child: Center(
  //       child: Container(
  //         margin: const EdgeInsets.all(20),
  //         decoration: BoxDecoration(
  //           color: Color(0xFFEDE4DD),
  //           borderRadius: BorderRadius.circular(20),
  //         ),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             // Header với nút đóng
  //             Container(
  //               padding: const EdgeInsets.all(16),
  //               decoration: const BoxDecoration(
  //                 color: Color(0xFF8B4513),
  //                 borderRadius: BorderRadius.only(
  //                   topLeft: Radius.circular(20),
  //                   topRight: Radius.circular(20),
  //                 ),
  //               ),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   const Text(
  //                     'Thông tin chi tiết',
  //                     style: TextStyle(
  //                       color: Colors.white,
  //                       fontSize: 18,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                   IconButton(
  //                     onPressed: _toggleProfileExpanded,
  //                     icon: const Icon(Icons.close, color: Colors.white),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             // Content
  //             Padding(
  //               padding: const EdgeInsets.all(20),
  //               child: Column(
  //                 children: [
  //                   // Profile picture
  //                   CircleAvatar(
  //                     radius: 50,
  //                     backgroundColor: const Color(0xFF8B4513),
  //                     backgroundImage: _getProfileImage(),
  //                     child:
  //                         _getProfileImage() == null
  //                             ? const Icon(
  //                               Icons.person,
  //                               size: 50,
  //                               color: Colors.white,
  //                             )
  //                             : null,
  //                   ),
  //                   const SizedBox(height: 20),
  //                   // Profile info
  //                   _buildInfoRow('Tên', 'Nguyễn Văn A'),
  //                   _buildInfoRow('Email', 'nguyenvana@example.com'),
  //                   _buildInfoRow('Số điện thoại', '0123456789'),
  //                   _buildInfoRow('Ngày sinh', '01/01/1990'),
  //                   _buildInfoRow('Giới tính', 'Nam'),
  //                   _buildInfoRow('Địa chỉ', '123 Đường ABC, Quận XYZ, TP.HCM'),
  //                   const SizedBox(height: 20),
  //                   // Action buttons
  //                   Row(
  //                     children: [
  //                       Expanded(
  //                         child: ElevatedButton(
  //                           onPressed: () {
  //                             _toggleProfileExpanded();
  //                             _showEditDialog();
  //                           },
  //                           style: ElevatedButton.styleFrom(
  //                             backgroundColor: const Color(0xFF8B4513),
  //                             foregroundColor: Colors.white,
  //                             padding: const EdgeInsets.symmetric(vertical: 12),
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(8),
  //                             ),
  //                           ),
  //                           child: const Text('Chỉnh sửa'),
  //                         ),
  //                       ),
  //                       const SizedBox(width: 12),
  //                       Expanded(
  //                         child: ElevatedButton(
  //                           onPressed: _toggleProfileExpanded,
  //                           style: ElevatedButton.styleFrom(
  //                             backgroundColor: const Color(0xFFF5F1EB),
  //                             foregroundColor: const Color(0xFF8B4513),
  //                             side: const BorderSide(
  //                               color: Color(0xFF8B4513),
  //                               width: 1,
  //                             ),
  //                             padding: const EdgeInsets.symmetric(vertical: 12),
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(8),
  //                             ),
  //                           ),
  //                           child: const Text('Đóng'),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Helper method để build info row
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



}
