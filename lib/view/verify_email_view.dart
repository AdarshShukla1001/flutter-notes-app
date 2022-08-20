
import 'package:flutter/material.dart';
import 'package:myproject/constants/routes.dart';
import 'package:myproject/services/auth/auth_service.dart';

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
              final user=AuthService.firebase().currentUser;
              
          }, 
          child: const Text('Send email Verification')),

          TextButton(onPressed: () async {
            await AuthService.firebase().logOut();
            await Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
          }, child: const Text('Restart')),
        ]
        ),
    );
  }
}


 