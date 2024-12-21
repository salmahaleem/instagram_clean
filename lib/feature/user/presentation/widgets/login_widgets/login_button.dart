import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clean/core/utils/spacing.dart';
import 'package:instagram_clean/core/widgets/instagramButton.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/login_cubit/login_cubit.dart';
import 'package:instagram_clean/generated/locale_keys.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Login Successful!"),
                    backgroundColor: Color(0xFFA5D6A7),
                  ),
                );
                context.go('/mainPage');
              } else if (state is LoginFailed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(state.error),
                      backgroundColor: Color(0xFFEF5350)),
                );
              }
            },
            builder: (context, state) {
              return InstagramButton(
                  text: "${LocaleKeys.authenticationLogin.tr()}",
                  onPressed: () {
                    context.read<LoginCubit>().login();
                  });
            },
          ),
          verticalSpace(8.h),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: LocaleKeys.authenticationDoNotHaveAnEmail.tr(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: '  ${LocaleKeys.authenticationRegister.tr()}',
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge
                      ?.copyWith(fontSize: 13.sp),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      context.go('/signup');
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
