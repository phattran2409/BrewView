class RoutePaths {
  static const String splash = '/'; 
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String home = '/home';
  static const String map = '/map';
  static const String search = '/search';
  static const String profile = '/profile';
  static const String userList = '/users';
  static const String userDetail = '/users/:id';
  // coffee
  static const String coffeeList = '/coffee';
  static const String coffeeDetail = '/coffee/:id';
  static String coffeeDetailPath(String id) => '/coffee/$id';
  // Auth
  static String otp = '/otp/:id';
}
