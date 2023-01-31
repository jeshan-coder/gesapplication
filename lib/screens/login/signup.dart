// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison, unused_local_variable, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ges/navigators.dart';
import 'package:ges/screens/login/login.dart';
import 'package:ges/screens/services/firebase_api.dart';
import '../../color and text/style.dart';
import 'package:password_strength/password_strength.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SignUp extends StatefulWidget {
  String phonenumber;
  SignUp(this.phonenumber, {super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> signupform = GlobalKey();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController photourlcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController passwordconfirmcontroller = TextEditingController();
  TextEditingController aboutcontroller = TextEditingController();
  TextEditingController institutioncontroller = TextEditingController();
  CollectionReference aboutyourself =
      FirebaseFirestore.instance.collection('users');
  double strength = 0.0;
  String? email;
  String? password;
  String? confirmpassword;
  File? imagefile;
  String? name;
  String? about;
  String? institution;
  String? photoURL;
  UploadTask? task;
  @override
  void initState() {
    emailcontroller.clear();
    namecontroller.clear();
    photourlcontroller.clear();
    passwordcontroller.clear();
    passwordconfirmcontroller.clear();
    aboutcontroller.clear();
    institutioncontroller.clear();

    super.initState();
  }

  @override
  void dispose() {
    emailcontroller.dispose();
    namecontroller.dispose();
    photourlcontroller.dispose();
    passwordcontroller.dispose();
    passwordconfirmcontroller.dispose();
    aboutcontroller.clear();
    institutioncontroller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        elevation: 0.0,
        title: Text(
          "SignUp",
          style: Userstyle.headerstyle,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Form(
            key: signupform,
            child: Column(
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                imagefile == null
                    ? const Text(
                        "No image selected",
                        style: TextStyle(color: Colors.red),
                      )
                    : CircleAvatar(
                        radius: 60.0,
                        backgroundImage: FileImage(imagefile!),
                      ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Choose Image",
                      style: TextStyle(color: Colors.grey),
                    ),
                    IconButton(
                      onPressed: () {
                        pickimage(context);
                      },
                      icon: const Icon(
                        Icons.photo_camera_outlined,
                        color: Colors.cyan,
                      ),
                    ),
                  ],
                ),

                //-----------------------name text field-------------------------//
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your name";
                    }
                    if (value.length < 3) {
                      return "Please enter your name";
                    }
                    return null;
                  },
                  onChanged: ((value) {
                    setState(() {
                      name = namecontroller.text;
                    });
                  }),
                  controller: namecontroller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      label: Text(
                        "Full Name",
                        textDirection: TextDirection.ltr,
                        style: Userstyle.textstyle,
                      )),
                ),
                //-------------------------------photourl text field -------------------------/
                const SizedBox(
                  height: 20.0,
                ),
                //----------------------------emailcontroller-------------------//
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter email";
                    }
                    if (EmailValidator.validate(value) == false) {
                      return "Please enter valid mail";
                    }
                    return null;
                  },
                  onChanged: ((value) {
                    setState(() {
                      email = emailcontroller.text;
                    });
                  }),
                  controller: emailcontroller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      label: Text(
                        "Email",
                        textDirection: TextDirection.ltr,
                        style: Userstyle.textstyle,
                      )),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                //------------------------------institution controller ---------------------//
                TextFormField(
                  controller: institutioncontroller,
                  onChanged: ((value) {
                    setState(() {
                      institution = institutioncontroller.text;
                    });
                  }),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter institution name";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      label: Text(
                        "Institution",
                        textDirection: TextDirection.ltr,
                        style: Userstyle.textstyle,
                      )),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  maxLines: null,
                  controller: aboutcontroller,
                  onChanged: ((value) {
                    setState(() {
                      about = aboutcontroller.text;
                    });
                  }),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter About yourself";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      helperText: "About your occupation and education",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      label: Text(
                        "AboutYourself",
                        textDirection: TextDirection.ltr,
                        style: Userstyle.textstyle,
                      )),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: passwordcontroller,
                  onChanged: (value) {
                    setState(() {
                      strength = estimatePasswordStrength(value);
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter password";
                    }
                    if (value != passwordcontroller.text) {
                      return "Confirm Password didn't match password";
                    }
                    if (strength < 0.3) {
                      return "Please enter strong password";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      label: Text(
                        "Password",
                        textDirection: TextDirection.ltr,
                        style: Userstyle.textstyle,
                      )),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: passwordconfirmcontroller,
                  onChanged: (value) {
                    setState(() {
                      strength = estimatePasswordStrength(value);
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter password";
                    }
                    if (value != passwordcontroller.text) {
                      return "Confirm Password didn't match password";
                    }
                    if (strength < 0.3) {
                      return "Please enter strong password";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      label: Text(
                        "Confirm Password",
                        textDirection: TextDirection.ltr,
                        style: Userstyle.textstyle,
                      )),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, elevation: 10.0),
                    onPressed: () {
                      if (signupform.currentState!.validate()) {
                        email = emailcontroller.text;
                        password = passwordcontroller.text;
                        name = namecontroller.text;
                        institution = institutioncontroller.text;
                        about = aboutcontroller.text;
                        submitinfo().then((value) =>
                            navigatorpushandremove(context, const Login()));
                      }
                    },
                    child: Text(
                      "Sign Up",
                      style: Userstyle.textstyle,
                    )),
              ],
            )),
      ),
    );
  }

  Future submitinfo() async {
    if (signupform.currentState!.validate()) {
      if (passwordcontroller.text == passwordconfirmcontroller.text &&
          imagefile != null &&
          email != null &&
          institution != null &&
          name != null) {
        try {
          var value = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
            email: email!,
            password: password!,
          )
              .then((value) async {
            messsage("Account Added Sucessfully ");
            try {
              await FirebaseAuth.instance
                  .signInWithEmailAndPassword(
                      email: email!, password: password!)
                  .then((value) async {
                if (imagefile == null) {
                  notification(context, "Please Select image");
                } else {
                  final destination = 'profiles/$name';
                  task = FirebaseApi.uploadFile(destination, imagefile!);
                  setState(() {});
                  if (task == null) {
                    notification(context, "Error Occured");
                  }
                  final snapshot = await task!.whenComplete(() {});
                  final urlDownload = await snapshot.ref.getDownloadURL();
                  setState(() {
                    photoURL = urlDownload;
                  });
                }
                return value;
              }).then((value) {
                var currentuser = FirebaseAuth.instance.currentUser;
                if (currentuser != null) {
                  currentuser.updateDisplayName(name);
                  currentuser.updateEmail(email!);
                  currentuser.updatePhotoURL(photoURL);
                  CollectionReference users =
                      FirebaseFirestore.instance.collection('users');
                  users.doc(currentuser.uid.toString()).set({
                    'about': about,
                    'email': email,
                    'name': name,
                    'photoURL': photoURL,
                    'institution': institution,
                    'number': widget.phonenumber
                  }).then((value) {
                    FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                  }).catchError((error) {});
                }
              });
            } on FirebaseAuthException catch (e) {
              if (e.code == 'user-not-found') {
              } else if (e.code == 'wrong-password') {}
            }
          }).then((value) {});
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            return null;
          } else if (e.code == 'email-already-in-use') {
            messsage('gmail already exists');
          }
        } catch (e) {
          var snackbar = const SnackBar(
            content: Text('Error occured'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
      }
    }
  }

  void messsage(String message) {
    var snackbar = SnackBar(
      backgroundColor: UserColor.backgroundcolor,
      content: Center(
        child: Text(
          message,
          style: Userstyle.textstyle,
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void pickimage(BuildContext context) async {
    final picker = ImagePicker();
    // ignore: deprecated_member_use
    final pickedfile = await picker.getImage(source: ImageSource.gallery);
    if (pickedfile == null) return;
    if (pickedfile != null) {
      final file = File(pickedfile.path);
      if (file.lengthSync() > 3000000) {
        notification(context, "photo must be less than 3 MB");
        return;
      } else {
        setState(() {
          imagefile = file;
        });
      }
    }
  }
}
