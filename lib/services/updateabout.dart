import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpdateYourself extends StatefulWidget {
  const UpdateYourself({super.key});

  @override
  State<UpdateYourself> createState() => _UpdateYourselfState();
}

class _UpdateYourselfState extends State<UpdateYourself> {
  GlobalKey<FormState> updateform = GlobalKey();
  TextEditingController yourselfcontroller = TextEditingController();

  final currentuser = FirebaseAuth.instance.currentUser;
  CollectionReference aboutyourself =
      FirebaseFirestore.instance.collection('users');

  // ignore: prefer_typing_uninitialized_variables
  var about;
  @override
  void dispose() {
    yourselfcontroller.dispose();
    super.dispose();
  }

  void clear() {
    yourselfcontroller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        elevation: 0.0,
        centerTitle: true,
        title: const Text(
          "Update",
        ),
      ),
      body: SingleChildScrollView(
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
                          image: NetworkImage(currentuser!.photoURL.toString()),
                          fit: BoxFit.fill)),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
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
                        hintText: "About your carrier and achievements",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        label: const Text(
                          "About Yourself",
                          textDirection: TextDirection.ltr,
                        )),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (updateform.currentState!.validate()) {
                        updateUser();
                        clear();
                      }
                    },
                    child: const Text(
                      "Update",
                    )),
              ],
            )),
      ),
    );
  }

  Future<void> updateUser() {
    return aboutyourself
        .doc(currentuser!.uid)
        .update({'about': about}).then((value) {
      // notification(context, "Updated Sucessfully")
    }).catchError((error) {
      // notification(context, "Please try again later")
    });
  }
}
