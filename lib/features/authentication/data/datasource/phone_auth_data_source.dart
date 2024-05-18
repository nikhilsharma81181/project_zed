import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_zed/core/error/exceptions.dart';

abstract class PhoneAuthDataSource {
  Future<String> sendOtp({
    required String phoneNumber,
  });

  Future<String> verifyOtp({
    required String verificationId,
    required String otpNumber,
  });
}

class PhoneAuthDataSourceImpl implements PhoneAuthDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<String> sendOtp({required String phoneNumber}) async {
    try {
      String verificationId = "";
      await _auth.verifyPhoneNumber(
        phoneNumber: "+91$phoneNumber",
        timeout: const Duration(seconds: 60),
        verificationCompleted: (credential) async {
          // Auto-verification completed (handle if needed)
        },
        verificationFailed: (error) {
          throw ServerException(error.message.toString());
        },
        codeSent: (verificationID, [forceResendingToken]) async {
          verificationId = verificationID;
        },
        codeAutoRetrievalTimeout: (verificationId) {
          throw ServerException(verificationId.toString());
        },
      );
      return verificationId;
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message.toString());
    }
  }

  @override
  Future<String> verifyOtp(
      {required String verificationId, required String otpNumber}) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpNumber,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user?.uid ?? "";
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message.toString());
    }
  }
}
