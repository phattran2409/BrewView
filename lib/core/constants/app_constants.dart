class AppConstants {
  static const String appName = 'BrewView';
  static const String apiBaseUrl = 'https://10.0.2.2:7117';
  static const int timeoutDuration = 30000; // milliseconds
  
  // API Endpoints
  // Authentication
  static const String loginEndpoint = '/api/auth/email/login';
  static const String registerEndpoint = '/api/auth/email/register';
  static const String refreshEndpoint = '/api/auth/email/refresh';
  static const String userProfileEndpoint = '/api/user/profile';
  static const String currentUserEndpoint = '/api/auth/me';
  static const String googleSignInEndpoint = '/api/auth/firebase/login'; 
  static const String verifyOtpEndpoint = '/api/auth/verify-user-with-otp/';
}
