import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:password_strength/password_strength.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'createaccountevent.dart';
import 'createaccountstate.dart';

class CreateBloc extends Bloc<Createevent, Createstate> {
  StreamController countstream = StreamController();
  CreateBloc() : super(Initialstate()) {
    on<Changeevent>(
      (event, emit) {
        if (event.gmail.isNotEmpty &
            event.password.isNotEmpty &
            event.confirmpassword.isNotEmpty) {
          if (event.gmail.contains('@') == true) {
            if (event.password == event.confirmpassword) {
              if (event.password.length < 5) {
                emit(Errorstate("small password"));
              } else {
                double strength = estimatePasswordStrength(event.password);
                if (strength > 0.5) {
                  emit(Noerrorstate("ready to go"));
                  //ready to go code
                } else {
                  emit(Errorstate("password must be strong"));
                }
              }
            } else {
              emit(Errorstate("passwords do not match with each other"));
            }
          } else {
            emit(Errorstate("please enter valid gmail"));
          }
        } else {
          emit(Errorstate("Please enter value in fields"));
        }
      },
    );
    on<Submitevent>((event, emit) async {
      if (event.gmail.isNotEmpty &
          event.password.isNotEmpty &
          event.confirmpassword.isNotEmpty) {
        if (event.gmail.contains('@') == true) {
          if (event.password == event.confirmpassword) {
            if (event.password.length < 5) {
              emit(Errorstate("small password"));
            } else {
              double strength = estimatePasswordStrength(event.password);
              if (strength > 0.5) {
                emit(Noerrorstate("ready to go"));
                //ready to go code
                try {
                  await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: event.gmail,
                    password: event.confirmpassword,
                  )
                      .then((value) async {
                    emit(Successprocessstate());
                    await Future.delayed(const Duration(seconds: 2));
                    emit(Successcompletestate("Sucessfully created account"));
                  });
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    emit(Errorstate('The password provided is too weak.'));
                  } else if (e.code == 'email-already-in-use') {
                    emit(Errorstate(
                        'The account already exists for that email.'));
                  }
                } catch (e) {
                  emit(Errorstate(e.toString()));
                }
                //firebase code
              } else {
                emit(Errorstate("password must be strong"));
              }
            }
          } else {
            emit(Errorstate("passwords do not match with each other"));
          }
        } else {
          emit(Errorstate("please enter valid gmail"));
        }
      } else {
        emit(Errorstate("Please enter value in fields"));
      }
    });
  }

  // Future Createfirebaseaccount(String emailAddress, String password) async {
  //   try {
  //     final credential =
  //         await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //       email: emailAddress,
  //       password: password,
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'weak-password') {
  //       print('The password provided is too weak.');
  //     } else if (e.code == 'email-already-in-use') {
  //       print('The account already exists for that email.');
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
