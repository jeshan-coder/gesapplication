// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ges/globalvariables.dart';
import 'package:path/path.dart';
import 'firebase_api.dart';

class AddFile extends StatefulWidget {
  const AddFile({super.key});

  @override
  State<AddFile> createState() => _AddFileState();
}

class _AddFileState extends State<AddFile> {
  GlobalKey<FormState> fileform = GlobalKey();
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController institutioncontroller = TextEditingController();
  final currentuser = FirebaseAuth.instance.currentUser;
  CollectionReference books = FirebaseFirestore.instance.collection('Books');
  // ignore: prefer_typing_uninitialized_variables
  var title;
  // ignore: prefer_typing_uninitialized_variables
  var description;
  // ignore: prefer_typing_uninitialized_variables
  var name;
  // ignore: prefer_typing_uninitialized_variables
  var institution;
  File? file;
  UploadTask? task;
  // filename=file!=null?basename(file!.path):"No file Selected";
  @override
  void initState() {
    super.initState();
    titlecontroller.clear();
    institutioncontroller.clear();
  }

  @override
  void dispose() {
    titlecontroller.dispose();
    institutioncontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          elevation: 0.0,
          centerTitle: true,
          title: const Text(
            "Add Report",
          )),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
            key: fileform,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: titlecontroller,
                  maxLines: null,
                  cursorColor: color1,
                  onChanged: (value) {
                    setState(() {
                      title = titlecontroller.text;
                    });
                  },
                  validator: ((value) {
                    if (value!.length <= 10) {
                      return "Please Write your title";
                    }
                    return null;
                  }),
                  decoration: InputDecoration(
                      focusColor: color1,
                      floatingLabelStyle: TextStyle(color: color1),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: color1)),
                      hintText: "Title",
                      label: const Text(
                        "Enter project title",
                      )),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: institutioncontroller,
                  maxLines: null,
                  onChanged: (value) {
                    setState(() {
                      institution = institutioncontroller.text;
                    });
                  },
                  validator: ((value) {
                    if (value!.length <= 10) {
                      return "Full name of institution";
                    }
                    return null;
                  }),
                  decoration: InputDecoration(
                      focusColor: color1,
                      floatingLabelStyle: TextStyle(color: color1),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: color1)),
                      hintText: "Institution",
                      label: const Text(
                        "Institution",
                      )),
                ),
                const Text(
                  "You can publish research paper,report or any thing related to our field.",
                  textAlign: TextAlign.center,
                ),
                const Text(
                  "File Size must be less than 10 MB",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                ),
                const Text(
                  "file must be in pdf format",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      fileName,
                    ),
                    IconButton(
                        onPressed: () {
                          selectFile(context);
                        },
                        icon: const Icon(Icons.attach_file))
                  ],
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(),
                    onPressed: () {
                      if (fileform.currentState!.validate()) {
                        uploadFile().then((value) {
                          const Center(
                            child: CircularProgressIndicator(),
                          );
                        }).then((value) {
                          Navigator.pop(context);
                        }).catchError((onError) {
                          // notification(context, "Error occured ");
                        });
                      }
                    },
                    child: const Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    )),
                task != null ? buildUploadStatus(task!) : Container()
              ],
            )),
      ),
    );
  }

  //methods for upload
  Future selectFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) {
      return;
    } else {
      final path = result.files.single.path!;
      if (path.contains("pdf") == true) {
        File newfile = File(path);
        if (newfile.lengthSync() > 10000000) {
          // notification(context, "Sorry, please compress this file");
        } else {
          setState(() {
            file = newfile;
          });
        }
      } else {
        // notification(context, "Sorry only pdf is allowed");
      }
    }
  }

//upload file
  Future uploadFile() async {
    if (file == null) return;

    final fileName = basename(file!.path);
    final destination = 'files/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;
    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    await books.add({
      'title': title,
      'name': currentuser!.displayName,
      'institution': institution,
      'downloadlink': urlDownload,
      'uid': currentuser!.uid
    });
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).round();

            // return Text(
            //   '$percentage %',
            //   style: Userstyle.textstyle,
            // );
            return Center(
                child: CircularProgressIndicator(
              value: percentage / 10,
              color: color1,
              backgroundColor: Colors.white,
              strokeWidth: 10.0,
            ));
          } else {
            return Container();
          }
        },
      );

  void addaboutyourself(String institution, String downloadlink) async {
    await books.doc(currentuser!.uid.toString()).set({
      'title': title,
      'name': currentuser!.displayName,
      'institution': institution
    });
  }
}
