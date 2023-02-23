class Createstate {}

class Initialstate extends Createstate {}

class Errorstate extends Createstate {
  String message;
  Errorstate(this.message);
}

class Noerrorstate extends Createstate {
  String message;
  Noerrorstate(this.message);
}

class Successprocessstate extends Createstate {}

class Successcompletestate extends Createstate {
  String message;
  Successcompletestate(this.message);
}
