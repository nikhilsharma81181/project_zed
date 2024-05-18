import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_zed/core/error/failure.dart';
import 'package:project_zed/features/authentication/data/datasource/google_auth_data_source.dart';
import 'package:project_zed/features/authentication/data/repository/google_auth_repository_impl.dart';
import 'package:project_zed/features/authentication/domain/repository/google_repository.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});
final googleSignInProvider = Provider<GoogleSignIn>((ref) => GoogleSignIn());

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final googleAuthNotifierProvider =
    StateNotifierProvider.autoDispose<GoogleAuthNotifier, AsyncValue<bool>>(
        (ref) {
  final googleAuthRepository = GoogleAuthRepositoryImpl(
    GoogleAuthDataSourceImpl(
      ref.watch(googleSignInProvider),
      ref.watch(firebaseAuthProvider),
    ),
  );
  return GoogleAuthNotifier(googleAuthRepository);
});

class GoogleAuthNotifier extends StateNotifier<AsyncValue<bool>> {
  final GoogleAuthRepository _googleAuthRepository;

  GoogleAuthNotifier(this._googleAuthRepository)
      : super(const AsyncValue.data(false));

  Future<Either<Failure, bool>> signInWithGoogle() async {
    final result = await _googleAuthRepository.googleSignIn();

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
}
