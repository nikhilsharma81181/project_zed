// user_usecase.dart

import 'package:fpdart/fpdart.dart';
import 'package:project_zed/core/error/failure.dart';
import 'package:project_zed/features/profile/domain/entities/user_entities.dart';
import 'package:project_zed/features/profile/domain/repository/user_repository.dart';

class CreateUserUseCase {
  final UserRepository userRepository;

  CreateUserUseCase(this.userRepository);

  Future<Either<Failure, UserEntity>> call({
    required String userId,
    required String userName,
    required String email,
    required String profilePictureUrl,
  }) async {
    final result = await userRepository.createUser(
      userId: userId,
      userName: userName,
      email: email,
      profilePictureUrl: profilePictureUrl,
    );
    return result;
  }
}

class GetUserUseCase {
  final UserRepository userRepository;

  GetUserUseCase(this.userRepository);

  Stream<Either<Failure, UserEntity>> call(String userId) {
    return userRepository.getUser(userId);
  }
}

class UpdateUserUseCase {
  final UserRepository userRepository;

  UpdateUserUseCase(this.userRepository);

  Future<Either<Failure, void>> call(UserEntity userData) async {
    return await userRepository.updateUser(userData);
  }
}
