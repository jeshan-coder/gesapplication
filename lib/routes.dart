import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ges/create%20account/createaccountbloc.dart';
import 'package:ges/forgetpassword/forgetpassword.dart';
import 'package:ges/forgetpassword/forgetpasswordbloc.dart';
import 'package:ges/getstarted/getstarted.dart';
import 'package:ges/login/login.dart';
import 'package:ges/login/loginbloc.dart';
import 'package:ges/services/mainpage.dart';
import 'package:ges/updateinfo/aboutyourself.dart';
import 'package:ges/updateinfo/otherinfo.dart';
import 'package:ges/updateinfo/updatebloc.dart';
import 'package:ges/updateinfo/updatescreen.dart';

var routes = {
  "/": (context) => const GetStarted(),
  "/login": (context) => MultiBlocProvider(providers: [
        BlocProvider(create: (context) => LoginBloc()),
        BlocProvider(create: (context) => CreateBloc())
      ], child: Login()),
  "/resetpassword": (context) => BlocProvider(
      create: (context) => ForgetpasswordBloc(), child: Forgetpassword()),
  "/updateinfo": (context) => BlocProvider(
        create: (context) => UpdateBloc(),
        child: Updatescreen(),
      ),
  "/otherinfo": (context) => BlocProvider(
        create: (context) => UpdateBloc(),
        child: Otherinfo(),
      ),
  "/yourself": (context) => BlocProvider(
        create: (context) => UpdateBloc(),
        child: Yourself(),
      ),
  "/mainpage": (context) => const MainPage(),
};
