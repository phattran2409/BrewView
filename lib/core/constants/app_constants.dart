class AppConstants {
  static const String appName = 'BrewView';
  static const String apiBaseUrl = 'https://jsonplaceholder.typicode.com';
  static const int timeoutDuration = 30000; // milliseconds
  
  // API Endpoints
  static const String loginEndpoint = '/api/auth/login';
  static const String registerEndpoint = '/api/auth/register';
  static const String refreshEndpoint = '/api/auth/refresh';
  static const String userProfileEndpoint = '/api/user/profile';
  static const String currentUserEndpoint = '/api/auth/me';
}
