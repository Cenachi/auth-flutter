import 'package:auth/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Home', textAlign: TextAlign.center),
          TextButton(
            onPressed: () async {
              bool logout = await logOut();

              if (logout) {
                Get.to(const Login());
              }
            },
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }
}

Future<bool> logOut() async {
  SharedPreferences sharedPreference = await SharedPreferences.getInstance();
  sharedPreference.remove('token');
  return true;
}
