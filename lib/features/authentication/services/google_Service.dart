import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleService {
  static Future<void> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn.instance;

    // Initialize GoogleSignIn (ideally during app startup)
    await googleSignIn.initialize();

    try {
      // Perform interactive authentication
      final GoogleSignInAccount account = await googleSignIn.authenticate(
        scopeHint: ['email', 'profile'], // optional
      );

      final googleAuth = account.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        // accessToken is no longer available in the new GoogleSignInAuthentication
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print("Google Sign-In error: $e");
      rethrow;
    }
  }
}
