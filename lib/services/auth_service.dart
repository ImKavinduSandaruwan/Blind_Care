import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService{

  signWithGoogleAccount() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    ///Getting authentication details
    final GoogleSignInAuthentication googleAuthentication = await googleUser!.authentication;

    ///Creating user credential for a new user
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuthentication.accessToken,
      idToken: googleAuthentication.idToken
    );
    /// Sign in with google credentials and add it to the firebase
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}