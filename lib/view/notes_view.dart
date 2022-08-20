
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myproject/constants/routes.dart';
import 'package:myproject/services/auth/auth_service.dart';

import '../enums/menu_action.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}


class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          PopupMenuButton<MenuAction>(

            onSelected: (value) async {
              switch(value){
                case MenuAction.logout:
                  final shoudLogOut=await showLogOutDialog(context);
                  if(shoudLogOut){
                    await AuthService.firebase().logOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false); 
                  }
                  
              }
            },
          itemBuilder: (context) {
            return const [
            PopupMenuItem<MenuAction>(
              value: MenuAction.logout,
              child: Text('Log out'),
            )
            ];
          },
      )]
      ),
      body: Text('My Notes'),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context){
  return showDialog<bool>(context: context, builder:(context){
    return AlertDialog(
        title: Text('Sign out'),
        content: Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(context).pop(true);
          }, child: Text('Logout')),
          TextButton(onPressed: (){
            Navigator.of(context).pop(false);
          }, child: Text('Cancel')),
        ],
    );
  },
  ).then((value) => value ?? false);
}

