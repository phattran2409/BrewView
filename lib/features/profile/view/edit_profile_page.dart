import 'package:briewview/app/di/locator.dart';
import 'package:briewview/core/widgets/curvedBottom_clipper.dart';
import 'package:briewview/features/profile/model/profile_dto.dart';
import 'package:briewview/features/profile/viewmodel/profile_bloc.dart';
import 'package:briewview/features/profile/viewmodel/profile_event.dart';
import 'package:briewview/features/profile/viewmodel/profile_state.dart';
import 'package:briewview/features/user_management/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late ProfileBloc _profileBloc;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _ageController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _provinceNameController;
  String? _selectedGender;
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    _profileBloc = getIt<ProfileBloc>();
    _profileBloc.add(LoadFullProfile());

    // Initialize controllers
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _ageController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _provinceNameController = TextEditingController();
    _selectedGender = '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _phoneNumberController.dispose();
    _provinceNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => _profileBloc,
        child: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileUpdated) {
              _showSnackBar('Thông tin đã được lưu thành công!');
              _profileBloc.add(LoadFullProfile());
            } else if (state is ProfileError) {
              _showSnackBar('Lỗi: ${state.message}');
            }
          },
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading || state is ProfileUpdating) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProfileLoaded) {
                UserModel profile = state.profile;
                if (_isFirstLoad) {
                  // Populate controllers with profile data
                  _nameController.text = profile.name;
                  _emailController.text = profile.email;
                  _ageController.text = profile.age?.toString() ?? '';
                  _phoneNumberController.text = profile.phoneNumber ?? '';
                  _provinceNameController.text = profile.provinceName ?? '';
                  _selectedGender = profile.gender ?? '';
                  _isFirstLoad = false;
                }
                return _mainEdit(profile);
              } else if (state is ProfileUpdated) {
                _isFirstLoad = true;
                _profileBloc.add(LoadFullProfile());
              } 
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _mainEdit(UserModel profile) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF8B4513),
            Color(0xFF3F2700), // Slightly darker beige
          ],
        ),
      ),
      child: Column(
        children: [
          _avtarProfile(profile.profilePicture),
          _editProfileForm(profile),
        ],
      ),
    );
  }

  Widget _backButton() {
    return IconButton(
      onPressed: () => context.goNamed('profile'),
      icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF8B4513)),
    );
  }

  Widget _avtarProfile(String? profilePicture) {
    return ClipPath(
      clipper: CurvedBottomClipper(),
      child: Container(
        width: double.infinity,
        height: 300,
        decoration: BoxDecoration(color: Color(0xFFEDE4DD)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: _backButton(),
                ),
              ],
            ),
            CircleAvatar(
              radius: 60,
              backgroundImage:
                  profilePicture != null && profilePicture.isNotEmpty
                      ? NetworkImage(profilePicture)
                      : AssetImage('assets/images/user.png') as ImageProvider,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _editProfileForm(UserModel profile) {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Thông tin cá nhân',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B4513),
                ),
              ),
              const SizedBox(height: 20),

              // Name Field
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Họ và tên',
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Color(0xFF8B4513),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFF8B4513),
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Email Field
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email, color: Color(0xFF8B4513)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFF8B4513),
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Age Field
              TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Tuổi',
                  prefixIcon: const Icon(Icons.cake, color: Color(0xFF8B4513)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFF8B4513),
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Gender Dropdown
              DropdownButtonFormField<String>(
                value: _selectedGender!.isNotEmpty ? _selectedGender : null,
                decoration: InputDecoration(
                  labelText: 'Giới tính',
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    color: Color(0xFF8B4513),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFF8B4513),
                      width: 2,
                    ),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'Male', child: Text('Nam')),
                  DropdownMenuItem(value: 'Female', child: Text('Nữ')),
                  DropdownMenuItem(value: 'Other', child: Text('Khác')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Phone Number Field
              TextField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Số điện thoại',
                  prefixIcon: const Icon(Icons.phone, color: Color(0xFF8B4513)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFF8B4513),
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Province Name Field
              TextField(
                controller: _provinceNameController,
                decoration: InputDecoration(
                  labelText: 'Tỉnh/Thành phố',
                  prefixIcon: const Icon(
                    Icons.location_city,
                    color: Color(0xFF8B4513),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFF8B4513),
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    _saveProfile(profile);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B4513),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    'Lưu thông tin',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ), // Thêm padding bottom để tránh overflow
            ],
          ),
        ),
      ),
    );
  }

  void _saveProfile(UserModel profile) {
    print(
      'Event dispatched: ${_nameController.text}, ${_emailController.text}, $_ageController, $_selectedGender, ${_phoneNumberController.text}, ${_provinceNameController.text}',
    );
    // Validate inputs
    if (_nameController.text.isEmpty) {
      _showSnackBar('Vui lòng nhập họ và tên của bạn');
      return;
    }

    if (_emailController.text.isEmpty) {
      _showSnackBar('Vui lòng nhập email của bạn');
      return;
    }

    if (_ageController.text.isEmpty) {
      _showSnackBar('Vui lòng nhập tuổi của bạn');
      return;
    }

    int? age = int.tryParse(_ageController.text);
    if (age == null || age < 0 || age > 150) {
      _showSnackBar('Tuổi không hợp lệ');
      return;
    }

    if (_selectedGender == null) {
      _showSnackBar('Vui lòng chọn giới tính của bạn');
      return;
    }

    if (_phoneNumberController.text.isEmpty) {
      _showSnackBar('Vui lòng nhập số điện thoại của bạn');
      return;
    }

    if (_provinceNameController.text.isEmpty) {
      _showSnackBar('Vui lòng nhập tỉnh/thành phố của bạn');
      return;
    }

    ProfileDTO updatedProfile = ProfileDTO(
      age: age,
      gender: _selectedGender,
      phoneNumber: _phoneNumberController.text,
      provinceName: _provinceNameController.text,
    );

    print('Dispatching UpdateProfile event: ${updatedProfile.toJson()}');
    _profileBloc.add(UpdateProfile(profileDTO: updatedProfile));

    // Không hiển thị success message ở đây, sẽ được handle trong BlocListener
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color.fromARGB(255, 206, 31, 31),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
