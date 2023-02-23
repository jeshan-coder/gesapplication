import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ges/globalvariables.dart';
import 'package:ges/services/mainpage.dart';
import 'package:ges/updateinfo/updatescreen.dart';
import 'package:ges/verifyemail/verifyemailevent.dart';
import '../create account/createaccountbloc.dart';
import '../login/login.dart';
import '../login/loginbloc.dart';
import '../updateinfo/updatebloc.dart';
import 'verifyemailbloc.dart';
import 'verifyemailstate.dart';

class VerifyEmail extends StatelessWidget {
  UserCredential credential;
  VerifyEmail({super.key, required this.credential});
  bool canresend = true;
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<Verifyemailbloc>(context).add(Checkverified(credential));
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("verify"),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                "please check mail and click on verify button below",
                style: TextStyle(color: Colors.red),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Center(
              child: CircularProgressIndicator(
                color: color1,
                backgroundColor: Colors.white,
                strokeWidth: 10.0,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Center(
              child: BlocConsumer<Verifyemailbloc, Verifyemailstate>(
                  builder: (context, state) {
                if (state is Unverifiedstate) {
                  return Center(
                      child: ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<Verifyemailbloc>(context)
                                .add(Verifiedlinkevent());
                          },
                          child: const Text(
                            "verify",
                            style: TextStyle(color: Colors.white),
                          )));
                } else {
                  return Container();
                }
              }, listener: (context, state) async {
                if (state is Verifiedstate) {
                  var uid = await FirebaseAuth.instance.currentUser!.uid;
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .get()
                      .then((value) {
                    if (value.exists) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainPage()),
                          (route) => false);
                    } else {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                    create: (context) => UpdateBloc(),
                                    child: Updatescreen(),
                                  )),
                          (route) => false);
                    }
                  }).onError((error, stackTrace) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Error occured")));
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MultiBlocProvider(providers: [
                                  BlocProvider(
                                      create: (context) => LoginBloc()),
                                  BlocProvider(
                                      create: (context) => CreateBloc())
                                ], child: Login())),
                        (route) => false);
                  });
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
