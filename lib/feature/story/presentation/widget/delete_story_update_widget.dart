import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

deleteStoryUpdate(BuildContext context, {required VoidCallback onTap}) {
  // set up the button

  Widget cancelButton = TextButton(
    child: const Text("Cancel"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget deleteButton = TextButton(
    onPressed: onTap,
    child: const Text("Delete"),
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.grey,
    title: const Text("Delete 1 status update"),
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