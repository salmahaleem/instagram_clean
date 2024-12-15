
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:instagram_clean/core/utils/styles.dart';
import 'package:instagram_clean/generated/assets.dart';



class LoginLogo extends StatelessWidget{
  checkTheme(){
    if(ThemeData == AppTheme.lightTheme){
      return Image(
          image:AssetImage(Assets.imagesLightLogo)
      );
    }
    else if(ThemeData == AppTheme.darkTheme){
      return Image(
          image:AssetImage(Assets.imagesInstagramLogo)
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 68.h,
      width: 244.w,
      child: checkTheme()
    );
  }
}
