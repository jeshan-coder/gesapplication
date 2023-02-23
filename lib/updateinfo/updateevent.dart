import 'dart:io';

class Updateevent {}

class Initialevent extends Updateevent {}

class Initialimageevent extends Updateevent {}

class PickImageevent extends Updateevent {
  File file;
  PickImageevent(this.file);
}

class SubmitImageevent extends Updateevent {}

//other information event
class Otherinfoinitialevent extends Updateevent {}

class Otherinfochangeevent extends Updateevent {
  String name;
  String institution;
  String profession;
  String number;
  Otherinfochangeevent(
      this.name, this.institution, this.profession, this.number);
}

class OtherinfoSubmitevent extends Updateevent {
  String name;
  String institution;
  String profession;
  String number;
  OtherinfoSubmitevent(
      this.name, this.institution, this.profession, this.number);
}

class Otherinfosubmitevent extends Updateevent {}

class Aboutyourselfevent extends Updateevent {
  String about;
  Aboutyourselfevent(this.about);
}

class Submittofirebaseevent extends Updateevent {}
