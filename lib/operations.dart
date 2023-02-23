import 'package:firebase_auth/firebase_auth.dart';

class Operations {
  // late var usercredential;
  // String email;
  // String password;

  static Future<UserCredential> loginuser(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        // print('Wrong password provided for that user.');
      }
    }
    throw FirebaseAuthException(code: 'user-not-found');
  }

  static Future signoutuser() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future authenticateusinglink() async {
    final currentuser = FirebaseAuth.instance.currentUser;
    try {
      if (currentuser!.emailVerified == true) {
        return true;
      } else {
        await currentuser.sendEmailVerification();
      }
    } catch (e) {
      // print("authenticationusinglink:$e");
    }
  }

  // static Future Updateusercollection() async {
  //   CollectionReference users = FirebaseFirestore.instance.collection('users');
  //   users.add();
  // }
}
