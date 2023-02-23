// ignore_for_file: use_key_in_widget_constructors, must_call_super

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ges/globalvariables.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class LibraryDetailview extends StatefulWidget {
  String title;
  String name;
  String institution;
  String downloadlink;
  LibraryDetailview(this.title, this.name, this.institution, this.downloadlink);

  @override
  State<LibraryDetailview> createState() => _LibraryDetailviewState();
}

class _LibraryDetailviewState extends State<LibraryDetailview> {
  double? progressvalue;
  @override
  void initState() {
    progressvalue = null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("Library"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20.0,
              ),
              Text(
                widget.title.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(widget.name),
              Text(widget.institution),
              const SizedBox(
                height: 10.0,
              ),
              progressvalue == null
                  ? Container()
                  : LinearProgressIndicator(
                      value: progressvalue,
                      color: color1,
                    ),
              const SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      progressvalue = 0.0;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("please wait")));
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("downloading...")));
                    await downloadFile(widget.downloadlink, 'gesdownload.pdf')
                        .timeout(const Duration(seconds: 60), onTimeout: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Timeout please try again later")));
                    });
                  },
                  child: const Text(
                    "Open",
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          ),
        ),
      ),
    ));
  }

  //downoad file
  Future<File?> downloadFile(String url, String? name) async {
    try {
      final appstorage = await getApplicationDocumentsDirectory();
      // final file = File("${appstorage.path}/$name");
      final filepath = "${appstorage.path}/$name";
      await Dio().download(
        url,
        filepath,
        onReceiveProgress: (count, total) {
          double progress = count / total;
          setState(() {
            progressvalue = progress;
          });
        },
      );
      final file = File(filepath);
      OpenFilex.open(file.path);
    } catch (e) {
      return null;
    }
  }

  Future openFile({required String url, String? filename}) async {
    var file = await downloadFile(url, filename);
    if (file == null) return null;
    OpenFilex.open(file.path);
  }
}
