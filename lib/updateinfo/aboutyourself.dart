import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ges/services/mainpage.dart';
import 'package:ges/updateinfo/updatebloc.dart';
import 'package:ges/updateinfo/updateevent.dart';
import 'package:ges/updateinfo/updatestate.dart';

import '../globalvariables.dart';

class Yourself extends StatelessWidget {
  Yourself({super.key});
  TextEditingController yourselfcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("About yourself"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("write about your carrier and works you have done"),
              BlocBuilder<UpdateBloc, Updatestate>(
                builder: (context, state) {
                  if (state is Aboutyourselfreadystate) {
                    return Text(
                      state.message,
                      style: TextStyle(color: color1),
                    );
                  } else if (state is Aboutyourselfchangestate) {
                    return Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    );
                  }
                  return Container();
                },
              ),
              TextField(
                controller: yourselfcontroller,
                cursorColor: color1,
                maxLines: null,
                onChanged: (value) {
                  BlocProvider.of<UpdateBloc>(context)
                      .add(Aboutyourselfevent(yourselfcontroller.text));
                },
                decoration: InputDecoration(
                    focusColor: color1,
                    fillColor: color1,
                    floatingLabelStyle: TextStyle(color: color1),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: color1)),
                    hintText: "About Yourself",
                    label: const Text(
                      "About yourself",
                    )),
              ),
              const SizedBox(
                height: 20.0,
              ),
              BlocConsumer<UpdateBloc, Updatestate>(
                listener: (context, state) {
                  if (state is Submittofirebaseerrorstate) {
                    var snackbar = SnackBar(content: Text(state.message));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  } else if (state is Submittofirebasesuccessstate) {
                    var snackbar = SnackBar(content: Text(state.message));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainPage()));
                  }
                },
                builder: (context, state) {
                  if (state is Aboutyourselfreadystate) {
                    return ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<UpdateBloc>(context)
                              .add(Submittofirebaseevent());
                        },
                        child: const Text(
                          "submit",
                          style: TextStyle(color: Colors.white),
                        ));
                  } else if (state is Submitfirebaseprogressstate) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: color1,
                        backgroundColor: Colors.white,
                        strokeWidth: 10.0,
                      ),
                    );
                  }
                  return Container();
                },
              )
            ],
          ),
        ),
      ),
    ));
  }
}
