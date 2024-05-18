import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:project_zed/core/error/failure.dart';
import 'package:project_zed/core/usecase/usecase.dart';
import 'package:project_zed/features/authentication/domain/repository/google_repository.dart';

class GoogleSSO implements UseCase<UserCredential?, String> {
  final GoogleAuthRepository googleAuthRepository;
  GoogleSSO(this.googleAuthRepository);

  @override
  Future<Either<Failure, UserCredential?>> call(String params) async {
    return await googleAuthRepository.googleSignIn();
  }
}
