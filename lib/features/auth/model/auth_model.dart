import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_model.freezed.dart';

enum AuthType { google, phone, email }

@freezed
abstract class AuthModel with _$AuthModel {
  const factory AuthModel({
    required AuthState authState,
    required bool isLoading,
    AuthType? authMethod,
    String? phoneNumber,
  }) = _AuthModel;
}

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState.authenticated() = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
}
