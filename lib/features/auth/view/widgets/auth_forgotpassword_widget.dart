import 'package:briewview/features/auth/viewModel/Bloc/Auth_Bloc.dart';
import 'package:briewview/features/auth/viewModel/Bloc/Auth_event.dart';
import 'package:briewview/features/auth/viewModel/Bloc/Auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AuthForgotpasswordWidget extends StatelessWidget {
  const AuthForgotpasswordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    void handleForgotPassword(BuildContext rootContext) {
      showDialog(
        context: rootContext,
        barrierDismissible: false,
        builder: (dialogContext) {
          final emailController = TextEditingController();
          final formKey = GlobalKey<FormState>();

          // ✅ Sử dụng global AuthBloc thay vì tạo BlocProvider mới
          return AlertDialog(
            backgroundColor: const Color(0xFF763C0C),
            title: const Text(
              'Reset Password',
              style: TextStyle(color: Colors.white),
            ),
            content: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) async {
                if (state is AuthForgotPasswordSuccess) {
                  // Close dialog
                  if (Navigator.of(dialogContext).canPop()) {
                    Navigator.of(dialogContext).pop();
                  }

                  // Show success message
                  if (rootContext.mounted) {
                    ScaffoldMessenger.of(rootContext).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 3),
                      ),
                    );

                    // Navigate to reset password page
                    final encodedEmail = Uri.encodeComponent(
                      emailController.text.trim(),
                    );
                    rootContext.go('/reset-password?email=$encodedEmail');
                  }
                } else if (state is AuthError) {
                  if (rootContext.mounted) {
                    ScaffoldMessenger.of(rootContext).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                }
              },
              builder: (context, state) {
                return Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Enter your email address to receive a password reset link.',
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.white70),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your email';
                          }

                          final emailRegex = RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          );
                          if (!emailRegex.hasMatch(value.trim())) {
                            return 'Please enter a valid email address';
                          }

                          return null;
                        },
                      ),

                      if (state is AuthEmailForgotPasswordInProgress) ...[
                        const SizedBox(height: 16),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Sending...',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final isLoading = state is AuthEmailForgotPasswordInProgress;

                  return ElevatedButton(
                    onPressed:
                        isLoading
                            ? null
                            : () {
                              if (formKey.currentState!.validate()) {
                                final email = emailController.text.trim();
                                // ✅ Sử dụng global AuthBloc
                                context.read<AuthBloc>().add(
                                  AuthForgotPasswordRequested(email: email),
                                );
                              }
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isLoading ? Colors.grey : Colors.white,
                      foregroundColor: const Color(0xFF763C0C),
                    ),
                    child:
                        isLoading
                            ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF763C0C),
                                ),
                              ),
                            )
                            : const Text('Send'),
                  );
                },
              ),
            ],
          );
        },
      );
    }

    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => handleForgotPassword(context),
        child: const Text(
          'Forgot Password?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.underline,
            decorationColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
