class RoutePaths {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
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
  // Survey
  static const String survey = '/survey';

  // Posts
  static const String postList = '/posts';
  static const String postDetail = '/posts/:id';
  static String postDetailPath(String id) => '/posts/$id';

  // Premium and Payment routes
  static const String premiumPlans = '/premium-plans';
  static const String premiumDemo = '/premium-demo';
  static const String paymentSuccess = '/payment/success'; 
  static const String paymentFailure = '/payment/failure';  
  static const String payment = '/payment';
  static String paymentWithPlan(String planId) => '/payment/$planId';

  // My Cafe
  static const String myCafes = '/my-cafes';
  static const String myCafeDetail = '/my-cafes/:id';
  static const String myCafeCreate = '/my-cafes/create';
  static const String myCafeEdit = '/my-cafes/:id/edit';
  static String myCafeDetailPath(String id) => '/my-cafes/$id';
  static String myCafeEditPath(String id) => '/my-cafes/$id/edit';
}
