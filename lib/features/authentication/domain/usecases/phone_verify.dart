import 'package:fpdart/fpdart.dart';
import 'package:project_zed/features/authentication/domain/repository/auth_repository.dart';
import 'package:project_zed/shared/error/failure.dart';
import 'package:project_zed/shared/usecase/usecase.dart';

class PhoneVerify implements UseCase<String, VerifyOtpParams> {
  final PhoneAuthRepository phoneAuthRepository;
  PhoneVerify(this.phoneAuthRepository);

  @override
  Future<Either<Failure, String>> call(VerifyOtpParams params) async {
    return await phoneAuthRepository.verifyOtp(
      phoneNumber: params.phoneNumber,
      otpNumber: params.otpNumber,
    );
  }
}

class VerifyOtpParams {
  final String phoneNumber;
  final String otpNumber;

  VerifyOtpParams({required this.phoneNumber, required this.otpNumber});
}