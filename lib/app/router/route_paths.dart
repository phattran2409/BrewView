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
  static const String coffeeList = '/cafes';
  static const String coffeeDetail = '/cafe/:id';
  static String coffeeDetailPath(String id) => '/cafe/$id';
  // reviews
  static const String cafeReviews = '/cafe/:id/reviews';
  static String cafeReviewsPath(String id) => '/cafe/$id/reviews';
  // Auth
  static String otp = '/otp/:id';
  static const String resetPassword = '/reset-password';
}
