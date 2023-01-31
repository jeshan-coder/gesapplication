// ignore_for_file: prefer_if_null_operators

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../color and text/style.dart';

class People extends StatefulWidget {
  const People({super.key});

  @override
  State<People> createState() => _PeopleState();
}

class _PeopleState extends State<People> {
  final Stream<QuerySnapshot> blogsStream =
      FirebaseFirestore.instance.collection('users').snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: blogsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Something Went Wrong",
                style: Userstyle.textstyle,
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Container(
                margin: const EdgeInsets.all(2.0),
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Color.fromARGB(193, 226, 225, 225)))),
                child: ExpansionTile(
                  subtitle: Text(
                    data['institution'] == null ? "" : data['institution'],
                    style: Userstyle.subtitletilestyle,
                  ),
                  title: Text(
                    data['name'] != null ? data['name'] : "",
                    style: Userstyle.textstyle,
                  ),
                  leading: ClipOval(
                      child: data['photoURL'] != null
                          ? Image.network(
                              data['photoURL'],
                              fit: BoxFit.cover,
                              width: 50.0,
                              height: 50.0,
                            )
                          : Image.asset('images/unspecified.png')),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        data['about'] != null ? data['about'] : "",
                        style: const TextStyle(wordSpacing: 1.0),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
          );

          // Container(
          //   child: ListView.builder(
          //       itemCount: 20,
          //       itemBuilder: ((context, index) => ListTile(
          //             onTap: () {},
          //             title: Text(
          //               "Blog Title",
          //               style: Userstyle.textstyle,
          //             ),
          //             subtitle: Text(
          //               "Author name",
          //               style: Userstyle.subtitletilestyle,
          //             ),
          //             trailing: Text(
          //               "2022/10/01",
          //               style: Userstyle.subtitletilestyle,
          //             ),
          //             leading: ClipOval(
          //                 child: Image.asset(
          //               "user.png",
          //               fit: BoxFit.cover,
          //               width: 50.0,
          //               height: 50.0,
          //             )),
          //           ))),
          // );
        });
  }
}
