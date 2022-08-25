
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myproject/constants/routes.dart';
import 'package:myproject/services/auth/auth_service.dart';
import 'package:myproject/services/crud/notes_service.dart';

import '../../enums/menu_action.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}


class _NotesViewState extends State<NotesView> {

late final NotesService _notesService;
String get userEmail => AuthService.firebase().currentUser!.email!;


@override
void initState(){
  _notesService = NotesService();
  _notesService.open();
  super.initState();
}


@override
void dispose(){
  
  _notesService.close();
  super.initState();
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).pushNamed(newNoteRoute);
          }, icon: const Icon(Icons.add)),
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
      body: FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState){
            case ConnectionState.done:
              return StreamBuilder(
                stream: _notesService.allNotes,
              builder: (context, snapshot) {
                switch (snapshot.connectionState){
                  case ConnectionState.waiting:
                    return const Text('Waiting for all notes ...');
                  default:
                    return const CircularProgressIndicator();
                }
              });
          
            


          default:
              return CircularProgressIndicator();
          }
        }
      ),
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
