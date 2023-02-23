import 'package:firebase_auth/firebase_auth.dart';

class Verifyemailevent {}

class Initialevent extends Verifyemailevent {}

class Checkverified extends Verifyemailevent {
  UserCredential credential;
  Checkverified(this.credential);
}

class Sendlinkevent extends Verifyemailevent {}

class Verifiedlinkevent extends Verifyemailevent {}
