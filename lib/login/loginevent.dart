class Loginevent {
  String gmail;
  String password;
  Loginevent(this.gmail, this.password);
}

class Logininitialevent extends Loginevent {
  Logininitialevent(super.gmail, super.password);
}

class Loginchangeevent extends Loginevent {
  Loginchangeevent(super.gmail, super.password);
}

class Loginsubmitevent extends Loginevent {
  Loginsubmitevent(super.gmail, super.password);
}
