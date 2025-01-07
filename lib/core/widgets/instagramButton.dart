
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clean/core/utils/colors.dart';

import '../utils/spacing.dart';

class InstagramButton extends StatelessWidget{
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? color;

  const InstagramButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonStyle = Theme.of(context).elevatedButtonTheme.style ??
        ElevatedButton.styleFrom(
          backgroundColor : color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        );
    return InkWell(
      child: SizedBox(
        width: 400.w,
        height: 50.h,
        child: ElevatedButton(
          style: buttonStyle,
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text,style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 20.sp),),
            ],
          ),
        ),
      ),
    );
  }
}