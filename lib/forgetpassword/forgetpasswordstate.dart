class Forgetpasswordstate {}

class Initialstate extends Forgetpasswordstate {}

class Passwordchangestate extends Forgetpasswordstate {
  String message;
  Passwordchangestate(this.message);
}

class Passwordprogressstate extends Forgetpasswordstate {
  String message;
  Passwordprogressstate(this.message);
}

class Passwordreadystate extends Forgetpasswordstate {
  String message;
  Passwordreadystate(this.message);
}

class Passwordsubmitstate extends Forgetpasswordstate {
  String message;
  Passwordsubmitstate(this.message);
}
