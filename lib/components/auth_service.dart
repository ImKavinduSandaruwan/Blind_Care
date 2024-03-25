import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class AuthService{
  get auth => null;
  get fullName => null;

  /// Asynchronously signs in the user using Google Sign-In and Firebase Authentication.
  /// This function initiates the Google Sign-In process and retrieves the user's authentication details.
  /// It then creates a credential using the access token and ID token obtained from Google Sign-In.
  /// Finally, it signs in the user to Firebase using the created credential.
  signInWithGoogle() async{
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    // create a new credential for user
    final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken
    );
    //finally, lets sign in
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  /// Asynchronously signs in the user using Apple Sign-In and Firebase Authentication.
  /// This function performs the Apple Sign-In request with the specified scopes.
  /// Upon successful authorization, it creates an OAuth credential using the Apple ID credential's identity token.
  /// The credential is then used to sign in the user to Firebase.
  /// If the full name scope is requested and authorized, the user's display name in Firebase is updated accordingly.
  Future<User>signInWithApple({List<Scope> scopes= const[]})async{
    final result= await TheAppleSignIn.performRequests([AppleIdRequest(requestedScopes: scopes)]);
    switch (result.status){
      case AuthorizationStatus.authorized:
        final appleIdCredential= result.credential!;
        final oAuthProvider= OAuthProvider('apple,com');
        final credential= oAuthProvider.credential(idToken: String.fromCharCodes(appleIdCredential.identityToken!));
        final userCredential= await auth.signInWithCredential(credential);
        final firebaseUser= userCredential.user!;
        if(scopes.contains(Scope.fullName)){
          final fulName= appleIdCredential.fullName;
          if(fullName!=null && fullName.givenName!=null && fullName.familyName!=null){
            final displayName ='${fullName.givenName} ${fullName.familyName}';
            await firebaseUser.updateDisplayName(displayName);

          }
        }
        return firebaseUser;
      case AuthorizationStatus.error:
        throw PlatformException(code: 'ERROR_AUTHORIZATION_DENIED', message: result.error.toString());
      case AuthorizationStatus.cancelled:
        throw PlatformException(
            code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
      default:
        throw UnimplementedError();
    }
  }
}