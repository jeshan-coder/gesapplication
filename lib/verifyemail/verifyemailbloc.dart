import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'verifyemailevent.dart';
import 'verifyemailstate.dart';

class Verifyemailbloc extends Bloc<Verifyemailevent, Verifyemailstate> {
  final storage = const FlutterSecureStorage();
  Verifyemailbloc() : super(Initialstate()) {
    on<Checkverified>(
      (event, emit) async {
        if (event.credential.user!.emailVerified == true) {
          await storage.write(
            key: 'uid',
            value: event.credential.user!.uid,
          );
          emit(Verifiedstate());
        } else {
          await event.credential.user!
              .sendEmailVerification()
              .then((value) async {
            Future.delayed(const Duration(seconds: 7));
            await FirebaseAuth.instance.currentUser!.reload();
            if (event.credential.user!.emailVerified == true) {
              await storage.write(
                key: 'uid',
                value: event.credential.user!.uid,
              );
              emit(Verifiedstate());
            } else {
              emit(Unverifiedstate());
            }
          }).timeout(const Duration(minutes: 5));
        }
      },
    );
    on<Verifiedlinkevent>(
      (event, emit) async {
        await FirebaseAuth.instance.currentUser!.reload();
        if (FirebaseAuth.instance.currentUser!.emailVerified == true) {
          emit(Verifiedstate());
        } else {
          emit(Unverifiedstate());
        }
      },
    );
  }
}
