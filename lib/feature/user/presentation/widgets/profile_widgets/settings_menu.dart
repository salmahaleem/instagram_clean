import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:instagram_clean/generated/locale_keys.dart';
import 'package:sidebarx/sidebarx.dart';

import '../../../../../core/appLogic/languages/language_cubit.dart';
import '../../../../../core/appLogic/theme/theme_cubit.dart';

class SettingsMenu extends StatelessWidget{
  final SidebarXController? sidebarXController;
  final SidebarXController? sideController;
  const SettingsMenu({Key? super.key,this.sideController}):sidebarXController =  sideController;

  @override
  Widget build(BuildContext context) {
    return SidebarX
      (
      controller: sidebarXController!,
      theme: SidebarXTheme(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(20.r),
          ),
          iconTheme: Theme.of(context).iconTheme
      ),
      extendedTheme: SidebarXTheme(width: 140.w),
      headerBuilder: (context,extended){
        return SizedBox(
          width: 100.w,
          height: 100.h,
          child:Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Icon(Icons.person,size: 40.r),
          ),

        );
      },
      items: [
        SidebarXItem(
          label: '  ${LocaleKeys.settings_saved.tr()}',
          onTap: (){
            //context.read<ThemeCubit>().themeToggle();
          },
          icon: Icons.favorite,
          selectable: true,
        ),
        SidebarXItem(
            icon:Icons.language ,
            label: '  ${LocaleKeys.settings_language.tr()}'
            ,onTap: (){
          final newLanguageCode = context.locale.languageCode == 'en' ? 'ar' : 'en';
          context
              .read<LanguageCubit>()
              .changeLanguage(newLanguageCode);
          context.setLocale(Locale(newLanguageCode));
        }),
        SidebarXItem(
          label: '  ${LocaleKeys.settings_mode.tr()}',
          onTap: (){
            context.read<ThemeCubit>().themeToggle();
          },
          icon: Icons.dark_mode,
          selectable: true,
        ),
        SidebarXItem(
          label: '  ${LocaleKeys.settings_logOut.tr()}',
          onTap: (){
            BlocProvider.of<ProfileCubit>(context).loggedOut();
            context.go('/');
          },
          icon: Icons.logout,
          selectable: true,
        ),
      ],
    );
  }

}