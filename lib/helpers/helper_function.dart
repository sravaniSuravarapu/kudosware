import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";

  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    return await sp.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSP(String userName) async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    return await sp.setString(userNameKey, userName);
  }

  static Future<bool> saveUserEmailSP(String userEmail) async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    return await sp.setString(userEmailKey, userEmail);
  }

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    return sp.getBool(userLoggedInKey);
  }

  static Future<String?> getUserEmailSP() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    return sp.getString(userEmailKey);
  }

  static Future<String?> getUserFullnameSP() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    return sp.getString(userNameKey);
  }
}
