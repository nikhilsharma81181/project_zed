import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static SharedPreferences? _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<void> setToken(String token) async {
    await _preferences!.setString('token', token);
  }

  static String? getToken() => _preferences!.getString('token');

  static Future<void> setLoginWith(String loginWith) async {
    await _preferences!.setString('loginWith', loginWith);
  }

  static String? getLoginWith() => _preferences!.getString('loginWith');
}
