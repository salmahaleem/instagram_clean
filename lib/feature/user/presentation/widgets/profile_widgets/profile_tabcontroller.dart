import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileTabController extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   return SizedBox(width: double.infinity,height: 30.h,
     child: DefaultTabController(
       length: 3,
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
   );
  }
}