import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ges/globalvariables.dart';
import 'package:ges/updateinfo/otherinfo.dart';
import 'package:ges/updateinfo/updatebloc.dart';
import 'package:ges/updateinfo/updateevent.dart';
import 'package:ges/updateinfo/updatestate.dart';
import 'package:image_picker/image_picker.dart';

class Updatescreen extends StatelessWidget {
  Updatescreen({super.key});
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<UpdateBloc>(context).add(Initialimageevent());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Update info"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                BlocConsumer<UpdateBloc, Updatestate>(
                  listener: (context, state) {
                    if (state is Changeimagestate) {
                      var snackbar = SnackBar(
                        content: Text(state.message),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    }
                    if (state is Submitimagestate) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                    create: (context) => UpdateBloc(),
                                    child: Otherinfo(),
                                  )));
                    }
                  },
                  builder: (context, state) {
                    if (state is Progressimagestate) {
                      return Column(
                        children: [
                          Center(
                            child: CircleAvatar(
                              radius: 100.0,
                              backgroundImage: FileImage(state.file),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Center(
                            child: CircularProgressIndicator(
                                color: color1,
                                backgroundColor: Colors.white,
                                strokeWidth: 10.0),
                          )
                          // ElevatedButton(
                          //     onPressed: () {
                          //       BlocProvider.of<UpdateBloc>(context)
                          //           .add(Otherinfoinitialevent());
                          //     },
                          //     child: const Text(
                          //       "Next",
                          //       style: TextStyle(color: Colors.white),
                          //     ))
                        ],
                      );
                    } else {
                      return Center(
                        child: Column(
                          children: [
                            const Text("pick image"),
                            const SizedBox(
                              height: 40.0,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                // ignore: deprecated_member_use
                                await picker
                                    // ignore: deprecated_member_use
                                    .getImage(source: ImageSource.gallery)
                                    .then((value) {
                                  if (value == null) {
                                    return;
                                  } else {
                                    BlocProvider.of<UpdateBloc>(context)
                                        .add(PickImageevent(File(value.path)));
                                  }
                                });
                              },
                              child: const Text(
                                "open gallery",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      );
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
