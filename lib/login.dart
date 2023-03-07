import 'dart:convert';
import 'dart:ffi';

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
                validator: (email) {
                  if (email == null || email.isEmpty) {
                    return 'Por favor, digite seu email!';
                  } else if (!EmailValidator.validate(email, true)) {
                    return 'Digite seu email correto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                keyboardType: TextInputType.text,
                obscureText: true,
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
                    // bool res = await login();
                    login().then((value) {
                      if (value.statusCode == 200) {
                        Get.to(const Home());
                      } else {
                        _passwordController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    });
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
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

  final snackBar = const SnackBar(
    content: Text(
      'Email ou senha inválidos!',
      textAlign: TextAlign.center,
    ),
    backgroundColor: Colors.redAccent,
  );

  // String validateEmail(String email) {
  //   if (email.isEmpty) {
  //     setState(() {
  //       _errorMessage = "Email cannot be empty.";
  //       print(_errorMessage);
  //     });
  //   } else if (!EmailValidator.validate(email, true)) {
  //     setState(() {
  //       _errorMessage = "Invalid Email Address";
  //       print(_errorMessage);
  //     });
  //   } else {
  //     setState(() {
  //       _errorMessage = "Valido";
  //       print(_errorMessage);
  //     });
  //   }
  //   return _errorMessage;
  // }

  Future<http.Response> login() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var url = Uri.parse('http://10.0.2.2:8080/api/auth/login');
    var body = jsonEncode({
      'email': _emailController.text,
      'password': _passwordController.text,
    });

    var response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: body);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var token = jsonResponse['token'];
      await sharedPreferences.setString('token', token);
      // return token;
    }

    return response;
  }
}
