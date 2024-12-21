import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clean/feature/user/presentation/screens/profile_page.dart';

import '../../../user/presentation/cubit/profile_cubit/get_single_user_cubit/get_single_user_cubit.dart';

class NavigationBarWidget extends StatefulWidget{
  final String uid;

  const NavigationBarWidget({Key? key, required this.uid}) : super(key: key);

  @override
  State<NavigationBarWidget> createState() => _NavigationBarWidgetState();
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {

  int _currentIndex = 0;

  late PageController pageController;

  @override
  void initState() {
   // BlocProvider.of<GetSingleUserCubit>(context).getSingleUser(uid: widget.uid);
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void navigationTapped(int index) {
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
      builder: (context, getSingleUserState) {
        if (getSingleUserState is GetSingleUserLoaded) {
          final currentUser = getSingleUserState.user;
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home_filled, color: Theme.of(context).iconTheme.color), label: ""),
                BottomNavigationBarItem(icon: Icon(Icons.search_outlined, color: Theme.of(context).iconTheme.color), label: ""),
                BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined, color: Theme.of(context).iconTheme.color), label: ""),
                BottomNavigationBarItem(icon: Icon(Icons.favorite, color: Theme.of(context).iconTheme.color), label: ""),
                BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined, color: Theme.of(context).iconTheme.color), label: ""),

              ],
              onTap: navigationTapped,
            ),
            body: PageView(
              controller: pageController,
              children: [
                //HomePage(),
                //SearchPage(),
               //UploadPostPage(currentUser: currentUser),
                //ActivityPage(),
                ProfilePage(currentUser: currentUser,)
              ],
              onPageChanged: onPageChanged,
            ),
          );
        }
        return Center(child: CircularProgressIndicator(),);
      },
    );

  }
}