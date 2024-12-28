import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clean/feature/post/presentation/screens/all_posts_singleU_page.dart';
import 'package:instagram_clean/feature/post/presentation/widgets/all_posts_single_user.dart';

class ProfileTabController extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   return DefaultTabController(
     length: 3,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,height: 30.h,
            child: TabBar(
             unselectedLabelColor: Colors.grey,
             labelColor: Theme.of(context).iconTheme.color,
             indicatorColor: Theme.of(context).iconTheme.color,
             tabs: [
               Icon(Icons.grid_on),
               Icon(Icons.video_collection_outlined),
               Icon(Icons.person),
             ],
                   ),
          ),
          Container(
            height: 300.h,
            width: double.maxFinite,
            child: TabBarView(
                children: [
                  AllPostsSingleUPage(),
                  AllPostsSingleUPage(),
                  AllPostsSingleUPage()
                ]),
          )
        ],
      ),
   );
  }
}