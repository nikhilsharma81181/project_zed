import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_zed/features/auth/model/auth_model.dart';
import 'package:project_zed/features/authentication/repository/auth_repository.dart';
import 'package:project_zed/shared/server_config/api_response_model.dart';
import 'package:project_zed/shared/server_config/dio_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthModel>((ref) {
  final notifier = AuthNotifier(
    const AuthModel(authState: AuthState.unauthenticated(), isLoading: false),
    AuthRepository(ref.read(dioProvider)),
  );
  ref.onDispose(() =>
      notifier.dispose()); // Run init method when the provider is disposed
  notifier.init(); // Run init method when the provider is initialized
  return notifier;
});

class AuthNotifier extends StateNotifier<AuthModel> {
  final AuthRepository _authRepository;
  AuthNotifier(super.state, this._authRepository);

  updatePhoneNumber(String phoneNumber) {
    state = state.copyWith(phoneNumber: phoneNumber);
  }

  init() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        state = state.copyWith(authState: const AuthState.authenticated());
        getSignInMethod();
      } else {
        state = state.copyWith(authState: const AuthState.unauthenticated());
      }
    });
  }

  Future<ApiResponse> sendOtp({required String phone}) async {
    state = state.copyWith(isLoading: true);
    final result = await _authRepository.sendOtp(phone);
    state = state.copyWith(isLoading: false);
    return result;
  }

  Future<ApiResponse> verifyOtp({required String otp}) async {
    state = state.copyWith(isLoading: true);
    final result = await _authRepository.verifyOtp(state.phoneNumber, otp);
    state = state.copyWith(isLoading: false);
    log("Result: ${result.item1}:::${result.item2}");
    if (result.item1.success) {
      saveAuthToken(result.item2!);
    }
    return result.item1;
  }

  saveAuthToken(String token) async {
    SaveLoginDetails.setToken(token);
  }

  Future<bool> signInWithGoogle() async {
    state = state.copyWith(isLoading: true);
    final result = await _authRepository.loginWithGoogle();
    if (result.item2 != null) {
      state = state.copyWith(authState: const AuthState.authenticated());
      state = state.copyWith(authMethod: AuthType.google);
      return true;
    } else {
      state = state.copyWith(authState: const AuthState.unauthenticated());
    }

    state = state.copyWith(isLoading: false);

    return false;
  }

  Future signOut() async {
    await _authRepository.signOut();
    saveAuthToken("");
    if (state.authMethod == AuthType.google) {
      GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
    }
    state = state.copyWith(authState: const AuthState.unauthenticated());
  }

  Future getSignInMethod() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final providerData = user!.providerData;
    for (final provider in providerData) {
      switch (provider.providerId) {
        case 'google.com':
          state = state.copyWith(authMethod: AuthType.google);
          log("Google");
        case 'phone':
          state = state.copyWith(authMethod: AuthType.phone);
          log("Phone");
        default:
          return null;
      }
    }
    return null;
  }
}

final loginAnimationProvider =
    StateNotifierProvider<LoginAnimationNotifier, LoginAnimationModel>((ref) {
  final notifier = LoginAnimationNotifier(
    LoginAnimationModel(
      otpPage: const [false, false, false, false, false, false],
      enableActiveFill: false,
      otpFocusNode: FocusNode(),
    ),
  );
  ref.onDispose(() => notifier.dispose());
  return notifier;
});

class LoginAnimationNotifier extends StateNotifier<LoginAnimationModel> {
  LoginAnimationNotifier(super.state);

  animateToOtpView() {
    state = state.copyWith(otpPage: [
      ...state.otpPage.sublist(0, 1),
      true,
      ...state.otpPage.sublist(1),
    ]);

    Future.delayed(const Duration(seconds: 1), () {
      state = state.copyWith(otpPage: [
        ...state.otpPage.sublist(0, 2),
        true,
        ...state.otpPage.sublist(2),
      ]);

      Timer.periodic(const Duration(milliseconds: 150), (timer) {
        if (mounted) {
          if (state.otpPage.every((element) => element)) {
            timer.cancel();
            Future.delayed(const Duration(seconds: 1), () {
              state = state.copyWith(enableActiveFill: true);
              state = state.copyWith(otpFocusNode: FocusNode());
            });
          } else {
            final index =
                state.otpPage.sublist(2).indexWhere((element) => !element);
            if (index != -1) {
              state = state.copyWith(
                otpPage: [
                  ...state.otpPage.sublist(0, index + 2),
                  true,
                  ...state.otpPage.sublist(index + 3),
                ],
              );
              log("otpPage: ${state.otpPage}");
            }
          }
        }
      });
    });
  }
}

class LoginAnimationModel {
  final List<bool> otpPage;
  final bool enableActiveFill;
  final FocusNode? otpFocusNode;

  const LoginAnimationModel({
    required this.otpPage,
    required this.enableActiveFill,
    this.otpFocusNode,
  });

  LoginAnimationModel copyWith({
    List<bool> otpPage = const [false, false, false, false, false, false],
    bool enableActiveFill = false,
    FocusNode? otpFocusNode,
    String phoneNumber = "",
  }) {
    return LoginAnimationModel(
      otpPage: otpPage,
      enableActiveFill: enableActiveFill,
      otpFocusNode: otpFocusNode,
    );
  }
}

class SaveLoginDetails {
  static SharedPreferences? _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setToken(String token) async {
    await _preferences!.setString('token', token);
  }

  static String? getToken() => _preferences!.getString('token');

  static Future setLoginWith(String loginWith) async {
    await _preferences!.setString('loginWith', loginWith);
  }

  static String? getLoginWith() => _preferences!.getString('loginWith');
}
