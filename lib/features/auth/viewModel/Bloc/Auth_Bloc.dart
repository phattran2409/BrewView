import 'package:briewview/features/auth/repository/auth_repository.dart';
import 'package:briewview/features/auth/services/facebook_auth_service.dart';
import 'package:briewview/features/auth/services/google_signin_service.dart';
import 'package:briewview/features/auth/viewModel/Bloc/Auth_event.dart';
import 'package:briewview/features/auth/viewModel/Bloc/Auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';


@singleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final FacebookAuthService _facebookAuthService;
  final GoogleSignInService _googleSignInService;

  AuthBloc(
    this._authRepository,
    this._facebookAuthService,
    this._googleSignInService,
  ) : super(const AuthInitial()) {
    // Event handlers
    on<AuthInitialized>(_onAuthInitialized);
    on<AuthStatusChecked>(_onAuthStatusChecked);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthFacebookLoginRequested>(_onAuthFacebookLoginRequested);
    on<AuthGoogleLoginRequested>(_onAuthGoogleLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  /// Khởi tạo auth state khi app start
  Future<void> _onAuthInitialized(
    AuthInitialized event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final isLoggedIn = await _authRepository.isLoggedIn();

      if (isLoggedIn) {
        final userResult = await _authRepository.getCurrentUser();
        userResult.fold(
          (failure) => emit(const AuthUnauthenticated()),
          (user) =>
              user != null
                  ? emit(AuthAuthenticated(user: user))
                  : emit(const AuthUnauthenticated()),
        );
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  /// Kiểm tra auth status
  Future<void> _onAuthStatusChecked(
    AuthStatusChecked event,
    Emitter<AuthState> emit,
  ) async {
    // Tương tự _onAuthInitialized
    add(const AuthInitialized());
  }

  /// Email/Password login
  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthEmailLoginInProgress());

    try {
      final result = await _authRepository.loginWithEmail(
        email: event.email,
        password: event.password,
      );

      // result.fold(
      //   (failure) => emit(AuthError(message: failure.toString())),
      //   (user) => emit(AuthAuthenticated(
      //     user: user,
      //     provider: 'email',
      //   )),
      // );
      print('result API LOGIN : $result');
      print(result.userJson);
      print(result.isSuccess);
      if (result.isSuccess && result.userJson != null) {
        emit(AuthAuthenticated(user: result, provider: 'email'));
      }
    } catch (e) {
      print('e: $e'); 
      emit(AuthError(message: e.toString()));
    }
  }

  /// Email/Password Register
  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthEmailRegisterInProgress());
    try {
      final result = await _authRepository.registerWithEmail(
        email: event.email,
        password: event.password,
        name: event.name,
      );
      result.fold(
        (failure) => emit(AuthError(
          message: failure.toString(),
          errorCode: 'REGISTER_ERROR',
        )),
        (user) {
          if (user.isSuccess && user.userJson != null) {
            emit(AuthRegisterSuccess(email: event.email , userId: user.userJson?.id , requiresEmailVerification: true));
          } else {
            emit(AuthError(
              message: user.errorMessage ?? 'Registration failed',
              errorCode: user.errorCode ?? 'REGISTER_FAILED',
            ));
          }
        },
      );
    } catch (e) {
      print('Registration error: $e');
      
      // ✅ Improved error handling with specific error codes
      String errorMessage = e.toString();
      String? errorCode;
      
      if (errorMessage.contains('email already exists') || 
          errorMessage.contains('EMAIL_ALREADY_EXISTS')) {
        errorCode = 'EMAIL_ALREADY_EXISTS';
        errorMessage = 'This email is already registered.';
      } else if (errorMessage.contains('weak password') || 
                 errorMessage.contains('WEAK_PASSWORD')) {
        errorCode = 'WEAK_PASSWORD';
        errorMessage = 'Password is too weak.';
      } else if (errorMessage.contains('invalid email') || 
                 errorMessage.contains('INVALID_EMAIL')) {
        errorCode = 'INVALID_EMAIL';
        errorMessage = 'Invalid email format.';
      } else if (errorMessage.contains('network') || 
                 errorMessage.contains('connection')) {
        errorCode = 'NETWORK_ERROR';
        errorMessage = 'Network error. Please check your connection.';
      }
      
      emit(AuthError(
        message: errorMessage,
        errorCode: errorCode,
      ));
    }
  }

  /// Facebook login
  Future<void> _onAuthFacebookLoginRequested(
    AuthFacebookLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthFacebookLoginInProgress());
    try {
      // 1. Authenticate với Facebook
      // final authResult = await _facebookAuthService.signInWithFacebook();

      // // 2. Lưu tokens và user data
      // final saveResult = await _authRepository.saveAuthResult(authResult);
      final saveResult = await _authRepository.loginWithFacebook();
      saveResult.fold(
        (failure) => emit(
          AuthError(
            message:
                'Failed to save authentication data: ${failure.toString()}',
            errorCode: 'SAVE_ERROR',
          ),
        ),
        (user) => emit(AuthAuthenticated(user: user, provider: 'facebook')),
      );
    } catch (e) {
      emit(
        AuthError(
          message: _getErrorMessage(e.toString()),
          errorCode: 'FACEBOOK_LOGIN_ERROR',
        ),
      );
    }
  }

  /// Google login
  Future<void> _onAuthGoogleLoginRequested(
    AuthGoogleLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthGoogleLoginInProgress());
    try {
      final result = await _authRepository.loginWithGoogle();
      result.fold(
        (failure) => emit(
          AuthError(
            message: failure.toString(),
            errorCode: 'GOOGLE_LOGIN_ERROR',
          ),
        ),
        (user) => emit(AuthAuthenticated(user: user, provider: 'google')),
      );
    } catch (e) {
      emit(
        AuthError(
          message: _getErrorMessage(e.toString()),
          errorCode: 'GOOGLE_LOGIN_ERROR',
        ),
      );
    }
  }

  /// Logout
  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      // Logout từ tất cả providers
      await Future.wait([
        _facebookAuthService.signOut(),
        _googleSignInService.signOut(),
        _authRepository.logout(),
      ]);

      emit(const AuthUnauthenticated());
    } catch (e) {
      // Vẫn emit unauthenticated ngay cả khi có lỗi
      emit(const AuthUnauthenticated());
    }
  }

  /// Helper method để format error messages
  String _getErrorMessage(String error) {
    if (error.contains('cancelled')) {
      return 'Login was cancelled';
    } else if (error.contains('network')) {
      return 'Network error. Please check your connection';
    } else if (error.contains('permission')) {
      return 'Permission denied. Please allow required permissions';
    } else {
      return 'Login failed. Please try again';
    }
  }
}
