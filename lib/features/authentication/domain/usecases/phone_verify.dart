import 'package:fpdart/fpdart.dart';
import 'package:project_zed/features/authentication/domain/repository/phone_repository.dart';
import 'package:project_zed/core/error/failure.dart';
import 'package:project_zed/core/usecase/usecase.dart';

class PhoneVerify implements UseCase<String, VerifyOtpParams> {
  final PhoneAuthRepository phoneAuthRepository;
  PhoneVerify(this.phoneAuthRepository);

  @override
  Future<Either<Failure, String>> call(VerifyOtpParams params) async {
    return await phoneAuthRepository.verifyOtp(
      verificationId: params.verificationId,
      otpNumber: params.otpNumber,
    );
  }
}

class VerifyOtpParams {
  final String verificationId;
  final String otpNumber;

  VerifyOtpParams({required this.verificationId, required this.otpNumber});
}