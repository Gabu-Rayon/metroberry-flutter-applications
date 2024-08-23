import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreference {
  static final AppSharedPreference appSharedPreference = AppSharedPreference._internal();
  static const languageCodeKey = "languageCodeKey";

  factory AppSharedPreference() {
    return appSharedPreference;
  }

  AppSharedPreference._internal();

  saveIsUserLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", true);
  }

  removeIsUserLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", false);
  }

  Future<bool> getIsUserLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isLoggedIn") ?? false;
  }

  static Future<String> getString(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(key) ?? "";
  }

  static Future<void> setString(String key, String value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(key, value);
  }

  saveName(String name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("name", name);
  }

  Future<String> getName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("name") ?? '';
  }

  saveEmail(String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("email", email);
  }

  Future<String> getEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("email") ?? '';
  }

  savePassword(String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("password", password);
  }

  Future<String> getPassword() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("password") ?? '';
  }
}
