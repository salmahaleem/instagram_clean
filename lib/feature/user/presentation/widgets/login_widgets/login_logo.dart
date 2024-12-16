
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:instagram_clean/core/utils/styles.dart';
import 'package:instagram_clean/generated/assets.dart';



class LoginLogo extends StatelessWidget{
  Widget checkTheme(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.light) {
      return Image.asset(Assets.imagesLightLogo);
    } else {
      return Image.asset(Assets.imagesInstagramLogo);
    }
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 68.h,
      width: 244.w,
      child: checkTheme(context)
    );
  }
}
