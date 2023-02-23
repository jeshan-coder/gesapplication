import 'dart:io';

class Updatestate {}

class Initialstate extends Updatestate {}

class Initialimagestate extends Updatestate {}

//pickimagestate
class Changeimagestate extends Updatestate {
  String message;
  Changeimagestate(this.message);
}

class Progressimagestate extends Updatestate {
  File file;
  Progressimagestate(this.file);
}

class Submitimagestate extends Updatestate {
  File file;
  Submitimagestate(this.file);
}

class Submitimagefinalstate extends Updatestate {}

//other information state
class Otherinfoinitialstate extends Updatestate {}

class Otherinfochangestate extends Updatestate {
  String message;
  Otherinfochangestate(this.message);
}

class Otherinforeadystate extends Updatestate {
  String message;
  Otherinforeadystate(this.message);
}

class Otherinfosubmitstate extends Updatestate {}

class Otherinfoprogressstate extends Updatestate {}

class Otherinfofinalstate extends Updatestate {}

// Aboutyourself state
class Aboutyourselfchangestate extends Updatestate {
  String message;
  Aboutyourselfchangestate(this.message);
}

class Aboutyourselfreadystate extends Updatestate {
  String message;
  Aboutyourselfreadystate(this.message);
}

//submit to firebase state
class Submittofirebasesuccessstate extends Updatestate {
  String message;
  Submittofirebasesuccessstate(this.message);
}

class Submitfirebaseprogressstate extends Updatestate {}

class Submittofirebaseerrorstate extends Updatestate {
  String message;
  Submittofirebaseerrorstate(this.message);
}
