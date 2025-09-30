class RoutePaths {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String home = '/home';
  static const String map = '/map';
  static const String search = '/search';
  // Profile
  static const String profile = '/profile';
  static const String profileEdit = '/profile/edit';
  static const String userList = '/users';
  static const String userDetail = '/users/:id';
  // coffee
  static const String coffeeList = '/coffee';
  static const String coffeeDetail = '/coffee/:id';
  static String coffeeDetailPath(String id) => '/coffee/$id';
  // Auth
  static String otp = '/otp/:id';
  static const String resetPassword = '/reset-password';
  // Survey
  static const String survey = '/survey';

  // Posts
  static const String postList = '/posts';
  static const String postDetail = '/posts/:id';
  static String postDetailPath(String id) => '/posts/$id';
}
