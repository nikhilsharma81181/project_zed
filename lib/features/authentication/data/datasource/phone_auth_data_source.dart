import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:project_zed/shared/constant/endpoints.dart';
import 'package:project_zed/shared/error/exceptions.dart';

abstract class PhoneAuthDataSource {
  Future<bool> sendOtp({
    required String phoneNumber,
  });

  Future<String> verifyOtp({
    required String phoneNumber,
    required String otpNumber,
  });
}

class PhoneAuthDataSourceImpl implements PhoneAuthDataSource {
  final Dio dio;
  PhoneAuthDataSourceImpl(this.dio);

  @override
  Future<bool> sendOtp({required String phoneNumber}) async {
    try {
      final res =
          await dio.post("${dio.options.baseUrl}${Endpoint.sendOtp}", data: {
        "phone": "+91$phoneNumber",
      });
      if (res.statusCode == 200) {
        return true;
      }
      throw ServerException("ServerError: ${res.statusCode}");
    } on DioException catch (e) {
      log(e.toString());
      if (e.response != null && e.response!.statusCode == 400) {
        throw ServerException("Invalid Phone Number");
      } else {
        throw ServerException('Server Error: ${e.toString()}');
      }
    }
  }

  @override
  Future<String> verifyOtp(
      {required String phoneNumber, required String otpNumber}) async {
    try {
      final res =
          await dio.post("${dio.options.baseUrl}${Endpoint.verifyOtp}", data: {
        "phone": "+91$phoneNumber",
        "otp": otpNumber,
      });
      if (res.statusCode == 200) {
        return res.data['token'];
      }
      throw ServerException("Invalid OTP or Server Error: ${res.statusCode}");
    } on DioException catch (e) {
      log(e.toString());
      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        if (statusCode == 400) {
          throw ServerException("Invalid OTP");
        } else {
          throw ServerException('Server Error: ${e.toString()}');
        }
      } else {
        throw ServerException('Network Error: ${e.toString()}');
      }
    }
  }
}
