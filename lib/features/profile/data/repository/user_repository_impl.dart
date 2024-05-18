import 'package:fpdart/fpdart.dart';
import 'package:project_zed/features/profile/data/datasource/user_datasource.dart';
import 'package:project_zed/features/profile/data/model/user_model.dart';
import 'package:project_zed/features/profile/domain/entities/user_entities.dart';
import 'package:project_zed/features/profile/domain/repository/user_repository.dart';
import 'package:project_zed/core/error/exceptions.dart';
import 'package:project_zed/core/error/failure.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource _userDataSource;

  UserRepositoryImpl({required UserDataSource userDataSource})
      : _userDataSource = userDataSource;

  @override
  Future<Either<Failure, UserEntity>> createUser(
      {required String userId,
      required String userName,
      required String email,
      required String profilePictureUrl}) async {
    try {
      final userModel = UserModel(
        userId: userId,
        userName: userName,
        email: email,
        profilePicture: profilePictureUrl,
      );
      await _userDataSource.createUser(userModel);
      return right(UserEntity(
        userId: userId,
        userName: userName,
        email: email,
        profilePicture: profilePictureUrl,
      ));
    } on ServerException catch (e) {
      throw left(Failure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, UserEntity>> getUser(String userId) async* {
    try {
      final model = await _userDataSource.getUser(userId);
      yield right(UserEntity(
        userId: model.userId,
        userName: model.userName,
        email: model.email,
        profilePicture: model.profilePicture,
      ));
    } on ServerException catch (e) {
      yield left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUser(UserEntity userData) async {
    try {
      final userModel = UserModel(
        userId: userData.userId,
        userName: userData.userName,
        email: userData.email,
        profilePicture: userData.profilePicture,
      );
      await _userDataSource.updateUser(userModel);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
