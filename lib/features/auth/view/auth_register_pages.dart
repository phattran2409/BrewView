import 'package:briewview/core/widgets/wave_clipper.dart';
import 'package:briewview/features/auth/view/widgets/social_login_buttons.dart';
import 'package:briewview/features/auth/viewModel/Bloc/Auth_Bloc.dart';
import 'package:briewview/features/auth/viewModel/Bloc/Auth_event.dart';
import 'package:briewview/features/auth/viewModel/Bloc/Auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:briewview/app/di/locator.dart';
import 'package:briewview/core/utils/validators.dart';
import 'package:briewview/core/widgets/password_strength_indicator.dart';
import 'package:go_router/go_router.dart';

class AuthRegisterPage extends StatefulWidget {
  const AuthRegisterPage({super.key});

  @override
  State<AuthRegisterPage> createState() => _AuthRegisterPageState();
}

class _AuthRegisterPageState extends State<AuthRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => getIt<AuthBloc>(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          // ✅ Enhanced state handling với registration flow
          if (state is AuthRegisterSuccess) {
            // Registration successful but may need email verification
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Đăng ký thành công! ${state.requiresEmailVerification ? 'Vui lòng xác nhận email của bạn.' : 'Chào mừng bạn!' }',
                ),
                backgroundColor: Colors.green,
              ),
            );

            if (state.requiresEmailVerification) {
              print('Navigate to OTP with email verification');
              context.pushReplacementNamed(
                'otp',
                pathParameters: {'id': state.userId?.toString() ?? ''},
                extra: state.email,
              );
            } else {
              // Direct access, go to home
              context.goNamed('home');
            }
          } else if (state is AuthEmailVerificationSent) {
            // Email verification sent, navigate to OTP
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Email xác nhận đã được gửi đến ${state.email}'),
                backgroundColor: Colors.blue,
              ),
            );

            context.pushReplacementNamed(
              'otp',
              extra: {
                'email': state.email,
                'name': _fullNameController.text.trim(),
                'needsVerification': true,
                'isRegistration': true,
              },
            );
          } else if (state is AuthAuthenticated) {
            // User is already authenticated (social login registration)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Chào mừng ${state.user.userJson?.name ?? ''}!'),
                backgroundColor: Colors.green,
              ),
            );

            // ✅ Check provider to determine navigation
            if (state.provider == 'email') {
              // Email authentication might still need verification in some cases
              // For now, go to home as email auth is complete
              context.goNamed('home');
            } else {
              // Social login registration, go directly to home
              context.goNamed('home');
            }
          } else if (state is AuthEmailRegisterInProgress) {
            // Show loading state for email registration
            print('Email registration in progress...');
          } else if (state is AuthLoading) {
            // Generic loading state
            print('Registration in progress...');
          } else if (state is AuthError) {
            // ✅ Handle different error types
            print('Registration error: ${state.message}');

            String errorMessage = state.message;
            Color errorColor = Colors.red;

            // Customize error message based on error code
            if (state.errorCode == 'EMAIL_ALREADY_EXISTS') {
              errorMessage =
                  'Email này đã được đăng ký. Vui lòng đăng nhập.';
              errorColor = Colors.orange;
            } else if (state.errorCode == 'WEAK_PASSWORD') {
              errorMessage =
                  'Mật khẩu quá yếu. Vui lòng sử dụng mật khẩu mạnh hơn.';
            } else if (state.errorCode == 'INVALID_EMAIL') {
              errorMessage = 'Vui lòng nhập địa chỉ email hợp lệ.';
            } else if (state.errorCode == 'NETWORK_ERROR') {
              errorMessage =
                  'Lỗi mạng. Vui lòng kiểm tra kết nối của bạn và thử lại.';
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: errorColor,
                action: SnackBarAction(
                  label: 'Retry',
                  textColor: Colors.white,
                  onPressed:
                      () => _retryBasedOnError(context, state.errorCode ?? ''),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: [
                // Background
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 172, 89, 1),
                  ),
                ),

                // Wave ClipPath
                ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF763C0C), // Màu trên
                          Color(0xFF5A2D09), // Màu transition
                        ],
                      ),
                    ),
                  ),
                ),

                // Content
                SafeArea(
                  top: true,
                  left: true,
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(child: Row(children: [_buttonBack()])),
                            _buildHeader(),
                            const SizedBox(height: 16),
                            Text(
                              'Tạo tài khoản để bắt đầu',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(color: Colors.white70),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),
                            // Full Name Input
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: TextFormField(
                                controller: _fullNameController,
                                keyboardType: TextInputType.name,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Họ và tên',
                                  labelStyle: TextStyle(color: Colors.white70),
                                  prefixIcon: Icon(
                                    Icons.person_outline,
                                    color: Colors.white70,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(16),
                                  hintText: 'Nhập họ và tên của bạn',
                                  hintStyle: TextStyle(color: Colors.white54),
                                ),
                                validator: Validators.validateFullName,
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Email Input
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: TextStyle(color: Colors.white70),
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    color: Colors.white70,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(16),
                                  hintText: 'Nhập email của bạn',
                                  hintStyle: TextStyle(color: Colors.white54),
                                ),
                                validator: Validators.validateEmail,
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Password Input
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Mật khẩu',
                                  labelStyle: TextStyle(color: Colors.white70),
                                  prefixIcon: Icon(
                                    Icons.lock_outline,
                                    color: Colors.white70,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: Colors.white70,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(16),
                                  hintText: 'Tạo mật khẩu mạnh',
                                  hintStyle: TextStyle(color: Colors.white54),
                                ),
                                validator: Validators.validatePassword,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Password Strength Indicator
                            if (_passwordController.text.isNotEmpty)
                              PasswordStrengthIndicator(
                                password: _passwordController.text,
                                height: 6.0,
                                borderRadius: 3.0,
                              ),

                            const SizedBox(height: 16),

                            // Confirm Password Input
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: _obscureConfirmPassword,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Xác nhận mật khẩu',
                                  labelStyle: TextStyle(color: Colors.white70),
                                  prefixIcon: Icon(
                                    Icons.lock_outline,
                                    color: Colors.white70,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureConfirmPassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: Colors.white70,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureConfirmPassword =
                                            !_obscureConfirmPassword;
                                      });
                                    },
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(16),
                                  hintText: 'Xác nhận mật khẩu của bạn',
                                  hintStyle: TextStyle(color: Colors.white54),
                                ),
                                validator:
                                    (value) =>
                                        Validators.validateConfirmPassword(
                                          value,
                                          _passwordController.text,
                                        ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Terms and Conditions
                            Row(
                              children: [
                                Checkbox(
                                  value: _agreeToTerms,
                                  onChanged: (value) {
                                    setState(() {
                                      _agreeToTerms = value ?? false;
                                    });
                                  },
                                  activeColor: Colors.white,
                                  checkColor: const Color(0xFF763C0C),
                                ),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                      children: [
                                        TextSpan(text: 'Tôi đồng ý với '),
                                        TextSpan(
                                          text: 'Điều khoản dịch vụ',
                                          style: TextStyle(
                                            color: Colors.white,
                                            decoration:
                                                TextDecoration.underline,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(text: ' và '),
                                        TextSpan(
                                          text: 'Chính sách bảo mật',
                                          style: TextStyle(
                                            color: Colors.white,
                                            decoration:
                                                TextDecoration.underline,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 32),

                            // Register Button
                            ElevatedButton(
                              onPressed:
                                  (state is AuthEmailRegisterInProgress || 
                                   state is AuthEmailLoginInProgress ||
                                   !_agreeToTerms)
                                      ? null
                                      : () => _handleRegister(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF763C0C),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 8,
                                shadowColor: Colors.black.withOpacity(0.3),
                              ),
                              child:
                                  (state is AuthEmailLoginInProgress)
                                      ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Color(0xFF763C0C),
                                              ),
                                        ),
                                      )
                                      : const Text(
                                        'Tạo tài khoản',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                            ),

                            const SizedBox(height: 24),

                            // Sign In Link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Đã có tài khoản? ",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => _handleSignIn(),
                                  child: Text(
                                    'Đăng nhập',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 32),

                            // OR Divider
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: Colors.white.withOpacity(0.3),
                                    thickness: 1,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Text(
                                    'HOẶC',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Colors.white.withOpacity(0.3),
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Social Login Buttons
                            SocialLoginButtons(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buttonBack() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: IconButton(
        onPressed: () {
          // Handle back navigation
          context.goNamed('login'); 
        },
        icon: Icon(Icons.arrow_back, color: Colors.white, size: 24),
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image(
            width: 120,
            height: 150,
            image: AssetImage('assets/images/logo_app.png'),
          ),
          Text(
            'BrewView',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: const Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Register Handler
  void _handleRegister(BuildContext context) {
    if (_formKey.currentState!.validate() && _agreeToTerms) {
      final authBloc = context.read<AuthBloc>();
      if (!authBloc.isClosed) {
        authBloc.add(
          AuthRegisterRequested(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            name: _fullNameController.text.trim(),
          ),
        );
      }
    } else if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Bạn phải đồng ý với Điều khoản dịch vụ và Chính sách bảo mật để tiếp tục.',
          ),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  // Retry based on error code
  void _retryBasedOnError(BuildContext context, String errorCode) {
    switch (errorCode) {
      case 'FACEBOOK_LOGIN_ERROR':
        context.read<AuthBloc>().add(const AuthFacebookLoginRequested());
        break;
      case 'GOOGLE_LOGIN_ERROR':
        context.read<AuthBloc>().add(const AuthGoogleLoginRequested());
        break;
      case 'SAVE_ERROR':
        // Retry last registration attempt
        break;
      default:
        // Default retry
        break;
    }
  }

  void _handleSignIn() {
    // Navigate back to sign in page
    Navigator.of(context).pop();
  }
}
