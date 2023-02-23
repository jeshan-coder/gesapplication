import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ges/create%20account/createaccountbloc.dart';
import 'package:ges/create%20account/createaccountevent.dart';
import 'package:ges/create%20account/createaccountstate.dart';

import '../globalvariables.dart';
import '../login/login.dart';
import '../login/loginbloc.dart';

class Createaccount extends StatelessWidget {
  Createaccount({super.key});
  TextEditingController gmailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController confirmpasswordcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Create account"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                BlocConsumer<CreateBloc, Createstate>(
                    listener: (context, state) {
                  if (state is Successcompletestate) {
                    var snackbar = const SnackBar(
                      content: Text("sucessfully created account"),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    Future.delayed(const Duration(seconds: 2));
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    );
                  }
                }, builder: (context, state) {
                  if (state is Errorstate) {
                    return Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    );
                  } else if (state is Noerrorstate) {
                    return Text(
                      state.message,
                      style: TextStyle(color: color1),
                    );
                  } else {
                    return Container();
                  }
                }),
                const SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  controller: gmailcontroller,
                  onChanged: (value) {
                    BlocProvider.of<CreateBloc>(context).add(Changeevent(
                        gmailcontroller.text,
                        passwordcontroller.text,
                        confirmpasswordcontroller.text));
                  },
                  decoration: InputDecoration(
                      focusColor: color1,
                      fillColor: color1,
                      floatingLabelStyle: TextStyle(color: color1),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: color1)),
                      hintText: "Enter your gmail (you@gmail.com)",
                      label: const Text(
                        "Gmail",
                      )),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  controller: passwordcontroller,
                  obscureText: true,
                  onChanged: (value) {
                    BlocProvider.of<CreateBloc>(context).add(Changeevent(
                        gmailcontroller.text,
                        passwordcontroller.text,
                        confirmpasswordcontroller.text));
                  },
                  decoration: InputDecoration(
                      focusColor: color1,
                      fillColor: color1,
                      floatingLabelStyle: TextStyle(color: color1),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: color1)),
                      hintText: "Enter password",
                      label: const Text(
                        "Password",
                      )),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  controller: confirmpasswordcontroller,
                  obscureText: true,
                  onChanged: (value) {
                    BlocProvider.of<CreateBloc>(context).add(Changeevent(
                        gmailcontroller.text,
                        passwordcontroller.text,
                        confirmpasswordcontroller.text));
                  },
                  decoration: InputDecoration(
                      focusColor: color1,
                      fillColor: color1,
                      floatingLabelStyle: TextStyle(color: color1),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: color1)),
                      hintText: "Enter password",
                      label: const Text(
                        "Confirm Password",
                      )),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                BlocConsumer<CreateBloc, Createstate>(
                  listener: (context, state) {
                    if (state is Successcompletestate) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MultiBlocProvider(providers: [
                                    BlocProvider(
                                        create: (context) => LoginBloc()),
                                    BlocProvider(
                                        create: (context) => CreateBloc())
                                  ], child: Login())),
                          (route) => false);
                    }
                  },
                  builder: (context, state) {
                    if (state is Successprocessstate) {
                      return Center(
                        child: CircularProgressIndicator(
                            color: color1, strokeWidth: 10.0),
                      );
                    } else {
                      return ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<CreateBloc>(context).add(
                                Submitevent(
                                    gmailcontroller.text,
                                    passwordcontroller.text,
                                    confirmpasswordcontroller.text));
                          },
                          child: const Text(
                            "Create",
                            style: TextStyle(color: Colors.white),
                          ));
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
