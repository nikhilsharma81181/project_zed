import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:project_zed/core/error/failure.dart';

abstract interface class GoogleAuthRepository {
  Future<Either<Failure, UserCredential?>> googleSignIn();
}
