// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ges/getstarted/getstarted.dart';
import 'package:ges/globalvariables.dart';
import 'package:ges/services/mainpage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  MyApp({super.key});

  // This widget is the root of your application.
  final storage = FlutterSecureStorage();
  Future<bool> checkLoginStatus() async {
    String? value = await storage.read(key: 'uid');
    if (value == null) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Geomatics Engineering Society',
      home: FutureBuilder(
          future: checkLoginStatus(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.data == false) {
              return GetStarted();
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              );
            }
            return const MainPage();
          }),
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.cyan,
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                  iconColor: color1,
                  textStyle:
                      TextStyle(color: color1, decorationColor: color1))),
          outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                  textStyle: TextStyle(
                      color: color1,
                      decorationColor: Color.fromRGBO(0, 173, 181, 1)))),
          scaffoldBackgroundColor: Color.fromRGBO(238, 238, 238, 1),
          appBarTheme: AppBarTheme(
              backgroundColor: Color.fromRGBO(238, 238, 238, 1),
              centerTitle: true,
              elevation: 0.5),
          focusColor: Color.fromRGBO(
            0,
            173,
            181,
            1,
          ),
          drawerTheme: DrawerThemeData(
              backgroundColor: Color.fromRGBO(238, 238, 238, 1)),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromRGBO(
              0,
              173,
              181,
              1,
            ),
            minimumSize: Size(150, 50),
            textStyle: TextStyle(color: Colors.white),
          )),
          useMaterial3: true),
    );
  }
}
// const Login()