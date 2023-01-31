// ignore_for_file: prefer_const_constructors, avoid_print, unused_import, unnecessary_import, implementation_imports

import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ges/navigators.dart';
import 'package:ges/screens/login/phonenumber.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneNumberInput extends StatefulWidget {
  const PhoneNumberInput({super.key});

  @override
  State<PhoneNumberInput> createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'NP';
  PhoneNumber number = PhoneNumber(isoCode: 'NP');
  //validate value

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Verify"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: InternationalPhoneNumberInput(
                  onInputChanged: (PhoneNumber value) {
                    setState(() {
                      number = value;
                    });
                    print(number);
                  },
                  selectorConfig: const SelectorConfig(
                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  ),
                  ignoreBlank: false,
                  autoValidateMode: AutovalidateMode.disabled,
                  selectorTextStyle: TextStyle(color: Colors.black),
                  initialValue: number,
                  textFieldController: controller,
                  formatInput: true,
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  inputBorder: const UnderlineInputBorder(),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FirebasePhoneAuthProvider(
                                child: VerifyPhoneNumberScreen(
                                    phoneNumber: number.phoneNumber.toString()),
                              )));
                },
                child: const Text('Validate'),
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     getPhoneNumber('+15417543010');
              //   },
              //   child: Text('Update'),
              // ),
              // ElevatedButton(
              //   onPressed: () {
              //     formKey.currentState?.save();
              //   },
              //   child: Text('Save'),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // void getPhoneNumber(String phoneNumber) async {
  //   PhoneNumber number =
  //       await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'NP');

  //   setState(() {
  //     this.number = number;
  //   });
  // }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
