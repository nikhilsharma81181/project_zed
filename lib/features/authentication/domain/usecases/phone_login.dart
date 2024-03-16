import 'package:fpdart/fpdart.dart';
import 'package:project_zed/features/authentication/domain/repository/auth_repository.dart';
import 'package:project_zed/shared/error/failure.dart';
import 'package:project_zed/shared/usecase/usecase.dart';

// Usecases

class PhoneLogin implements UseCase<bool, String> {
  final PhoneAuthRepository phoneAuthRepository;
  PhoneLogin(this.phoneAuthRepository);

  @override
  Future<Either<Failure, bool>> call(String params) async {
    return await phoneAuthRepository.sendOtp(phoneNumber: params);
  }
}
