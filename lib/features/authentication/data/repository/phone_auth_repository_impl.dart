import 'package:fpdart/fpdart.dart';
import 'package:project_zed/features/authentication/data/datasource/phone_auth_data_source.dart';
import 'package:project_zed/features/authentication/domain/repository/phone_repository.dart';
import 'package:project_zed/core/error/exceptions.dart';
import 'package:project_zed/core/error/failure.dart';

class PhoneAuthRepositoryImpl implements PhoneAuthRepository {
  final PhoneAuthDataSource _phoneAuthDataSource;

  PhoneAuthRepositoryImpl(this._phoneAuthDataSource);

  @override
  Future<Either<Failure, String>> sendOtp({required String phoneNumber}) async {
    try {
      final success =
          await _phoneAuthDataSource.sendOtp(phoneNumber: phoneNumber);
      return right(success);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> verifyOtp(
      {required String verificationId, required String otpNumber}) async {
    try {
      final token = await _phoneAuthDataSource.verifyOtp(
          verificationId: verificationId, otpNumber: otpNumber);
      return right(token);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
