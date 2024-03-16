import 'dart:developer';

import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_zed/features/auth/model/auth_model.dart';
import 'package:project_zed/features/auth/provider/auth_provider.dart';
import 'package:project_zed/features/authentication/data/datasource/phone_auth_data_source.dart';
import 'package:project_zed/features/authentication/data/repository/phone_auth_repository_impl.dart';
import 'package:project_zed/features/authentication/domain/usecases/phone_login.dart';
import 'package:project_zed/features/authentication/domain/usecases/phone_verify.dart';
import 'package:project_zed/shared/error/failure.dart';
import 'package:project_zed/shared/server_config/dio_provider.dart';

final _phoneAuthRepositoryProvider =
    Provider.autoDispose<PhoneAuthRepositoryImpl>(
  (ref) => PhoneAuthRepositoryImpl(
    PhoneAuthDataSourceImpl(
      ref.read(dioProvider),
    ),
  ),
);

final phoneLoginProvider = Provider.autoDispose<PhoneLogin>(
  (ref) => PhoneLogin(ref.read(_phoneAuthRepositoryProvider)),
);

final phoneVerifyProvider = Provider.autoDispose<PhoneVerify>(
  (ref) => PhoneVerify(ref.read(_phoneAuthRepositoryProvider)),
);

final authNotifierProvider =
    StateNotifierProvider<PhoneAuthNotifier, AuthModel>(
  (ref) => PhoneAuthNotifier(
    ref.read(phoneLoginProvider),
    ref.read(phoneVerifyProvider),
  ),
);

class PhoneAuthNotifier extends StateNotifier<AuthModel> {
  final PhoneLogin _phoneLogin;
  final PhoneVerify _phoneVerify;

  PhoneAuthNotifier(this._phoneLogin, this._phoneVerify)
      : super(const AuthModel(
            authState: AuthState.unauthenticated(), isLoading: false));

  Future<Either<Failure, bool>> sendOtp({required String phoneNumber}) async {
    state = state.copyWith(isLoading: true);
    final result = await _phoneLogin(phoneNumber);
    state = state.copyWith(isLoading: false);
    return result;
  }

  Future<Either<Failure, bool>> verifyOtp({required String otp}) async {
    state = state.copyWith(isLoading: true);
    final phoneNumber = state.phoneNumber;
    if (phoneNumber == null) {
      state = state.copyWith(isLoading: false);
      return left(Failure('Phone number is required'));
    }
    final result = await _phoneVerify(
      VerifyOtpParams(phoneNumber: phoneNumber, otpNumber: otp),
    );
    state = state.copyWith(isLoading: false);
    return result.fold(
      (failure) {
        return left(failure);
      },
      (success) {
        log("Tokkkkkkkkeeeeen: $success");
        _saveAuthToken(success);
        return right(true);
      },
    );
  }

  updatePhoneNumber(String phoneNumber) {
    state = state.copyWith(phoneNumber: phoneNumber);
  }

  _saveAuthToken(String token) async {
    SaveLoginDetails.setToken(token);
  }
}


// final authRepositoryProvider = Provider.autoDispose<PhoneAuthRepository>(
//   (ref) =>
//       PhoneAuthRepositoryImpl(PhoneAuthDataSourceImpl(ref.read(dioProvider))),
// );

// final authNotifierProvider =
//     StateNotifierProvider<PhoneAuthNotifier, AuthModel>(
//   (ref) => PhoneAuthNotifier(ref.read(authRepositoryProvider)),
// );

// class PhoneAuthNotifier extends StateNotifier<AuthModel> {
//   final PhoneAuthRepository _phoneAuthRepository;

//   PhoneAuthNotifier(this._phoneAuthRepository)
//       : super(const AuthModel(
//             authState: AuthState.unauthenticated(), isLoading: false));

//   Future<Either<Failure, bool>> sendOtp({required String phoneNumber}) async {
//     state = state.copyWith(isLoading: true);

//     final result = await _phoneAuthRepository.sendOtp(phoneNumber: phoneNumber);
//     state = state.copyWith(isLoading: false);
//     return result;
//   }

//   updatePhoneNumber(String phoneNumber) {
//     state = state.copyWith(phoneNumber: phoneNumber);
//   }
// }
