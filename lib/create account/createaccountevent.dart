class Createevent {
  String gmail;
  String password;
  String confirmpassword;
  Createevent(this.gmail, this.password, this.confirmpassword);
}

class Initialevent extends Createevent {
  Initialevent(super.gmail, super.password, super.confirmpassword);
}

class Changeevent extends Createevent {
  Changeevent(super.gmail, super.password, super.confirmpassword);
}

class Submitevent extends Createevent {
  Submitevent(super.gmail, super.password, super.confirmpassword);
}
