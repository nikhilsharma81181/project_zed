import 'package:fpdart/fpdart.dart';
import 'package:project_zed/features/authentication/data/datasource/phone_auth_data_source.dart';
import 'package:project_zed/features/authentication/domain/repository/auth_repository.dart';
import 'package:project_zed/shared/error/exceptions.dart';
import 'package:project_zed/shared/error/failure.dart';

class PhoneAuthRepositoryImpl implements PhoneAuthRepository {
  final PhoneAuthDataSourceImpl phoneAuthDataSourceImpl;
  PhoneAuthRepositoryImpl(this.phoneAuthDataSourceImpl);

  @override
  Future<Either<Failure, bool>> sendOtp({required String phoneNumber}) async {
    try {
      final success = await phoneAuthDataSourceImpl.sendOtp(
        phoneNumber: phoneNumber,
      );
      return right(success);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> verifyOtp(
      {required String phoneNumber, required String otpNumber}) async {
    try {
      final token = await phoneAuthDataSourceImpl.verifyOtp(
          phoneNumber: phoneNumber, otpNumber: otpNumber);
      return right(token);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  
}


