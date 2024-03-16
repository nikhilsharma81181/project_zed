import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_zed/shared/constant/endpoints.dart';
import 'package:project_zed/shared/server_config/api_response_model.dart';
import 'package:tuple/tuple.dart';

class AuthRepository {
  final Dio dio;
  AuthRepository(this.dio);

  Future<ApiResponse> sendOtp(String phone) async {
    try {
      final res =
          await dio.post("${dio.options.baseUrl}${Endpoint.sendOtp}", data: {
        "phone": "+91$phone",
      });
      if (res.statusCode == 200) {
        return ApiResponse.success();
      }
      log(res.toString());
      return ApiResponse.apiError();
    } on DioException catch (e) {
      log(e.toString());
      if (e.response != null && e.response!.statusCode == 400) {
        return ApiResponse.error('Invalid Phone Number');
      } else {
        return ApiResponse.error('Error occurred: ${e.toString()}');
      }
    }
  }

  Future<Tuple2<ApiResponse, String?>> verifyOtp(phone, otp) async {
    try {
      String reqUrl = "${dio.options.baseUrl}${Endpoint.verifyOtp}";
      final res = await dio.post(reqUrl, data: {
        "phone": "+919334587241",
        "otp": otp,
      });
      log(res.toString());
      if (res.data['success']) {
        return Tuple2<ApiResponse, String?>(
            ApiResponse.success(), res.data['token']);
      } else {
        return Tuple2<ApiResponse, String?>(ApiResponse.apiError(), null);
      }
    } catch (e) {
      log(e.toString());
      return Tuple2<ApiResponse, String?>(
          ApiResponse.error(e.toString()), null);
    }
  }

  Future<Tuple2<ApiResponse, String?>> loginWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final token = await FirebaseAuth.instance.currentUser?.getIdToken();

      Response? res;

      if (userCredential.user != null) {
        res = await dio.post(
          "${dio.options.baseUrl}${Endpoint.googleSSO}",
          data: {"idToken": token},
        );
        log("googleSSO: $res");
      }
      if (res != null && res.data['token']) {
        return Tuple2(ApiResponse.success(), res.data['token']);
      } else {
        return Tuple2(ApiResponse.apiError(), null);
      }
    } catch (e) {
      return Tuple2<ApiResponse, String?>(
          ApiResponse.error(e.toString()), null);
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
