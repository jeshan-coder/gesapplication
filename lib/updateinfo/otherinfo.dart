import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ges/updateinfo/aboutyourself.dart';
import 'package:ges/updateinfo/updatebloc.dart';
import 'package:ges/updateinfo/updateevent.dart';
import 'package:ges/updateinfo/updatestate.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../globalvariables.dart';

class Otherinfo extends StatelessWidget {
  Otherinfo({super.key});
  TextEditingController institutioncontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController professioncontroller = TextEditingController();
  TextEditingController numbercontroller = TextEditingController();
  PhoneNumber number = PhoneNumber(isoCode: 'NP');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update info"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              BlocBuilder<UpdateBloc, Updatestate>(builder: (context, state) {
                if (state is Otherinfochangestate) {
                  return Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  );
                } else if (state is Otherinforeadystate) {
                  return Text(
                    state.message,
                    style: TextStyle(color: color1),
                  );
                }
                return Container();
              }),
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
                controller: namecontroller,
                cursorColor: color1,
                onChanged: (value) {
                  BlocProvider.of<UpdateBloc>(context).add(Otherinfochangeevent(
                      namecontroller.text,
                      institutioncontroller.text,
                      professioncontroller.text,
                      numbercontroller.text));
                },
                decoration: InputDecoration(
                    focusColor: color1,
                    fillColor: color1,
                    floatingLabelStyle: TextStyle(color: color1),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: color1)),
                    hintText: "Enter your full Name",
                    label: const Text(
                      "Full Name",
                    )),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
                controller: institutioncontroller,
                cursorColor: color1,
                onChanged: (value) {
                  BlocProvider.of<UpdateBloc>(context).add(Otherinfochangeevent(
                      namecontroller.text,
                      institutioncontroller.text,
                      professioncontroller.text,
                      numbercontroller.text));
                },
                decoration: InputDecoration(
                    focusColor: color1,
                    fillColor: color1,
                    floatingLabelStyle: TextStyle(color: color1),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: color1)),
                    hintText: "Full name of your institution",
                    label: const Text(
                      "Institution",
                    )),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
                controller: professioncontroller,
                cursorColor: color1,
                onChanged: (value) {
                  BlocProvider.of<UpdateBloc>(context).add(Otherinfochangeevent(
                      namecontroller.text,
                      institutioncontroller.text,
                      professioncontroller.text,
                      numbercontroller.text));
                },
                decoration: InputDecoration(
                    focusColor: color1,
                    fillColor: color1,
                    floatingLabelStyle: TextStyle(color: color1),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: color1)),
                    hintText: "About your profession",
                    label: const Text(
                      "Profession",
                    )),
              ),
              const SizedBox(
                height: 20.0,
              ),
              InternationalPhoneNumberInput(
                  initialValue: number,
                  textFieldController: numbercontroller,
                  inputDecoration: InputDecoration(
                      focusColor: color1,
                      fillColor: color1,
                      floatingLabelStyle: TextStyle(color: color1),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: color1))),
                  cursorColor: color1,
                  // countries: ['NP'],
                  onInputChanged: (value) {
                    //logic code
                    print("VALUE::::::${numbercontroller.value}");

                    BlocProvider.of<UpdateBloc>(context).add(
                        Otherinfochangeevent(
                            namecontroller.text,
                            institutioncontroller.text,
                            professioncontroller.text,
                            value.phoneNumber.toString()));
                  }),
              const SizedBox(
                height: 20.0,
              ),
              BlocBuilder<UpdateBloc, Updatestate>(
                builder: (context, state) {
                  if (state is Otherinforeadystate) {
                    return ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                        create: (context) => UpdateBloc(),
                                        child: Yourself(),
                                      )));
                        },
                        child: const Text(
                          "next",
                          style: TextStyle(color: Colors.white),
                        ));
                  } else if (state is Otherinfoprogressstate) {
                    return Center(
                      child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          color: color1,
                          strokeWidth: 10.0),
                    );
                  }
                  return Container();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
