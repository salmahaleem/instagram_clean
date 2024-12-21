import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static late SharedPreferences sharedPreferences;

  static Future<void>init()async{
    sharedPreferences = await SharedPreferences.getInstance();
  }
  //theme
  static Future<void>setTheme(int theme)async{
    await sharedPreferences.setInt('theme', theme);
  }

  static int? getTheme(){
    return sharedPreferences.getInt('theme');
  }

  //language
  static Future<void>setLanguage(String language)async{
    await sharedPreferences.setString('language', language);
  }

  static String? getLanguage(){
    return sharedPreferences.getString('language');
  }

  static Future<void> setId(String id)async{
    await sharedPreferences.setString('id', id);
  }

  static String? getId(){
    return sharedPreferences.getString('id');
  }

}