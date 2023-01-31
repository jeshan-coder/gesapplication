// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../color and text/style.dart';
import '../../navigators.dart';
import '../login/login.dart';
import '../services/mainpage.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  GlobalKey<FormState> updateform = GlobalKey();
  TextEditingController yourselfcontroller = TextEditingController();
  TextEditingController institutioncontroller = TextEditingController();

  final currentuser = FirebaseAuth.instance.currentUser;
  CollectionReference aboutyourself =
      FirebaseFirestore.instance.collection('users');
  final storage = FlutterSecureStorage();
  // ignore: prefer_typing_uninitialized_variables
  var about;
  // ignore: prefer_typing_uninitialized_variables
  var institution;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: UserColor.backgroundcolor,
        body: currentuser == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    Center(
                      child: Text(
                        "Please Sign in first",
                        style: Userstyle.textstyle,
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white),
                        onPressed: () {
                          navigatorpushandremove(context, const Login());
                        },
                        child: Text(
                          "Click here",
                          style: Userstyle.textstyle,
                        ))
                  ])
            : FutureBuilder<DocumentSnapshot>(
                future: aboutyourself.doc(currentuser!.uid).get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Something went wrong"),
                    );
                  }

                  if (snapshot.hasData && !snapshot.data!.exists) {
                    return SingleChildScrollView(
                      child: Form(
                          key: updateform,
                          child: Column(
                            children: [
                              Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            currentuser!.photoURL.toString()),
                                        fit: BoxFit.fill)),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  style: Userstyle.textstyle,
                                  controller: yourselfcontroller,
                                  maxLines: null,
                                  onChanged: (value) {
                                    setState(() {
                                      about = yourselfcontroller.text;
                                    });
                                  },
                                  validator: ((value) {
                                    if (value!.length <= 10) {
                                      return "Please update about yourself";
                                    }
                                    return null;
                                  }),
                                  decoration: InputDecoration(
                                      hintText: "About your carrier or job",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      label: Text(
                                        "About Yourself",
                                        textDirection: TextDirection.ltr,
                                        style: Userstyle.textstyle,
                                      )),
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  style: Userstyle.textstyle,
                                  controller: institutioncontroller,
                                  maxLines: null,
                                  onChanged: (value) {
                                    setState(() {
                                      institution = institutioncontroller.text;
                                    });
                                  },
                                  validator: ((value) {
                                    if (value!.length <= 10) {
                                      return "Please update your institution";
                                    }
                                    return null;
                                  }),
                                  decoration: InputDecoration(
                                      hintText:
                                          "About your institution or company",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      label: Text(
                                        "Institution",
                                        textDirection: TextDirection.ltr,
                                        style: Userstyle.textstyle,
                                      )),
                                ),
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          UserColor.backgroundcolor),
                                  onPressed: () async {
                                    storage.write(
                                        key: 'uid', value: currentuser!.uid);
                                    if (updateform.currentState!.validate()) {
                                      addaboutyourself();
                                      notification(
                                          context, "Added Sucessfully");
                                    }
                                  },
                                  child: Text(
                                    "Continue",
                                    style: Userstyle.textstyle,
                                  )),
                            ],
                          )),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    );
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20.0,
                      ),
                      Center(
                        child: ClipOval(
                            child: Image.network(
                          currentuser!.photoURL.toString(),
                          fit: BoxFit.cover,
                          width: 100.0,
                          height: 100.0,
                        )),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        currentuser!.displayName.toString(),
                        style: Userstyle.textstyle,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: UserColor.backgroundcolor),
                          onPressed: () async {
                            await storage.write(
                                key: 'uid', value: currentuser!.uid);
                            navigatorpushandremove(context, const MainPage());
                          },
                          child: Text(
                            "Continue",
                            style: Userstyle.textstyle,
                          ))
                    ],
                  );
                },
              ));
  }

  void clear() {
    yourselfcontroller.clear();
  }

  void addaboutyourself() async {
    await aboutyourself
        .doc(currentuser!.uid.toString())
        .set({
          'about': about,
          'email': currentuser!.email,
          'name': currentuser!.displayName,
          'photoURL': currentuser!.photoURL,
          'institution': institution
        })
        .then((value) => navigatorpushandremove(context, const MainPage()))
        .catchError((onError) => notification(context, "Error Occured"));
    if (mounted) {
      setState(() {});
    }
  }
}
//  NetworkImage(
//                                     currentuser!.photoURL.toString())
