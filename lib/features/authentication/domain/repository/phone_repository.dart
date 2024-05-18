import 'package:fpdart/fpdart.dart';
import 'package:project_zed/core/error/failure.dart';


abstract interface class PhoneAuthRepository {
  Future<Either<Failure, String>> sendOtp({
    required String phoneNumber,
  });

  Future<Either<Failure, String>> verifyOtp({
    required String verificationId,
    required String otpNumber,
  });
}

