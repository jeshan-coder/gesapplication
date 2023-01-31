import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ges/navigators.dart';
import '../../color and text/style.dart';
// import 'package:open_file/open_file.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

class DigitalLibrary extends StatefulWidget {
  const DigitalLibrary({super.key});

  @override
  State<DigitalLibrary> createState() => _DigitalLibraryState();
}

class _DigitalLibraryState extends State<DigitalLibrary> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('Books').snapshots();
  var dio = Dio();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          );
        }

        return GridView(
          padding: const EdgeInsets.all(5.0),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3 / 4,
              crossAxisSpacing: 15,
              mainAxisSpacing: 20),
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return InkWell(
                onTap: () {
                  openFile(
                      url: data['downloadlink'], filename: "gesdownload.pdf");
                  notification(context, "requesting file");
                  notification(context, "Please wait");
                  notification(context, "Please wait");
                  notification(context, "Please wait");
                },
                child: Card(
                    elevation: 5.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          AutoSizeText(
                            data['title'].toUpperCase(),
                            maxLines: 5,
                            style: Userstyle.headercardstyle,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "BY",
                            style: Userstyle.textstyle,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            data['name'],
                            style: Userstyle.textstyle,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            data['institution'],
                            style: Userstyle.textstyle,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )));
          }).toList(),
        );
      },
    );
  }

  //opening file
  Future openFile({required String url, String? filename}) async {
    var file = await downloadFile(url, filename);
    if (file == null) return null;
    OpenFilex.open(file.path);
  }

  //downoad file
  Future<File?> downloadFile(String url, String? name) async {
    try {
      final appstorage = await getApplicationDocumentsDirectory();
      final file = File("${appstorage.path}/$name");
      final response = await Dio().get(url,
          options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              receiveTimeout: 0));
      final referencefile = file.openSync(mode: FileMode.write);
      referencefile.writeFromSync(response.data);
      await referencefile.close();
      return file;
    } catch (e) {
      return null;
    }
  }

  Widget alertdialog() {
    return AlertDialog(
      title: Text("Title"),
      content: ElevatedButton(
        onPressed: () {},
        child: Text("download"),
      ),
    );
  }
}
