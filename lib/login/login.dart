import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ges/create%20account/createaccount.dart';
import 'package:ges/globalvariables.dart';
import 'package:ges/login/loginbloc.dart';
import 'package:ges/login/loginevent.dart';
import 'package:ges/login/loginstate.dart';
import 'package:ges/verifyemail/verifyemail.dart';
import 'package:ges/verifyemail/verifyemailbloc.dart';
import '../create account/createaccountbloc.dart';
import '../forgetpassword/forgetpassword.dart';
import '../forgetpassword/forgetpasswordbloc.dart';

// ignore: must_be_immutable
class Login extends StatelessWidget {
  Login({super.key});
  TextEditingController gmailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  void initState() {
    gmailcontroller.clear();
    passwordcontroller.clear();
  }

  void dispose() {
    gmailcontroller.dispose();
    passwordcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: null,
          title: const Text(
            "login",
            style: TextStyle(letterSpacing: 1.0),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<LoginBloc, Loginstate>(builder: (context, state) {
                  if (state is Loginchangestate) {
                    return Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    );
                  } else {
                    return Container();
                  }
                }),
                TextFormField(
                  controller: gmailcontroller,
                  cursorColor: color1,
                  onChanged: (value) {
                    BlocProvider.of<LoginBloc>(context).add(Loginchangeevent(
                        gmailcontroller.text, passwordcontroller.text));
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
                  height: 20.0,
                ),
                TextFormField(
                  controller: passwordcontroller,
                  obscureText: true,
                  cursorColor: color1,
                  onChanged: (value) {
                    BlocProvider.of<LoginBloc>(context).add(Loginchangeevent(
                        gmailcontroller.text, passwordcontroller.text));
                  },
                  decoration: InputDecoration(
                      focusColor: color1,
                      floatingLabelStyle: TextStyle(color: color1),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: color1)),
                      hintText: "your password",
                      label: const Text(
                        "Password",
                      )),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                BlocListener<LoginBloc, Loginstate>(
                  listener: (context, state) async {
                    if (state is Loginsubmitstate) {
                      try {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                      create: (context) => Verifyemailbloc(),
                                      child: VerifyEmail(
                                          credential: state.credential),
                                    )));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("error occured")));
                      }
                    }
                    if (state is Firebaseerrorstate) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.toString())));
                    }
                  },
                  child: BlocBuilder<LoginBloc, Loginstate>(
                    builder: (context, state) {
                      if (state is Progressstate) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: color1,
                            strokeWidth: 10.0,
                          ),
                        );
                      } else {
                        return ElevatedButton(
                            onPressed: () {
                              BlocProvider.of<LoginBloc>(context).add(
                                  Loginsubmitevent(gmailcontroller.text,
                                      passwordcontroller.text));
                            },
                            child: const Text(
                              "login",
                              style: TextStyle(
                                  color: Colors.white, letterSpacing: 1.0),
                            ));
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                    create: (context) => CreateBloc(),
                                    child: Createaccount(),
                                  )));
                        },
                        child: Text(
                          "click here",
                          style: TextStyle(color: color1),
                        ))
                  ],
                ),
                const SizedBox(
                  height: 0.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("forget password ?"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                      create: (context) => ForgetpasswordBloc(),
                                      child: Forgetpassword())));
                        },
                        child: Text(
                          "click here",
                          style: TextStyle(color: color1),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
