import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_zed/features/authentication/data/datasource/phone_auth_data_source.dart';
import 'package:project_zed/features/authentication/data/model/auth_model.dart';
import 'package:project_zed/features/authentication/data/repository/phone_auth_repository_impl.dart';
import 'package:project_zed/features/authentication/domain/usecases/phone_login.dart';
import 'package:project_zed/features/authentication/domain/usecases/phone_verify.dart';
import 'package:project_zed/core/error/failure.dart';
import 'package:project_zed/core/server_config/dio_provider.dart';

final _phoneAuthRepositoryProvider =
    Provider.autoDispose<PhoneAuthRepositoryImpl>(
  (ref) => PhoneAuthRepositoryImpl(
    PhoneAuthDataSourceImpl(),
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

  String _verificationId = "";

  Future<Either<Failure, String>> sendOtp({required String phoneNumber}) async {
    state = state.copyWith(isLoading: true);
    final result = await _phoneLogin(phoneNumber);
    state = state.copyWith(isLoading: false);
    if (result.isRight()) {
      _verificationId = result.getOrElse((l) => "null");
    }
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
      VerifyOtpParams(verificationId: _verificationId, otpNumber: otp),
    );
    state = state.copyWith(isLoading: false);
    return result.fold(
      (failure) {
        return left(failure);
      },
      (user) {
        log("User: $user");
        return right(true);
      },
    );
  }

  updatePhoneNumber(String phoneNumber) {
    state = state.copyWith(phoneNumber: phoneNumber);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }
}
