import 'package:briewview/core/widgets/wave_clipper.dart';
import 'package:briewview/features/auth/viewModel/Bloc/Auth_Bloc.dart';
import 'package:briewview/features/auth/viewModel/Bloc/Auth_event.dart';
import 'package:briewview/features/auth/viewModel/Bloc/Auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:briewview/core/utils/validators.dart';
import 'package:go_router/go_router.dart';

class AuthResetPasswordPage extends StatefulWidget {
  final String email;

  const AuthResetPasswordPage({super.key, required this.email});

  @override
  State<AuthResetPasswordPage> createState() => _AuthResetPasswordPageState();
}

class _AuthResetPasswordPageState extends State<AuthResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _obscureCurrentPassword = true;  

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Loại bỏ BlocProvider vì đã có global
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthPasswordResetSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Password reset successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          context.go('/login');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
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
                          const SizedBox(height: 20),

                          // Logo
                          Image(
                            width: 120,
                            height: 150,
                            image: AssetImage('assets/images/logo_app.png'),
                          ),

                          Text(
                            'Reset Password',
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
                            'Enter your new password for ${widget.email}',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: Colors.white70),
                            textAlign: TextAlign.center,
                          ),

                          // ✅ Thêm khoảng cách trước form
                          const SizedBox(height: 48),

                          // Current Password Input
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
                              controller: _currentPasswordController,
                              obscureText: _obscureCurrentPassword,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Current Password',
                                labelStyle: TextStyle(color: Colors.white70),
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: Colors.white70,
                                ),
                                suffixIcon: IconButton(
                                  icon:  Icon(
                                     _obscureCurrentPassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined, 
                                        
                                    color: Colors.white70,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureCurrentPassword = !_obscureCurrentPassword;
                                    });
                                  },
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(16),
                                hintText: 'Enter your current password',
                                hintStyle: TextStyle(color: Colors.white54),
                              ),
                            ),
                          ),

                          // ✅ Thêm khoảng cách giữa các TextFormField
                          const SizedBox(height: 20),

                          // New Password Input
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
                                labelText: 'New Password',
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
                                hintText: 'Enter your new password',
                                hintStyle: TextStyle(color: Colors.white54),
                              ),
                              validator: Validators.validateSimplePassword,
                            ),
                          ),

                          // ✅ Tăng khoảng cách giữa New Password và Confirm Password
                          const SizedBox(height: 20),

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
                                labelText: 'Confirm Password',
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
                                hintText: 'Confirm your new password',
                                hintStyle: TextStyle(color: Colors.white54),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                          ),

                          // ✅ Tăng khoảng cách trước button
                          const SizedBox(height: 40),

                          // Reset Password Button
                          ElevatedButton(
                            onPressed:
                                (state is AuthPasswordResetInProgress)
                                    ? null
                                    : () => _handlePasswordReset(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF763C0C),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 8,
                              shadowColor: Colors.black.withOpacity(0.3),
                            ),
                            child:
                                (state is AuthPasswordResetInProgress)
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
                                      'Reset Password',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                          ),

                          // ✅ Tăng khoảng cách trước link
                          const SizedBox(height: 32),

                          // Back to Login Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Remember your password? ",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                onPressed: () => context.go('/login'),
                                child: Text(
                                  'Sign In',
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

  // Password Reset Handler
  void _handlePasswordReset(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthPasswordResetRequested(
          email: widget.email,
          currentPassword: _currentPasswordController.text,
          newPassword: _passwordController.text,
        ),
      );
    }
  }
}
