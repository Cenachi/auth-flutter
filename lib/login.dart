import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                onChanged: (email) {
                  validateEmail(email);
                },
              ),
              TextFormField(),
              ElevatedButton(
                onPressed: () {},
                child: const Text('ENTRAR'),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  void validateEmail(String email) {
    if (email.isEmpty) {
      setState(() {
        _errorMessage = "Email cannot be empty.";
        // print(_errorMessage);
      });
    } else if (!EmailValidator.validate(email, true)) {
      setState(() {
        _errorMessage = "Invalid Email Address";
        // print(_errorMessage);
      });
    }
  }
}
