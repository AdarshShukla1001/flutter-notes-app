import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myproject/constants/routes.dart';
import 'package:myproject/utilities/show_error_dialog.dart';
import '../firebase_options.dart';



class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
// ignore: unused_field
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
    // super.dispose();
    _email.dispose();
    _password.dispose();
    // dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
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
                  TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                      try{
                        await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                email: email, password: password);
                        Navigator.of(context).pushNamed(verifyEmailRoute);
                        
                      }on FirebaseAuthException catch(e){
                        if(e.code=='weak-password'){
                          await showErrorDialog(context, 'Weak Password');
                        }
                        else if(e.code=='email-already-in-use'){
                          await showErrorDialog(context, 'Email already in use');
                        }
                        else if(e.code=='invalid-email'){
                          await showErrorDialog(context, 'This is an invalid email address');
                        }
                        
                      } catch(e){
                        await showErrorDialog(context, e.toString());
                      }
                      }
                      ,
                      child: const Text('Signup'),
                    ),
                    
                      TextButton(onPressed: (){
                        Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false,);
                      }, child: const Text('Already registered go to login!'))
                  ]),
    );

  }
}
