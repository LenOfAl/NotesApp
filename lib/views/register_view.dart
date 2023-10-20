import 'package:comingsoon/constants/routes.dart';
import 'package:comingsoon/services/auth/auth_exceptions.dart';
import 'package:comingsoon/services/auth/auth_services.dart';
import 'package:comingsoon/utilities/dialogs/error_dialog.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _email.text = "allennellasorry@gmail.com";
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
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Register',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            obscureText: false,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Enter email here'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: 'Enter password here'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );
                await AuthService.firebase().sendEmailVerification();
                if (!mounted) return;
                Navigator.of(context).pushNamedAndRemoveUntil(
                  verifyEmailRoute,
                  (Route<dynamic> route) => false,
                );
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(
                  context,
                  'Email already in use',
                );
              } on InvalidEmailAuthException {
                await showErrorDialog(
                  context,
                  'This is an invalid email address',
                );
              } on WeakPasswordAuthException {
                await showErrorDialog(
                  context,
                  'Weak password',
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  'Failed to register',
                );
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
            child: const Text('Already register? Login'),
          )
        ],
      ),
    );
  }
}
