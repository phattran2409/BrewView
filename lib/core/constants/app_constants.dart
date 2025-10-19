
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
  static const String userPreferencesEndpoint =
      '/api/user-preferences/{userId}';

  static String updateProfilePicture(String userId) {
    return updatePictureProfileEndpoint.replaceAll('{id}', userId);
  }

  static String getCurrentUserEndpoint(String userId) {
    return currentUserEndpoint.replaceAll('{id}', userId);
  }

  static String getUpdateUserProfile(String userId) {
    return currentUserEndpoint.replaceAll('{id}', userId);
  }

  // Cafe
  static const String cafeListEndpoint = '/api/cafes';
  static const String cafeByDistanceEndpoint = '/api/cafes/by-distance';
  static const String cafePreferenceEndpoint =
      '/api/cafes/by-user-preferences/{userId}';
 static const String cafeByOwnerEndpoint = '/api/cafes/get-cafe/{ownerId}';
  static String getCafeList({
    int pageSize = 1,
    int pageNumber = 10,
    String sortBy = '',
    String sortDirection = '',
    String searchTerm = '',
  }) {
    final uri = Uri.parse(cafeListEndpoint).replace(
      queryParameters: {
        'pageSize': pageSize.toString(),
        'pageNumber': pageNumber.toString(),
        'sortBy': sortBy,
        'sortDirection': sortDirection,
        'searchTerm': searchTerm,
      },
    );
    return uri.toString();
  }
    static String getCafeByOwner({
    String ownerId = '',
    int pageSize = 20,
    int pageNumber = 1,
    String sortBy = '',
  }) {
    final uri = Uri.parse(cafeByOwnerEndpoint.replaceAll('{ownerId}', ownerId)).replace(
      queryParameters: {
        'pageSize': pageSize.toString(),
        'pageNumber': pageNumber.toString(),
      },
    );
    return uri.toString();
  }

  static String getCafeByUserPreferences({
    String userId = '',
    int pageSize = 1,
    int pageNumber = 10,
  }) {
    final uri = Uri.parse(
      cafePreferenceEndpoint.replaceAll('{userId}', userId),
    ).replace(
      queryParameters: {
        'pageSize': pageSize.toString(),
        'pageNumber': pageNumber.toString(),
      },
    );
    return uri.toString();
  } 
  static String getCafeByDistance({
    double latitude = 0.0,
    double longitude = 0.0,
    int maxDistanceKm = 10,
    int pageSize = 10,
    int pageNumber = 1,
  }) {
    final uri = Uri.parse(cafeByDistanceEndpoint).replace(
      queryParameters: {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'maxDistanceKm': maxDistanceKm.toString(),
        'pageSize': pageSize.toString(),
        'pageNumber': pageNumber.toString(),
      },
    );
    return uri.toString();
  } 

  // Review
  static const String reviewEndpoint = '/api/reviews/{cafeId}';
  static const String reviewCreateEndpoint = '/api/reviews/{cafeId}';
  static String getReviewEndpoint({
    String cafeId = '',
    int pageNumber = 1,
    int pageSize = 10,
  }) {
    final uri = Uri.parse(
      reviewEndpoint.replaceAll('{cafeId}', cafeId),
    ).replace(
      queryParameters: {
        'pageNumber': pageNumber.toString(),
        'pageSize': pageSize.toString(),
      },
    );
    return uri.toString();
  }

  static String getUserPreferencesEndpoint(String userId) {
    return userPreferencesEndpoint.replaceAll('{userId}', userId);
  }

  // Premium endpoints
  static const String premiumPlansEndpoint = '/api/premium/plans';
  static const String currentSubscriptionEndpoint =
      '/api/premium/subscription/current';
  static const String createSubscriptionEndpoint =
      '/api/premium/subscription/create';
  static const String cancelSubscriptionEndpoint =
      '/api/premium/subscription/cancel';
  static const String subscriptionHistoryEndpoint =
      '/api/premium/subscription/history';

  // Payment endpoints
  static const String createPaymentLink =
      '/api/subscriptions/create-payment-link/{userId}';
  static const String paymentStatusEndpoint = '/api/payment/status/{orderCode}';
  static const String verifyPaymentEndpoint = '/api/payment/verify';
  static const String cancelPaymentEndpoint = '/api/payment/cancel';
  
  static String getCreatePaymentLink(String userId) { 
    return createPaymentLink.replaceAll('{userId}', userId);
  }
  
  static String getPaymentStatus(int orderCode) {
    return paymentStatusEndpoint.replaceAll('{orderCode}', orderCode.toString());
  }
  
  static String get verifyPayment => verifyPaymentEndpoint;
  static String get cancelPayment => cancelPaymentEndpoint; 
}
