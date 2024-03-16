import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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