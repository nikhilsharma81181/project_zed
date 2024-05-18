import 'package:fpdart/fpdart.dart';
import 'package:project_zed/features/authentication/domain/repository/phone_repository.dart';
import 'package:project_zed/core/error/failure.dart';
import 'package:project_zed/core/usecase/usecase.dart';

// Usecases

class PhoneLogin implements UseCase<String, String> {
  final PhoneAuthRepository phoneAuthRepository;
  PhoneLogin(this.phoneAuthRepository);

  @override
  Future<Either<Failure, String>> call(String params) async {
    return await phoneAuthRepository.sendOtp(phoneNumber: params);
  }
}
