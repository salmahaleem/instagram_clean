import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clean/feature/home/presentation/widgets/navigationBar_widget.dart';
import 'package:instagram_clean/feature/user/presentation/screens/login_page.dart';

class MainPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: StreamBuilder<User?>(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (context,snapshot){
      if(snapshot.hasData){
        return NavigationBarWidget(uid: snapshot.data!.uid,);
      }
      else{
        return SizedBox.shrink();
      }
    },
    )
    );
  }

}