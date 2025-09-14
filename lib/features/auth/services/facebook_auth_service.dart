import 'package:briewview/features/user_management/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart'; 
@singleton
// class FacebookAuthService {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance; 
  
//   Future<AuthResult> signInWithFacebook() async {
//     try {
//       final LoginResult result = await FacebookAuth.instance.login(
//         permissions: ['email', 'public_profile'],
//       );
//       if (result.status == LoginStatus.success) {
//         final AccessToken accessToken = result.accessToken!;

//         final userData = await FacebookAuth.instance.getUserData(
//            fields: "email,name,picture.width(200)",
//         );
//         // Create Firebase credential
//         final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(accessToken.token);
//         // sign in with firebase
//         final UserCredential userCredential = await _firebaseAuth.signInWithCredential(facebookAuthCredential);
//         // get id token  from firebase 
//         final String? idToken = await userCredential.user?.getIdToken();
         
//         if (idToken != null) {
//           throw Exception('Failed to get Firebase ID token');
//         }

//         final user = UserModel(
//           id: userCredential.user?.uid ?? '',
//           email: userData['email'] ?? '',
//           name: userData['name'] ?? '',
//           avatarUrl : userData['picture']?['data']?['url'],

//         );

//         return AuthResult(
//           accessToken: idToken ?? '',
//           refreshToken: accessToken.token,
//           userJson: user,
//         );
//       } else if (result.status == LoginStatus.cancelled) {
//         throw Exception('Facebook login cancelled');
//       } else {
//         throw Exception('Error signing in with Facebook: ${result.message}');
//       }
//     } catch (e) {
//       throw Exception('Error signing in with Facebook: $e');
//     }
//   }
// }
class FacebookAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Dio _dio;
  FacebookAuthService(this._dio);
  
  Future<({UserCredential credential, String fbAccessToken, UserModel fbProfile})> signIn() async {
    final result = await FacebookAuth.instance.login(permissions: ['email', 'public_profile']);
    if (result.status == LoginStatus.cancelled) {
      throw Exception('Facebook login cancelled');
    }
    if (result.status != LoginStatus.success || result.accessToken == null) {
      throw Exception('Facebook login failed: ${result.message}');
    }

    final fbAccessToken = result.accessToken!.token;
    final userProfiles = await FacebookAuth.instance.getUserData(fields: "email,name,picture.width(200)");
    final fbProfile = UserModel(
      id: userProfiles['id'] ?? '',
      name: userProfiles['name'] ?? '',
      email: userProfiles['email'] ?? '',
      profilePicture: userProfiles['picture']?['data']?['url'] ?? '',
    );
    final credential = FacebookAuthProvider.credential(fbAccessToken);
    final userCred = await _firebaseAuth.signInWithCredential(credential);

    return (credential: userCred, fbAccessToken: fbAccessToken, fbProfile: fbProfile);
  }

  Future<void> signOut() async {
    // Chỉ đăng xuất Facebook SDK
    await FacebookAuth.instance.logOut();
  }
}