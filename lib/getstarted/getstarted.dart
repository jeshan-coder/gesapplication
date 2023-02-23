import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../create account/createaccountbloc.dart';
import '../login/login.dart';
import '../login/loginbloc.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: null,
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 150, 20, 10),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        offset: Offset(1.0, 1.0),
                        spreadRadius: 5.0,
                        blurRadius: 2.0,
                      )
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                height: 400,
                width: 500,
                // color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/logo.png',
                        height: 250,
                        width: 250,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MultiBlocProvider(providers: [
                                        BlocProvider(
                                            create: (context) => LoginBloc()),
                                        BlocProvider(
                                            create: (context) => CreateBloc())
                                      ], child: Login())));
                        },
                        child: const Text(
                          "Enter",
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
