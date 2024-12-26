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
      "username": "Username",
      "Gender": "Gender",
      "already_have_account": "Already have an Account"
    },
    "Profile": {
      "posts": "posts",
      "followers": "followers",
      "following": "following",
      "edit_profile": "Edit Profile",
      "follow": "Follow",
      "done":"Done",
      "cancel":"Cancel",
      "bio": "Bio",
      "website": "Website",
      "private_information":"Private Information",
      "female": "Female",
      "male": "Male",
      "change_profile_photo": "Change profile photo"
    },
    "Settings":{
      "settings_and_activity": "Settings and activity",
      "language": "Language",
      "mode": "Mode",
      "logOut": "LogOut",
      "saved": "Saved"

    },

  };

  static const Map<String, dynamic> ar = {
    "Authentication": {
      "email": "البريد الإلكتروني",
      "password": "كلمة المرور",
      "login": "تسجيل الدخول",
      "register": "سجل.",
      "do_not_have_an_email?": "هل ليس لديك بريد إلكتروني؟",
      "phone": "الهاتف",
      "username": "أسماء المستخدمين",
      "Gender": "الجنس",
       "already_have_account": "هل لديك حساب بالفعل؟",
    },
    "Profile": {
      "posts": "منشورات",
      "followers": "متابعين",
      "following": "متابعة",
      "edit_profile": "تعديل الملف الشخصى",
      "follow": "متابعة",
      "done": "تم",
      "cancel":"الغاء",
      "bio": "سيرة ذاتية",
      "website": "موقع الكترونى",
      "private_information":"معلومات خاصة",
      "female": "أنثى",
      "male": "ذكر",
      "change_profile_photo": "تغير الصورة الشخصية"
    },
    "Settings":{
      "settings_and_activity": "الاعدادات و النشاط ",
      "language": "اللغة",
      "mode": "وضع",
      "logOut": "تسجيل الخروج",
      "saved": "العناصر المحفوظة"
    },
  };

  static const Map<String, Map<String, dynamic>> mapLocales = {
    "en": en,
    "ar": ar
  };
}

