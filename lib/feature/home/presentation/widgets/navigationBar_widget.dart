import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clean/core/get_it/get_it.dart'as di;
import 'package:instagram_clean/feature/home/presentation/screens/explore_page.dart';
import 'package:instagram_clean/feature/home/presentation/screens/home_page.dart';
import 'package:instagram_clean/feature/home/presentation/widgets/add_page_widget.dart';
import 'package:instagram_clean/feature/notification/domain/usecase/get_token.dart';
import 'package:instagram_clean/feature/real/presentation/screens/reals_page.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/profile_cubit/profile_cubit.dart';
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
    BlocProvider.of<GetSingleUserCubit>(context).getSingleUser(uid: widget.uid);
    pageController = PageController();

    di.getIt<GetTokenUseCase>().call().then((String? token){
     print("token $token");
     BlocProvider.of<ProfileCubit>(context).updateUser(user: UserEntity(uid: widget.uid,token: token)).then((value){
       print('update user completed');
     });
    });
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
        if (getSingleUserState is GetSingleUserLoading) {
          return Center(child: CircularProgressIndicator());
        }else if (getSingleUserState is GetSingleUserFailed) {
          return Scaffold(
            body: Center(
              child: Text(
                "Error: ${getSingleUserState.error}",
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            ),
          );}
        else if (getSingleUserState is GetSingleUserLoaded) {
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
                BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined, color: Theme.of(context).iconTheme.color,), label: ""),
                BottomNavigationBarItem(icon: Icon(Icons.video_collection_outlined, color: Theme.of(context).iconTheme.color), label: ""),
                BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined, color: Theme.of(context).iconTheme.color), label: ""),
              ],
              onTap: navigationTapped,
            ),
            body: PageView(
              controller: pageController,
              children: [
                HomePage(currentUser: currentUser),
                ExplorePage(),
                AddPage(currentUser: currentUser),
                RealsPage(),
                ProfilePage(userEntity: currentUser)
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