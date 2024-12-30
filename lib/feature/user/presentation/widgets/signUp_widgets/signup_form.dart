import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/core/utils/spacing.dart';
import 'package:instagram_clean/core/widgets/instagramTextField.dart';
import 'package:instagram_clean/generated/locale_keys.dart';


class SignupForm extends StatefulWidget {


  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final GlobalKey <FormState> reformKey = GlobalKey <FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: reformKey,
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
          verticalSpace(8.h),
          InstagramTextField(
            hintText: LocaleKeys.authenticationPassword.tr(),
            controller: Constant.password,
            isObscureText: Constant.isPassVis,
            suffixIcon: GestureDetector(
              onTap: (){
                setState(() {
                  Constant.isPassVis = !Constant.isPassVis;
                });
              },
              child: Icon(Constant.isPassVis? Icons.visibility_off : Icons.visibility)
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return LocaleKeys.authenticationPassword.tr();
              }
              return null;
            },
          ),
          verticalSpace(8.h),
          InstagramTextField(
            hintText: LocaleKeys.authenticationUsername.tr(),
            controller: Constant.username,
            isObscureText: false,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return LocaleKeys.authenticationUsername.tr();
              }
              return null;
            },
          ),
          verticalSpace(8.h),
          InstagramTextField(
            hintText: LocaleKeys.authenticationGender.tr(),
            controller: Constant.gender,
            isObscureText: false,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return LocaleKeys.authenticationGender.tr();
              }
              return null;
            },
          ),
          verticalSpace(8.h),
          InstagramTextField(
            hintText: LocaleKeys.authenticationPhone.tr(),
            controller: Constant.phone,
            isObscureText: false,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return LocaleKeys.authenticationPhone.tr();
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}