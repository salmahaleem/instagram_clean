
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clean/core/utils/spacing.dart';
import 'package:instagram_clean/feature/user/presentation/widgets/login_widgets/login_button.dart';
import 'package:instagram_clean/feature/user/presentation/widgets/login_widgets/login_form.dart';
import 'package:instagram_clean/feature/user/presentation/widgets/login_widgets/login_logo.dart';



class LoginPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoginLogo(),
            verticalSpace(50.h),
            LoginForm(),
            verticalSpace(30.h),
            LoginButton(),
          ],
        ),
      ),
    );
  }

}