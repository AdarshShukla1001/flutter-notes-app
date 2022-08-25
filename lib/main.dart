import 'package:myproject/constants/routes.dart';
import 'package:myproject/firebase_options.dart';
import 'package:myproject/services/auth/auth_service.dart';
import 'package:myproject/view/notes/notes_view.dart';
import 'package:myproject/view/notes/new_note_view.dart';
import 'package:myproject/view/register_view.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:myproject/view/login_view.dart';
import 'package:myproject/view/verify_email_view.dart';
// import 'package:';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
       loginRoute:(context)=> const LoginView(),
      registerRoute:(context) => const RegisterView(),
      notesRoute:(context) => const NotesView(),
      verifyEmailRoute:((context) => const VerifyEmailView()),
      newNoteRoute: (context) => const NewNoteView(),
      }
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

    @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState){
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;
              if(user!=null){
                if(user.isEmailVerified){
                  return const NotesView();
                
              }
              else{
                return const VerifyEmailView();
                
              }
              }
              else{
                return const LoginView();
              }
              // break;
              // if(user?.emailVerified??false){
              //   // print('you are verified user');
              //   // return const Text('Done');
              // }else{
              //   // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const VerifyEmailView()));
              //   return const VerifyEmailView();
              // }
              // // break;
              // return const Text('Done');
              return const Text('Done');
            default:
              return Scaffold(body: CircularProgressIndicator());
              // return const Text("Loading....");
              // break;
          }

            
        },
      );
  }

}
