// import 'dart:developer' as developer;

// import 'package:google_sign_in/google_sign_in.dart';

// /// Google Sign-In Service for Firebase authentication
// class GoogleSignInService {
//   // Lazy singleton instance
//   static late GoogleSignIn _instance;

//   /// Initialize GoogleSignIn instance
//   static void _initializeGoogleSignIn() {
//     // For the latest google_sign_in package, we use the package's default instance
//     // which is accessed through GoogleSignIn() constructor calls
//     developer.log('Initializing GoogleSignIn', name: 'GoogleSignInService');
//   }

//   /// 🔐 Google Sign-In and get ID Token
//   /// Returns: idToken from Google for backend verification
//   static Future<String?> getGoogleIdToken() async {
//     try {
//       developer.log('Starting Google Sign-In', name: 'GoogleSignInService');

//       // Create a new instance for this sign-in attempt
//       // This is the pattern used in the latest google_sign_in versions
//       final GoogleSignInAuthentication? googleAuth;
//       final GoogleSignInAccount? account;

//       // Attempt sign-in using the google_sign_in platform channels
//       try {
//         // For mobile/web: use the platform-specific implementation
//         account = await GoogleSignIn().signIn();
//       } catch (e) {
//         developer.log(
//           'GoogleSignIn.signIn() error: $e',
//           name: 'GoogleSignInService',
//           error: e,
//         );
//         rethrow;
//       }

//       developer.log(
//         'Google Sign-In successful: ${account.email}',
//         name: 'GoogleSignInService',
//       );

//       // Get authentication token
//       try {
//         googleAuth = account.authentication;
//       } catch (e) {
//         developer.log(
//           'Failed to get authentication: $e',
//           name: 'GoogleSignInService',
//           error: e,
//         );
//         rethrow;
//       }

//       final idToken = googleAuth.idToken;

//       if (idToken == null || idToken.isEmpty) {
//         developer.log('ID Token is null or empty', name: 'GoogleSignInService');
//         return null;
//       }

//       developer.log(
//         'ID Token obtained successfully',
//         name: 'GoogleSignInService',
//       );
//       return idToken;
//     } catch (e) {
//       developer.log(
//         'Error during Google Sign-In: $e',
//         name: 'GoogleSignInService',
//         error: e,
//       );
//       rethrow;
//     }
//   }

//   /// 🚪 Sign out from Google
//   static Future<void> signOut() async {
//     try {
//       await GoogleSignIn().signOut();
//       developer.log('Signed out from Google', name: 'GoogleSignInService');
//     } catch (e) {
//       developer.log(
//         'Error signing out: $e',
//         name: 'GoogleSignInService',
//         error: e,
//       );
//     }
//   }

//   /// ❌ Disconnect/Revoke Google account access
//   static Future<void> disconnect() async {
//     try {
//       await GoogleSignIn().disconnect();
//       developer.log('Disconnected Google account', name: 'GoogleSignInService');
//     } catch (e) {
//       developer.log(
//         'Error disconnecting: $e',
//         name: 'GoogleSignInService',
//         error: e,
//       );
//     }
//   }
// }
