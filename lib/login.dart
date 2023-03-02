import 'dart:convert';

import 'package:auth/home.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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

  final snackBar = const SnackBar(
    content: Text(
      'Email ou senha inválidos!',
      textAlign: TextAlign.center,
    ),
    backgroundColor: Colors.green,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                onChanged: (email) {
                  String res = validateEmail(email);
                },
                validator: (email) {
                  if (email == null || email.isEmpty) {
                    return 'Por favor, digite seu email!';
                  } else {
                    return 'Digite seu email correto';
                  }
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                keyboardType: TextInputType.text,
                validator: (senha) {
                  if (senha == null || senha.isEmpty) {
                    return 'Por favor, digite sua senha!';
                  } else if (senha.length < 6) {
                    return 'Senha incorreta';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (_formKey.currentState!.validate()) {
                    bool res = await login();
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                    if (res) {
                      Get.to(const Home());
                    } else {
                      _passwordController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }
                },
                child: const Text('ENTRAR'),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  String validateEmail(String email) {
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
    return _errorMessage;
  }

  Future<bool> login() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    var url = Uri.parse('http://10.0.2.2:8080/api/auth/login');
    try {
      var response = await http.post(url, body: {
        'email': _emailController.text,
        'password': _passwordController.text,
      });

      if (response.statusCode == 200) {
        print(jsonDecode(response.body)['token']);
        return true;
      }
      print(jsonDecode(response.body));
    } catch (e) {
      print(e);
    }

    return false;
  }
}
