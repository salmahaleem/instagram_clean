import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clean/feature/home/presentation/widgets/navigationBar_widget.dart';
import 'package:instagram_clean/feature/user/presentation/screens/login_page.dart';

class MainPage extends StatelessWidget{
  final String uid;

  const MainPage({super.key, required this.uid});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              "Something went wrong: ${snapshot.error}",
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          return NavigationBarWidget(uid: snapshot.data!.uid);
        } else {
          // Redirect to login or show a placeholder
          return LoginPage(); // Replace with your actual login screen
        }
      },
    ),
    );
  }

}