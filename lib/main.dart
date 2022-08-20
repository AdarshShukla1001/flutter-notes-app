import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myproject/constants/routes.dart';
import 'package:myproject/firebase_options.dart';
import 'package:myproject/view/register_view.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:myproject/view/login_view.dart';


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
      verifyEmailRoute:((context) => const VerifyEmailView())
      }
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

    @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState){
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              if(user!=null){
                if(user.emailVerified){
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

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Email'),
      ),
      body: Column(children: [
          const Text("we have sent you an email verification. Please open it to verify your account."),
          const Text('If you have not recievd verficatoion email yet, press the button below'),
          TextButton(onPressed:  () async {
              final user=FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
          }, 
          child: const Text('Send email Verification')),

          TextButton(onPressed: () async {
            await FirebaseAuth.instance.signOut();
            await Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
          }, child: const Text('Restart')),
        ]
        ),
    );
  }
}

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

enum MenuAction{ logout }

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
                    await FirebaseAuth.instance.signOut();
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

