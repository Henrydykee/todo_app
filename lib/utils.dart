import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
class PrefUtils {

  static const _IS_USER_LOGGED_IN = "user_logged_in";
  static const _USER_FINISHED_ONBOARDING = "user_finished_onboarding";
  static const _FIRST_NAME = "firstName";
  static const _LAST_NAME = "lastName";


  static setUserIsLoggedIn(bool islogin) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(_IS_USER_LOGGED_IN, islogin);
  }

  static Future<bool> getIsUserLoggedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(_IS_USER_LOGGED_IN);
  }

  static setUserHasFinishedOnboarding() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(_USER_FINISHED_ONBOARDING, true);
  }

  static Future<bool> getUserHasFinishedOnboarding() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(_USER_FINISHED_ONBOARDING);
  }

  static setFirstName(String firstName) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(_FIRST_NAME, firstName);
  }

  static Future<String> getFirstName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.get(_FIRST_NAME);
  }

  static setLastName(String lastName) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(_LAST_NAME, lastName);
  }

  static Future<String> getLastName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.get(_LAST_NAME);
  }

}