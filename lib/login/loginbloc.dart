// ignore_for_file: unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ges/login/loginevent.dart';
import 'package:ges/login/loginstate.dart';

class LoginBloc extends Bloc<Loginevent, Loginstate> {
  final storage = const FlutterSecureStorage();
  LoginBloc() : super(Logininitialstate()) {
    on<Loginchangeevent>(
      (event, emit) {
        if (event.gmail.isEmpty || event.gmail.contains('@') == false) {
          emit(Loginchangestate("please recheck gmail @ missing "));
        } else if (event.password.isEmpty) {
          emit(Loginchangestate("please enter password"));
        } else {
          emit(Loginchangestate("press login"));
        }
      },
    );
    on<Loginsubmitevent>(
      (event, emit) async {
        if (event.gmail.isEmpty || event.gmail.contains('@') == false) {
          emit(Loginchangestate("please recheck gmail @ missing "));
        } else if (event.password.isEmpty || event.gmail.isEmpty) {
          emit(Loginchangestate("please enter password"));
        } else {
          emit(Loginchangestate("press login"));
          emit(Progressstate());
          try {
            var credential = await FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: event.gmail, password: event.password)
                .then((value) async {
              var currentuser = FirebaseAuth.instance.currentUser;
              await Future.delayed(const Duration(seconds: 1));
              return value;
            }).then((value) {
              emit(Loginsubmitstate(value));
            }).onError((error, stackTrace) {
              emit(Loginchangestate(error.toString()));
            });
          } on FirebaseAuthException catch (e) {
            if (e.code == 'user-not-found') {
              emit(Loginchangestate('No user found for that email.'));
            } else if (e.code == 'wrong-password') {
              emit(
                  Firebaseerrorstate('Wrong password provided for that user.'));
            } else {
              emit(Firebaseerrorstate(e.toString()));
            }
          } catch (e) {
            emit(Firebaseerrorstate(e.toString()));
          }
        }
      },
    );
  }
}
