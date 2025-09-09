
import 'package:briewview/features/auth/viewModel/Bloc/Auth_event.dart';
import 'package:briewview/features/auth/viewModel/Bloc/Auth_state.dart';
import '../../viewModel/Bloc/Auth_Bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc,AuthState>(
      
      builder: (context, state) {
        return Column(
          children: [
            // Google Login Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: (state is AuthGoogleLoginInProgress) 
                    ? null 
                    : () => context.read<AuthBloc>().add(
                        const AuthGoogleLoginRequested()
                      ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: Colors.white.withOpacity(0.5),
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: (state is AuthGoogleLoginInProgress)
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/google.png',
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Continue with Google',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Facebook Login Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: (state is AuthFacebookLoginInProgress) 
                    ? null 
                    : () => context.read<AuthBloc>().add(
                        const AuthFacebookLoginRequested()
                      ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: Colors.white.withOpacity(0.5),
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: (state is AuthFacebookLoginInProgress)
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/facebook.png',
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Continue with Facebook',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}