import 'package:flutter/material.dart';
import 'package:ges/screens/login/loginform_ui.dart';
import '../../color and text/style.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: null,
      child: Scaffold(
        backgroundColor: UserColor.backgroundcolor,
        appBar: AppBar(
          backgroundColor: UserColor.backgroundcolor,
          elevation: 0.0,
          centerTitle: true,
          titleTextStyle: Userstyle.headerstyle,
          title: const Text(
            "Login",
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  'images/logo.png',
                  height: 220.0,
                  width: 220.0,
                ),
              ),
              const LoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}
