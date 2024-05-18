// user_repository.dart

import 'package:fpdart/fpdart.dart';
import 'package:project_zed/core/error/failure.dart';
import 'package:project_zed/features/profile/domain/entities/user_entities.dart';

abstract interface class UserRepository {
  Future<Either<Failure, UserEntity>> createUser({
    required String userId,
    required String userName,
    required String email,
    required String profilePictureUrl,
  });

  Stream<Either<Failure, UserEntity>> getUser(String userId);

  Future<Either<Failure, void>> updateUser(UserEntity userData);
}
