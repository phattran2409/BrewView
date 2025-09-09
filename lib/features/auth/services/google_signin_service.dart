import 'package:briewview/core/constants/app_constants.dart';
import 'package:briewview/features/auth/model/auth_result.dart';
import 'package:briewview/features/user_management/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

@singleton
class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Dio _dio;
  GoogleSignInService(this._dio);

  /// Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      print('Google authentication successful');
      print('Google Auth : ${googleAuth.accessToken}');
      print('Google Auth : ${googleAuth.idToken}');
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('credential : $credential');

      // Sign in to Firebase with the Google credential
      return await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      throw Exception('Google Sign-In failed: $e');
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
  }

  // sign in API BE

  /// Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  /// Check if user is signed in
  bool get isSignedIn => currentUser != null;

  Future<AuthResult?> getUserDataFromServer() async {
    try {
      final userInfo = getUserInfo();
      final response = await _dio.post(
        AppConstants.googleSignInEndpoint,
        data: {'uid': (await userInfo?['uid'] ?? '')},
      );
      print('Response: ${response.data}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data as Map<String, dynamic>;
        final isSuccess = responseData['isSuccess'] as bool;
        if (isSuccess == true && responseData['data'] != null) {
          try {
            final userData = responseData['data'] as Map<String, dynamic>;
            final userModel = UserModel.fromJson(userData);
             print('Parsed UserModel: $userModel');

            return AuthResult(isSuccess: true, userJson: userModel);
          } catch (e) {
            print('Error parsing user data: $e');
            return AuthResult(isSuccess: false, userJson: null);
          }
        }
        return AuthResult(isSuccess: false, userJson: null);
      }
    } catch (e) {
      print('Error fetching token from server: $e');
      return null;
    }
  }

  /// Get user info for profile
  Map<String, dynamic>? getUserInfo() {
    final user = currentUser;
    if (user == null) return null;

    return {
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoURL': user.photoURL,
      'emailVerified': user.emailVerified,
    };
  }

  /// Listen to auth state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}
