// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:myproject/constants/routes.dart';
// import '../firebase_options.dart';
// import 'dart:developer' as devtools show log;




Future<void> showErrorDialog(
  BuildContext context,
  String text,

){
  return showDialog(context: context, builder: (context){
    return AlertDialog(
      title: const Text('An error occured'),
      content: Text(text),
      actions: [
        TextButton(onPressed: (){
          Navigator.of(context).pop();

        }, child: Text('Ok'))
      ],
    );
  },);
}