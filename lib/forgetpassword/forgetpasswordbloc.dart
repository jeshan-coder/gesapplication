import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ges/forgetpassword/forgetpasswordevent.dart';
import 'package:ges/forgetpassword/forgetpasswordstate.dart';

class ForgetpasswordBloc extends Bloc<Passwordevent, Forgetpasswordstate> {
  ForgetpasswordBloc() : super(Initialstate()) {
    on<Passwordchangeevent>(
      (event, emit) async {
        if (event.gmail.isNotEmpty) {
          if (event.gmail.contains('@') == true) {
            emit(Passwordreadystate("ready to go"));
          } else {
            emit(Passwordchangestate("invalid gmail"));
          }
        } else {
          emit(Passwordchangestate("please enter registered gmail"));
        }
      },
    );
    on<Passwordsubmitevent>(
      (event, emit) async {
        if (event.gmail.isNotEmpty) {
          if (event.gmail.contains('@') == true) {
            try {
              emit(Passwordreadystate("ready to go"));

              await FirebaseAuth.instance
                  .sendPasswordResetEmail(email: event.gmail)
                  .then((value) async {
                emit(Passwordprogressstate("link sended"));
                await Future.delayed(const Duration(seconds: 3));
              }).whenComplete(() async {
                emit(Passwordsubmitstate("please check gmail"));
              });
            } catch (e) {
              emit(Passwordchangestate(e.toString()));
            }
          } else {
            emit(Passwordchangestate("invalid gmail"));
          }
        } else {
          emit(Passwordchangestate("please enter registered gmail"));
        }
      },
    );
  }
}
