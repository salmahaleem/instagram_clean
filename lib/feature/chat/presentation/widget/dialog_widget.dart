import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

displayAlertDialog(BuildContext context, {required VoidCallback onTap, required String confirmTitle, required String content}) {
  // set up the button

  Widget cancelButton = TextButton(
    child: const Text("Cancel", style: TextStyle(color: Colors.white10),),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget deleteButton = TextButton(
    onPressed: onTap,
    child: Text(confirmTitle, style: const TextStyle(color: Colors.white10),),
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    content: Text(content),
    actions: [cancelButton, deleteButton],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}