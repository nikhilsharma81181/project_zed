import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:project_zed/features/authentication/data/datasource/google_auth_data_source.dart';
import 'package:project_zed/features/authentication/domain/repository/google_repository.dart';
import 'package:project_zed/core/error/exceptions.dart';
import 'package:project_zed/core/error/failure.dart';

class GoogleAuthRepositoryImpl implements GoogleAuthRepository {
  final GoogleAuthDataSource _googleAuthDataSource;

  GoogleAuthRepositoryImpl(this._googleAuthDataSource);

  @override
  Future<Either<Failure, UserCredential?>> googleSignIn() async {
    try {
      final userCredential = await _googleAuthDataSource.googleSSO();
      return right(userCredential);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}