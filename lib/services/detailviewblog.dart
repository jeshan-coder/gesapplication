// ignore_for_file: must_be_immutable, no_logic_in_create_state, unnecessary_string_interpolations

import 'package:flutter/material.dart';

class DetailView extends StatefulWidget {
  String datetime;
  String description;
  String name;
  String photoURL;
  String title;
  DetailView(
      this.datetime, this.description, this.name, this.photoURL, this.title,
      {super.key});

  @override
  State<DetailView> createState() =>
      _DetailViewState(datetime, description, name, photoURL, title);
}

class _DetailViewState extends State<DetailView> {
  String datetime;
  String description;
  String name;
  String photoURL;
  String title;
  _DetailViewState(
      this.datetime, this.description, this.name, this.photoURL, this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.cancel,
              color: Colors.black,
            )),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 40.0,
              ),
              ClipOval(
                  child: Image.network(
                photoURL,
                fit: BoxFit.cover,
                width: 100.0,
                height: 100.0,
              )),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                "$name",
                style: const TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              Text(
                "$datetime",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(
                height: 40.0,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 20.0,
                        letterSpacing: .6,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  description,
                  style: const TextStyle(wordSpacing: 1.0, letterSpacing: .6),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
