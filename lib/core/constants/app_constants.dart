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
  static const String currentUserEndpoint = '/api/users/{id}';
  static const String googleSignInEndpoint = '/api/auth/firebase/login';
  static const String verifyOtpEndpoint = '/api/auth/verify-user-with-otp/';
  static const String forgotPasswordEndpoint = '/api/auth/forgot-password';
  static const String changePasswordEndpoint = '/api/auth/change-password';
  static const String resetPasswordEndpoint = '/api/auth/reset-password';
  static const String refreshTokenEndpoint =
      '/api/auth/login-with-refresh-token';
  // Profile
  static const String updatePictureProfileEndpoint = '/api/user/avatar/{id}';
  // Survey
  static const String categoriesEndpoint = '/api/categories';
  static const String featureTagsEndpoint = '/api/feature-tags';
  static const String userPreferencesEndpoint = '/api/user-preferences/{userId}';




  static String updateProfilePicture(String userId) {
    return updatePictureProfileEndpoint.replaceAll('{id}', userId);
  }
  static String getCurrentUserEndpoint(String userId) {
    return currentUserEndpoint.replaceAll('{id}', userId);
  }
  static String getUpdateUserProfile(String userId) {
    return currentUserEndpoint.replaceAll('{id}', userId);
  }


  static String getUserPreferencesEndpoint(String userId) {
    return userPreferencesEndpoint.replaceAll('{userId}', userId);
  }
}
