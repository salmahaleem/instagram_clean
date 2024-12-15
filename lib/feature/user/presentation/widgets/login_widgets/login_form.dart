import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/core/utils/spacing.dart';
import 'package:instagram_clean/core/widgets/instagramTextField.dart';
import 'package:instagram_clean/generated/locale_keys.dart';



class LoginForm extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          InstagramTextField(
            hintText: LocaleKeys.authenticationEmail.tr(),
            controller: Constant.email,
            isObscureText: false,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return LocaleKeys.authenticationEmail.tr();
              }
              return null;
            },
          ),
          verticalSpace(20.h),
          InstagramTextField(
            hintText: LocaleKeys.authenticationPassword.tr(),
            controller: Constant.password,
            isObscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return LocaleKeys.authenticationPassword.tr();
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

}