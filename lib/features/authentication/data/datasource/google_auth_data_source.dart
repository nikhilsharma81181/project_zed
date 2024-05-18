import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_zed/core/error/exceptions.dart';

abstract class GoogleAuthDataSource {
  Future<UserCredential?> googleSSO();
}

class GoogleAuthDataSourceImpl implements GoogleAuthDataSource {
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _firebaseAuth;

  GoogleAuthDataSourceImpl(this._googleSignIn, this._firebaseAuth);

  @override
  Future<UserCredential?> googleSSO() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        return userCredential;
      } else {
        throw ServerException("Something went wrong!");
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
