import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/core/utils/spacing.dart';
import 'package:instagram_clean/core/widgets/instagramTextField.dart';
import 'package:instagram_clean/core/widgets/profile_textfield.dart';
import 'package:instagram_clean/generated/locale_keys.dart';

class PrivateInfo extends StatefulWidget{
  @override
  State<PrivateInfo> createState() => _PrivateInfoState();
}

class _PrivateInfoState extends State<PrivateInfo> {
  final items = ['Female','Male'];
  String? value;
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                  width:80.w,
                  child: Text('${LocaleKeys.authenticationEmail.tr()}')),
              horizontalSpace(10.w),
              SizedBox(
                width: 230.w,
                child: ProfileTextField(
                  hintText: '${LocaleKeys.authenticationEmail.tr()}',
                  controller: Constant.email,
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
                  child: Text('${LocaleKeys.authenticationGender.tr()}')),
              horizontalSpace(10.w),
              SizedBox(
                width: 230.w,
                child:DropdownButton<String>(
                    value: value,
                   items: items.map(buildMenuItem).toList(),
                   onChanged:(value)=> setState(() =>this.value = value
                    )
                  // hintText: '${LocaleKeys.authenticationGender.tr()}',
                  // controller: Constant.username,
                  // isObscureText: false,
              ),
              )],
          ),
          verticalSpace(10.h),
          Row(
            children: [
              SizedBox(
                  width:80.w,
                  child: Text('${LocaleKeys.authenticationPhone.tr()}')),
              horizontalSpace(10.w),
              SizedBox(
                width: 230.w,
                child: ProfileTextField(
                  hintText: '${LocaleKeys.authenticationPhone.tr()}',
                  controller: Constant.phone,
                  isObscureText: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );

  }
  DropdownMenuItem<String> buildMenuItem (String item)=>DropdownMenuItem(
      value: item,
      child:
      Text(item)
  );
}