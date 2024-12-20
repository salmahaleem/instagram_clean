import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/core/utils/spacing.dart';
import 'package:instagram_clean/core/widgets/instagramTextField.dart';
import 'package:instagram_clean/core/widgets/profile_textfield.dart';
import 'package:instagram_clean/generated/locale_keys.dart';

class MainInfo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   return Form(
     child: Column(
       children: [
         Row(
           children: [
             SizedBox(
                 width:80.w,
                 child: Text('${LocaleKeys.authenticationUsername.tr()}')),
             horizontalSpace(10.w),
             SizedBox(
               width: 230.w,
               child: ProfileTextField(
                   hintText: '${LocaleKeys.authenticationUsername.tr()}',
                   controller: Constant.username,
                   isObscureText: false,
               ),
             ),
           ],
         ),
         verticalSpace(10.h),
         Row(
           children: [
             SizedBox(
                 width:80.w,
                 child: Text('${LocaleKeys.profile_website.tr()}')),
             horizontalSpace(10.w),
             SizedBox(
               width: 230.w,
               child: ProfileTextField(
                 hintText: '${LocaleKeys.profile_website.tr()}',
                 controller: Constant.website,
                 isObscureText: false,
               ),
             ),
           ],
         ),
         verticalSpace(10.h),
         Row(
           children: [
             SizedBox(
             width:80.w,
             child: Text('${LocaleKeys.profile_bio.tr()}')),
             horizontalSpace(10.w),
             SizedBox(
               width: 230.w,
               child: ProfileTextField(
                 hintText: '${LocaleKeys.profile_bio.tr()}',
                 controller: Constant.bio,
                 isObscureText: false,
               ),
             ),
           ],
         ),
       ],
     ),
   );
  }

}