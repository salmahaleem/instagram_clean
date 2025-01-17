import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clean/generated/locale_keys.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController controller;
  const SearchWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: controller,
        style: Theme.of(context).textTheme.titleSmall,
        decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search,),
            hintText: "${LocaleKeys.home_search.tr()}",
            hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey),
        ),
      ),
    )
    ;
  }
}