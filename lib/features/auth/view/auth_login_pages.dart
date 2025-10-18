import 'package:briewview/core/widgets/wave_clipper.dart';
import 'package:briewview/features/auth/view/widgets/social_login_buttons.dart';
import 'package:briewview/features/auth/viewModel/Bloc/Auth_Bloc.dart';
import 'package:briewview/features/auth/viewModel/Bloc/Auth_event.dart';
import 'package:briewview/features/auth/viewModel/Bloc/Auth_state.dart';
import 'package:briewview/features/post/view/post_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:briewview/features/auth/view/widgets/auth_forgotpassword_widget.dart';
import 'package:briewview/features/auth/view/auth_register_pages.dart';
import 'package:briewview/core/utils/validators.dart';
import 'package:go_router/go_router.dart';

class AuthLoginPage extends StatefulWidget {
  const AuthLoginPage({super.key});

  @override
  State<AuthLoginPage> createState() => _AuthLoginPageState();
}

class _AuthLoginPageState extends State<AuthLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          // Navigate to home
          final userHasCompletedSurvey = state.user.userJson?.isSurvey == true;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Welcome ${state.user.userJson?.name ?? ''}!'),
              backgroundColor: Colors.green,
            ),
          );
           if (userHasCompletedSurvey) {
            context.go('/home'); 
          } else {
            context.go('/survey'); 
          }
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              action:
                  state.errorCode != null
                      ? SnackBarAction(
                        label: 'Retry',
                        textColor: Colors.white,
                        onPressed:
                            () =>
                                _retryBasedOnError(context, state.errorCode!),
                      )
                      : null,
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
                            // Logo
                            Image(
                              width: 120,
                              height: 150,
                              image: AssetImage('assets/images/logo_app.png'),
                            ),
                            Text(
                              'BrewView',
                              style: Theme.of(
                                context,
                              ).textTheme.headlineLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Chào mừng! Vui lòng đăng nhập để tiếp tục',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(color: Colors.white70),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 48),

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
                                  hintText: 'Nhập mật khẩu của bạn',
                                  hintStyle: TextStyle(color: Colors.white54),
                                ),
                                validator: Validators.validateSimplePassword,
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Forgot Password Widget
                            AuthForgotpasswordWidget(),

                            const SizedBox(height: 32),

                            // Login Button
                            ElevatedButton(
                              onPressed:
                                  (state is AuthEmailLoginInProgress)
                                      ? null
                                      : () => _handleEmailLogin(context),
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
                                        'Đăng nhập',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                            ),

                            const SizedBox(height: 24),

                            // Sign Up Link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Chưa có tài khoản? ",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => _handleSignUp(),
                                  child: Text(
                                    'Đăng ký',
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

                            const SizedBox(height: 24),

                            PostNavigation(),
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
      );
  }

  // Email Login Handler
  void _handleEmailLogin(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
    // context.pushNamed('home');  
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
        // Retry last login attempt
        break;
      default:
        // Default retry
        break;
    }
  }

  void _handleSignUp() {
    // Navigate to sign up page
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const AuthRegisterPage()));
  }


}
