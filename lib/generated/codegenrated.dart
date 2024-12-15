import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';

class CodeGenerated extends AssetLoader{
  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }
  static const Map<String, dynamic> en = {
    "Authentication": {
      "email": "Email",
      "password": "Password",
      "login": "Login",
      "register": "Register.",
      "do_not_have_an_email?": "Do not have an email?",
      "phone": "Phone",
      "usernames": "Usernames",
      "Gender": "Gender",
      "already_have_account": "Already have an Account"
    }
  };

  static const Map<String, dynamic> ar = {
    "Authentication": {
      "email": "البريد الإلكتروني",
      "password": "كلمة المرور",
      "login": "تسجيل الدخول",
      "register": "سجل.",
      "do_not_have_an_email?": "هل ليس لديك بريد إلكتروني؟",
      "phone": "الهاتف",
      "usernames": "أسماء المستخدمين",
      "Gender": "الجنس",
       "already_have_account": "هل لديك حساب بالفعل؟",
    }
  };

  static const Map<String, Map<String, dynamic>> mapLocales = {
    "en": en,
    "ar": ar
  };
}

