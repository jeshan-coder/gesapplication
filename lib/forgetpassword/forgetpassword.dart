import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ges/forgetpassword/forgetpasswordevent.dart';

import '../globalvariables.dart';
import 'forgetpasswordbloc.dart';
import 'forgetpasswordstate.dart';

class Forgetpassword extends StatelessWidget {
  Forgetpassword({super.key});
  TextEditingController gmailcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("reset password"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            BlocBuilder<ForgetpasswordBloc, Forgetpasswordstate>(
                builder: (context, state) {
              if (state is Passwordchangestate) {
                return Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                );
              } else if (state is Passwordreadystate) {
                return Text(
                  state.message,
                  style: TextStyle(color: color1),
                );
              } else {
                return Container();
              }
            }),
            const SizedBox(
              height: 20.0,
            ),
            TextFormField(
                controller: gmailcontroller,
                onChanged: (value) {
                  BlocProvider.of<ForgetpasswordBloc>(context)
                      .add(Passwordchangeevent(gmailcontroller.text));
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
                    ))),
            const SizedBox(
              height: 20.0,
            ),
            BlocConsumer<ForgetpasswordBloc, Forgetpasswordstate>(
              listener: (context, state) {
                if (state is Passwordsubmitstate) {
                  var snackbar =
                      const SnackBar(content: Text("please check mail"));
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                }
              },
              builder: (context, state) {
                if (state is Passwordprogressstate) {
                  return Center(
                    child: CircularProgressIndicator(
                        color: color1, strokeWidth: 10.0),
                  );
                }
                return ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<ForgetpasswordBloc>(context)
                          .add(Passwordsubmitevent(gmailcontroller.text));
                    },
                    child: const Text(
                      "reset",
                      style: TextStyle(color: Colors.white),
                    ));
              },
            )
          ],
        ),
      ),
    ));
  }
}
