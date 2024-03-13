import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final dioProvider = StateNotifierProvider<DioNotifier, Dio>((ref) {
  return DioNotifier(getDio(ref));
});

Dio getDio(StateNotifierProviderRef<DioNotifier, Dio> ref) {
  var dio = Dio();
  dio.options.receiveTimeout = const Duration(seconds: 10);
  dio.options.baseUrl = "http://localhost:9090";
  return dio;
}

class DioNotifier extends StateNotifier<Dio> {
  DioNotifier(super.state);

  Dio getDioInstance() {
    return state;
  }
}
