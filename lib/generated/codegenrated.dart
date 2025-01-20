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
      "unFollow": "UnFollow",
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

    "Home":{
      "search":"Search",
      "next": "Next",
      "new_post": "New Post",
      "post": "Post",
      "real": "Real",
      "recent": "Recent",
      "new_reals": "New Reals",
      "post_your_comment": "Post your comment",
      "comments": "Comments",
      "replay": "Replay",
      "post_your_replay": "Post your replay",
      "post_details": "Post Details",
      "share": "Share",
      "description": "Description",
      "no_posts_yet": "No Posts Yet",
      "no_conversation_yet": "No Conversation Yet"
    },
    "Chat": {
      "no_conversation_yet": "No Conversation Yet",
      "online": "Online",
      "offline": "Offline",
      "message": "Message",
      "document": "Document",
      "gallery": "Gallery",
      "location": "Location",
      "select_contacts": "Select Contacts",
      "no_contacts_yet": "No Contacts Yet",
      "post": "Post",
      "real": "Real"
    },
    "Comment": {
      "more_options": "More Options",
      "delete_comment": "Delete Comment",
      "update_comment": "Update Comment",
      "edit_comment": "Edit Comment",
      "save_changes": "Save Changes",
      "edit_replay": "Edit Replay",
      "delete_replay": "Delete Replay",
      "update_replay": "Update Replay",
      "view_replays": "View Replays",
    },
    "Post": {
      "edit_post": "Edit Post",
      "update_post": "Update Post",
      "delete_post": "Delete Post",
      "delete_real": "Delete Real",
      "no_reals_yet": "No Reals Yet",
      "delete_story": "Delete Story",
      "my_story": "My Story"
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
      "unFollow": "الغا المتابعة",
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

    "Home":{
      "search":"البحث",
      "next": "التالى",
      "new_post": "منشور جديد",
      "recent": "حديثا",
      "post": "منشور",
      "real": "مقطع",
      "new_reals": " مقطع جديد",
      "post_your_comment": "ضع تعليقك",
      "comments": "التعليقات",
      "replay": "رد",
      "post_your_replay": "ضع ردك",
      "post_details": "تفاصيل المنشور",
      "share": "مشاركة",
      "description": "وصف",
      "no_posts_yet": "لا توجد منشورات",
    },

    "Chat": {
      "no_conversation_yet": "لا توجد محادثات",
      "online": "متصل",
      "offline": "غير متصل",
      "message": "رسالة",
      "document": "مستندات",
      "gallery": "معرض",
      "location": "موقع",
      "Select Contacts": "حدد متصل",
      "no_contacts_yet": "لا يوجد متصل",
      "post": "منشور",
      "real": "مقطع"
    },
    "Comment": {
      "more_options": "خيارات اخري",
      "delete_comment": "مسح التعليق",
      "update_comment": "تعديل التعليق",
      "edit_comment": "تعديل التعليق",
      "save_changes":"حفظ التغير",
      "edit_replay": "تعديل الرد",
      "delete_replay": "مسح الرد",
      "update_replay": "تعديل الرد",
      "view_replays": "عرض الردود",
    },
    "Post": {
      "edit_post": "تعديل المنشور",
      "update_post": "تعديل المنشور",
      "delete_post": "مسح المنشور",
      "delete_real": "مسح المقطع",
      "no_reals_yet": "لا يوجد مقاطع",
      "delete_story": "مسح القصة",
      "my_story": "قصتك"
    }
  };

  static const Map<String, Map<String, dynamic>> mapLocales = {
    "en": en,
    "ar": ar
  };
}

