import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

@singleton
class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      return await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      throw Exception('Google Sign-In failed: $e');
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  /// Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  /// Check if user is signed in
  bool get isSignedIn => currentUser != null;

  /// Get current user ID token for API authorization
  Future<String?> getIdToken({bool forceRefresh = false}) async {
    final user = currentUser;
    if (user == null) return null;  
    
    try {
      return await user.getIdToken(forceRefresh);
    } catch (e) {
      throw Exception('Failed to get ID token: $e');
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
