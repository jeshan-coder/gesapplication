// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../color and text/style.dart';
import '../../navigators.dart';
import '../blogs/addblog.dart';
import '../services/addfile.dart';
import '../services/blogs.dart';
import '../services/digitallibrary.dart';
import '/screens/services/people.dart';
import '/screens/services/updateabout.dart';

import '../login/login.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  List<String> titles = ['Blogs', 'Library', 'People'];
  String title = 'Blogs';
  List<Widget> screens = [
    const Blogs(),
    const DigitalLibrary(),
    const People()
  ];
  Widget currentscreen = const Blogs();
  final currentuser = FirebaseAuth.instance.currentUser;
  final storage = FlutterSecureStorage();
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      title = titles[index];
      currentscreen = screens[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          backgroundColor: Colors.white,
          child: FutureBuilder<DocumentSnapshot>(
            future: users.doc(currentuser!.uid).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Something went wrong",
                    style: Userstyle.textstyle,
                  ),
                );
              }

              if (snapshot.hasData && !snapshot.data!.exists) {
                return Center(
                  child: Text(
                    "Document does not exist",
                    style: Userstyle.textstyle,
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                return ListView(

                    // Important: Remove any padding from the ListView.
                    padding: const EdgeInsets.all(10.0),
                    children: [
                      DrawerHeader(
                        child: Center(
                          child: ClipOval(
                              child: Image.network(
                            data['photoURL'],
                            fit: BoxFit.cover,
                            width: 100.0,
                            height: 100.0,
                          )),
                        ),
                      ),
                      Text(
                        data['name'],
                        style: Userstyle.textstyle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        data['institution'],
                        textAlign: TextAlign.center,
                        style: Userstyle.subtitletilestyle,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(data['email'],
                          textAlign: TextAlign.center,
                          style: Userstyle.subtitletilestyle),
                      const Divider(
                        color: Colors.grey,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            const UpdateYourself())));
                              },
                              icon: const Icon(Icons.edit))
                        ],
                      ),
                      Text(data['about'],
                          textAlign: TextAlign.center,
                          style: Userstyle.subtitletilestyle),
                      const SizedBox(
                        height: 10.0,
                      ),
                      const Divider(
                        color: Colors.grey,
                      ),
                      TextButton(
                          onPressed: () {
                            logout();
                            notification(context, "Sucessfully Logout");
                          },
                          child: Text(
                            "Logout",
                            style: Userstyle.textbuttomstyle,
                          )),
                      const SizedBox(
                        height: 40.0,
                      ),
                      const Divider(
                        color: Colors.grey,
                      ),
                      Text(
                        "Project Contributors",
                        style: Userstyle.textstyle,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Jeshan Pokharel",
                        style: Userstyle.subtitletilestyle,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "jeshanpokharel123@gmail.com",
                        style: Userstyle.subtitletilestyle,
                        textAlign: TextAlign.center,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.phone,
                            size: 10.0,
                            color: Colors.grey,
                          ),
                          Text(
                            "9841167068",
                            style: Userstyle.subtitletilestyle,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "Cecil Ghimire",
                        style: Userstyle.subtitletilestyle,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "cecilghimire@gmail.com",
                        style: Userstyle.subtitletilestyle,
                        textAlign: TextAlign.center,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.phone,
                            size: 10.0,
                            color: Colors.grey,
                          ),
                          Text(
                            "9862342132",
                            style: Userstyle.subtitletilestyle,
                          ),
                        ],
                      ),
                    ]);
              }

              return const Center(
                child: CircularProgressIndicator(color: Colors.black),
              );
            },
          )),
      floatingActionButton: button(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: UserColor.backgroundcolor,
        // leading: ClipRRect(
        //   borderRadius: BorderRadius.circular(25.0),
        //   child: InkWell(
        //     onTap: () {},
        //     child: Image.asset(
        //       'user.png',
        //       height: 50.0,
        //       width: 50.0,
        //       fit: BoxFit.cover,
        //     ),
        //   ),
        // ),
        title: Text(
          title,
          style: Userstyle.headerstyle,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        selectedIconTheme: const IconThemeData(color: Colors.black),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notes,
            ),
            label: 'Blogs',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.book,
            ),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.people,
            ),
            label: 'People',
          ),
        ],
      ),
      body: currentscreen,
    );
  }

  Widget? button() {
    if (_selectedIndex == 0) {
      return FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => const AddBlog())));
        },
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      );
    }
    if (_selectedIndex == 1) {
      return FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => const AddFile())));
        },
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      );
    } else {
      return null;
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut().then((value) async {
      await storage.delete(key: 'uid');
      navigatorpushandremove(context, const Login());
    });
  }
}
