import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'updatestate.dart';
import 'updateevent.dart';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class UpdateBloc extends Bloc<Updateevent, Updatestate> {
  static late File file;
  static late String name;
  static late String phonenumber;
  static late String profession;
  static late String institution;
  static late String about;
  UpdateBloc() : super(Initialstate()) {
    on<Initialimageevent>(
      (event, emit) {
        emit(Initialimagestate());
      },
    );
    on<PickImageevent>((event, emit) async {
      if (event.file.lengthSync() > 3000000) {
        // notification(context, "photo must be less than 3 MB");
        emit(Changeimagestate("File must be less than 3 MB"));
      } else {
        // setState(() {
        file = event.file;
        emit(Progressimagestate(event.file));
        await Future.delayed(const Duration(seconds: 2));
        //file............................................
        emit(Submitimagestate(event.file));
        // });
      }
    });
    on<Otherinfoinitialevent>(
      (event, emit) {
        // print("Other info initial event");
        emit(Otherinfoinitialstate());
      },
    );
    on<Otherinfochangeevent>(
      (event, emit) async {
        if (event.name.isEmpty) {
          emit(Otherinfochangestate("Please enter name"));
        } else if (event.institution.isEmpty) {
          emit(Otherinfochangestate("please enter name of your institution"));
        } else if (event.number.isEmpty) {
          emit(Otherinfochangestate("please enter mobile phone"));
        } else if (event.profession.isEmpty) {
          emit(Otherinfochangestate("please enter your profession"));
        } else if (event.name.isNotEmpty &
            event.institution.isNotEmpty &
            event.number.isNotEmpty &
            event.profession.isNotEmpty) {
          if (event.name.length < 4) {
            emit(Otherinfochangestate("please enter fullname"));
          } else if (event.institution.length < 4) {
            emit(Otherinfochangestate("please enter fullname of institution"));
          } else if (event.profession.length < 4) {
            emit(Otherinfochangestate("Please enter valid profession"));
          } else if (event.number.length < 14 || event.number.length > 14) {
            emit(Otherinfochangestate("Invalid phone number"));
          } else {
            // print(event.number);
            name = event.name;
            phonenumber = event.number;
            profession = event.profession;
            institution = event.institution;
            emit(Otherinfoprogressstate());
            await Future.delayed(const Duration(seconds: 2));
            emit(Otherinforeadystate("ready to go"));
          }
        } else {
          emit(Initialimagestate());
        }
      },
    );

    on<Aboutyourselfevent>(
      (event, emit) {
        if (event.about.isNotEmpty) {
          if (event.about.length > 10) {
            about = event.about;
            emit(Aboutyourselfreadystate("ready to go"));
          } else {
            emit(Aboutyourselfchangestate("please enter more than 10 words"));
          }
        }
      },
    );
    on<Submittofirebaseevent>(
      (event, emit) async {
        var uid = FirebaseAuth.instance.currentUser!.uid;
        CollectionReference users =
            FirebaseFirestore.instance.collection('users');
        final destination = 'profiles/$name';
        var task = FirebaseApi.uploadFile(destination, file);
        if (task == null) {
          emit(Submittofirebaseerrorstate("Error occured"));
        }
        await task!.then((value) async {
          emit(Submitfirebaseprogressstate());
          final urlDownload = await value.ref.getDownloadURL();
          return urlDownload;
        }).then((value) async {
          var currentuser = FirebaseAuth.instance.currentUser;
          await currentuser!.updateDisplayName(name);
          await Future.delayed(const Duration(seconds: 2));
          await currentuser.updatePhotoURL(value);
          await users.doc(uid).set({
            'name': name,
            'email': currentuser.email,
            'institution': institution,
            'photoURL': value,
            'phonenumber': phonenumber,
            'profession': profession,
            'about': about
          }).whenComplete(() async {
            await Future.delayed(const Duration(seconds: 2));
            emit(Submittofirebasesuccessstate("Sucessfully updated"));
          });
        });

        emit(Submitfirebaseprogressstate());
      },
    );
  }

  // void pickimage(BuildContext context) async {
  //   final picker = ImagePicker();
  //   // ignore: deprecated_member_use
  //   final pickedfile = await picker.getImage(source: ImageSource.gallery);
  //   if (pickedfile == null) return;
  //   if (pickedfile != null) {
  //     final file = File(pickedfile.path);
  //     if (file.lengthSync() > 3000000) {
  //       notification(context, "photo must be less than 3 MB");
  //       return;
  //     } else {
  //       setState(() {
  //         imagefile = file;
  //       });
  //     }
  //   }
  // }
}

class FirebaseApi {
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }

  static UploadTask? uploadBytes(String destination, Uint8List data) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putData(data);
    } on FirebaseException catch (e) {
      return null;
    }
  }
}




















// static Future checkuidindocument() async {
//     var currentuser = FirebaseAuth.instance.currentUser;
//     FirebaseFirestore.instance
//         .collection('users')
//         .doc(currentuser!.uid)
//         .get()
//         .then((DocumentSnapshot documentSnapshot) {
//       if (documentSnapshot.exists) {
//         print(documentSnapshot.id);
//       } else {
//         FirebaseFirestore.instance
//             .collection('users')
//             .doc(currentuser.uid)
//             .set({});
//       }
//     });
//   }
