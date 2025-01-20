import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:instagram_clean/generated/locale_keys.dart';

import '../../../../../core/appLogic/languages/language_cubit.dart';
import '../../../../../core/appLogic/theme/theme_cubit.dart';

class SettingsMenu extends StatelessWidget{
  final UserEntity currentUser;
  const SettingsMenu({super.key, required this.currentUser});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          context.go('/mainPage/:${currentUser.uid}');
        }, icon: Icon(Icons.arrow_back)),
        title: Text("${LocaleKeys.settings_settings_and_activity.tr()}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          spacing:12,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton.icon(
                onPressed: (){},
                label: Text('  ${LocaleKeys.settings_saved.tr()}',style: Theme.of(context).textTheme.labelLarge,),
                icon: Icon(Icons.bookmark_border_outlined, color: Theme.of(context).iconTheme.color,),

            ),
            TextButton.icon(
                onPressed: (){final newLanguageCode = context.locale.languageCode == 'en' ? 'ar' : 'en';
              context
                  .read<LanguageCubit>()
                  .changeLanguage(newLanguageCode);
              context.setLocale(Locale(newLanguageCode));
              },
                label: Text('  ${LocaleKeys.settings_language.tr()}',style: Theme.of(context).textTheme.labelLarge,),
                icon: Icon(Icons.language, color: Theme.of(context).iconTheme.color,)
            ),
            TextButton.icon(
                onPressed: (){context.read<ThemeCubit>().themeToggle();},
                label: Text('  ${LocaleKeys.settings_mode.tr()}',style: Theme.of(context).textTheme.labelLarge,),
                icon: Icon(Icons.dark_mode, color: Theme.of(context).iconTheme.color,)
            ),
            TextButton.icon(
                onPressed: (){
                  context.read<ProfileCubit>().loggedOut();
                  context.go('/');
                },
                label: Text('  ${LocaleKeys.settings_logOut.tr()}',style: Theme.of(context).textTheme.labelLarge,),
                icon: Icon(Icons.logout, color: Theme.of(context).iconTheme.color,)
            ),
          ],
        ),
      ),
    );
  }

}