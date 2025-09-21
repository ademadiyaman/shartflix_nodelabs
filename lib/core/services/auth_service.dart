import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Google hesabını seç
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      // Auth token al
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Credential oluştur
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase’e giriş yap
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print("Google login error: $e");
      return null;
    }
  }
}
