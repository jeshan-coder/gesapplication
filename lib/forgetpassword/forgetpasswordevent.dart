class Passwordevent {}

class Passwordchangeevent extends Passwordevent {
  String gmail;
  Passwordchangeevent(this.gmail);
}

class Passwordsubmitevent extends Passwordevent {
  String gmail;
  Passwordsubmitevent(this.gmail);
}
