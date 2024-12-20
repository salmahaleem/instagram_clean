import 'package:flutter/cupertino.dart';

class Constant {

  //firebase constant
  static const String users ="users";
  static const String comment ="comment";
  static const String posts ="posts";
  static const String replay ="replay";

  static TextEditingController email = TextEditingController();
  static TextEditingController password = TextEditingController();
  static TextEditingController phone = TextEditingController();
  static TextEditingController username = TextEditingController();
  static TextEditingController gender = TextEditingController();
  static TextEditingController website = TextEditingController();
  static TextEditingController bio = TextEditingController();
  static  bool isPassVis = true;
  static GlobalKey <FormState> reformKey = GlobalKey <FormState> ();
  static GlobalKey <FormState> formKey = GlobalKey <FormState> ();




}