import 'package:firebase_auth/firebase_auth.dart';

class Loginstate {}

class Logininitialstate extends Loginstate {}

class Loginchangestate extends Loginstate {
  String message;
  Loginchangestate(this.message);
}

class Loginsubmitstate extends Loginstate {
  UserCredential credential;
  Loginsubmitstate(this.credential);
}

class Progressstate extends Loginstate {}

class Firebaseerrorstate extends Loginstate {
  String message;
  Firebaseerrorstate(this.message);
}
