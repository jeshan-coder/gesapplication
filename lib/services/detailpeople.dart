import 'package:flutter/material.dart';

class Detailpeople extends StatefulWidget {
  String about;
  String email;
  String institution;
  String name;
  String photoURL;
  Detailpeople(
      this.about, this.email, this.institution, this.name, this.photoURL);

  @override
  State<Detailpeople> createState() => _DetailpeopleState();
}

class _DetailpeopleState extends State<Detailpeople> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 40.0,
              ),
              Center(
                child: ClipOval(
                    child: widget.photoURL != null
                        ? Image.network(
                            widget.photoURL,
                            fit: BoxFit.cover,
                            width: 200.0,
                            height: 200.0,
                          )
                        : Image.asset('images/unspecified.png')),
              ),
              const SizedBox(
                height: 40.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    widget.name,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.email),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    widget.email,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.school),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    widget.institution,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(
                height: 50.0,
              ),
              Text(
                widget.about,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    ));
  }
}
