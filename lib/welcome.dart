import 'package:auth/home.dart';
import 'package:auth/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class Controller extends GetxController {
  String titulo = "Auth Aplication";
}

class _WelcomeState extends State<Welcome> {
  @override
  void initState() {
    super.initState();

    verificarToken().then((value) {
      if (value) {
        Get.to(const Home());
      } else {
        Get.to(const Login());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ));
  }

  Future<bool> verificarToken() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    if (sharedPreference.getString('token') != null) {
      return true;
    } else {
      return false;
    }
  }
}
