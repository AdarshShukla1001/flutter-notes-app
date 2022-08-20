import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myproject/constants/routes.dart';
import '../firebase_options.dart';
import 'dart:developer' as devtools show log;

import '../utilities/show_error_dialog.dart';




class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
late final TextEditingController _email;

  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(children: [
    
                  TextField(
                      controller: _email,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration:
                          const InputDecoration(hintText: 'Enter you  email here'),
                    ),
                  TextField(
                      controller: _password,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration:
                          const InputDecoration(hintText: 'Enter you  password here'),
                    ),
                  Column(
                    children: [
                      TextButton(
                          onPressed: () async {
                            final email = _email.text;
                            final password = _password.text;
                            try{
                              
                              
                            final userCredential = await FirebaseAuth.instance
                            
                                .signInWithEmailAndPassword(
                                    email: email, password: password);


                                    
                                  // if(userCredential.)  
                                  
                                  Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (route) => false,);
                            // devtools.log(userCredential.toString());
                            }on FirebaseAuthException catch(e){
                              if(e.code=='user-not-found'){
                                // devtools.log('something bad happend');
                                await showErrorDialog(context, 'User not found');
                              }
                              if(e.code=='user-not-found'){
                                // devtools.log('something bad happend');
                                await showErrorDialog(context, 'User not found');
                              }
                              else if(e.code == 'wrong-password'){
                                // print('wrong password');
                                await showErrorDialog(context, 'Wrong Password');
                              }
                              else{
                                // devtools.log(e.code.toString());
                                await showErrorDialog(context, 'Error:${e.code}');
                              }
                              // Navigator.of(context).pushNamedAndRemoveUntil('/notes/', (route) => false,);
                              
                              // print(e);
    
    
                            } catch(e){
                              await showErrorDialog(context, e.toString());
                            }
                            // Navigator.of(context).pushNamedAndRemoveUntil('/notes/', (route) => false,);
                          },
                          child: const Text('Login'),
                        ),
                        TextButton(onPressed: (){
                          Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false,);
                        }, child: Text('Not Registered yet!Register here'))
                    ],
                  ),
                  ]),
    );
  }

}
