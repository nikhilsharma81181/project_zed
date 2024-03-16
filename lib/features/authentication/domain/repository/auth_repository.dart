import 'package:fpdart/fpdart.dart';
import 'package:project_zed/shared/error/failure.dart';


abstract interface class PhoneAuthRepository {
  Future<Either<Failure, bool>> sendOtp({
    required String phoneNumber,
  });

  Future<Either<Failure, String>> verifyOtp({
    required String phoneNumber,
    required String otpNumber,
  });
}

