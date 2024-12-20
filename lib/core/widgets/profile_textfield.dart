import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileTextField extends StatelessWidget{
  final String hintText;
  final TextEditingController? controller;
  final bool? isObscureText;
  final Widget? suffixIcon;
  final InputDecoration? decoration;


  final String? Function(String?)? validator;

  const ProfileTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.isObscureText,
    this.suffixIcon,
    this.validator,
    this.decoration

  }): super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          border: UnderlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(
            vertical: 15.h,
            horizontal: 5.w
          ),
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.titleSmall,
          suffixIcon: suffixIcon,
      ),
      controller: controller,
      validator: validator,
      obscureText: isObscureText!,
    );

  }

}