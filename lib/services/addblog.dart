import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ges/globalvariables.dart';

class AddBlog extends StatefulWidget {
  const AddBlog({super.key});

  @override
  State<AddBlog> createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  GlobalKey<FormState> blogform = GlobalKey();
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  final currentuser = FirebaseAuth.instance.currentUser;
  // ignore: prefer_typing_uninitialized_variables
  var title;
  // ignore: prefer_typing_uninitialized_variables
  var description;
  var date = DateTime.now();
  CollectionReference blogs = FirebaseFirestore.instance.collection('Blogs');
  CollectionReference users = FirebaseFirestore.instance.collection('users');
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
              )),
          elevation: 0.0,
          // backgroundColor: UserColor.backgroundcolor,
          centerTitle: true,
          title: const Text(
            "Add Blog",
            // style: Userstyle.headerstyle,
          )),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
            key: blogform,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  // style: Userstyle.textstyle,
                  controller: titlecontroller,
                  cursorColor: color1,
                  maxLines: null,
                  onChanged: (value) {
                    setState(() {
                      title = titlecontroller.text;
                    });
                  },
                  validator: ((value) {
                    if (value!.length <= 5) {
                      return "Please update your title ";
                    }
                    return null;
                  }),
                  decoration: InputDecoration(
                      focusColor: color1,
                      floatingLabelStyle: TextStyle(color: color1),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: color1)),
                      hintText: "Enter Title",
                      label: const Text(
                        "Title",
                      )),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  // style: Userstyle.textstyle,
                  controller: descriptioncontroller,
                  cursorColor: color1,
                  onChanged: (value) {
                    setState(() {
                      description = descriptioncontroller.text;
                    });
                  },
                  maxLines: null,
                  validator: ((value) {
                    if (value!.length <= 10) {
                      return "Please update your title";
                    }
                    return null;
                  }),
                  decoration: InputDecoration(
                      focusColor: color1,
                      floatingLabelStyle: TextStyle(color: color1),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: color1)),
                      hintText: "Enter description",
                      label: const Text(
                        "Description",
                      )),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        // backgroundColor: UserColor.backgroundcolor
                        ),
                    onPressed: () {
                      if (blogform.currentState!.validate()) {
                        addblog();
                      }
                    },
                    child: const Text(
                      "Add",
                      style: TextStyle(color: Colors.white),
                      // style: Userstyle.textstyle,
                    )),
              ],
            )),
      ),
    );
  }

  //adding blogs
  Future addblog() async {
    await blogs.add({
      'title': title,
      'description': description,
      'datetime': '${date.day}/${date.month}/${date.year}',
      'name': currentuser!.displayName,
      'photoURL': currentuser!.photoURL
    }).then((value) async {
      Center(
        child: CircularProgressIndicator(
          color: color1,
          strokeWidth: 10.0,
        ),
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("sucessfully added")));
      // notification(context, "Sucessfully Added");
    }).whenComplete(() async {
      Center(
          child: CircularProgressIndicator(
        color: color1,
        strokeWidth: 10.0,
      ));
      await Future.delayed(const Duration(seconds: 2)).then((value) {
        Navigator.pop(context);
      });
    }).catchError((onError) {
      // notification(context, "Error Occured");
    });
  }
}
