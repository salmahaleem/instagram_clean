
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/feature/user/presentation/widgets/signUp_widgets/signup_button.dart';
import 'package:instagram_clean/feature/user/presentation/widgets/signUp_widgets/signup_form.dart';
import 'package:instagram_clean/feature/user/presentation/widgets/signUp_widgets/signup_logo.dart';
import 'package:instagram_clean/feature/user/presentation/widgets/signUp_widgets/signup_photo.dart';

import '../../../../core/utils/spacing.dart';


class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SignupLogo(),
              verticalSpace(20.h),
              SignupPhoto(userEntity: Constant.userEntity,),
              verticalSpace(20.h),
              SignupForm(),
              verticalSpace(10.h),
              SignupButton(userEntity: Constant.userEntity,),
            ],
          ),
        ),
      ),
    );
  }
}