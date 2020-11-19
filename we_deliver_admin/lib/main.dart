import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:we_deliver_admin/core/admin.dart';
import 'package:we_deliver_admin/pages/mainscreen.dart';

String _email, _password;
String urlLogin =
    "https://itschizo.com/aidil_qayyum/srs2/php/admin/login_admin.php";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.yellow));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/srs3.png',
                scale: 3,
              ),
              SizedBox(
                height: 20,
              ),
              new ProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

class ProgressIndicator extends StatefulWidget {
  @override
  _ProgressIndicatorState createState() => new _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          if (animation.value > 0.99) {
            //print('Sucess Login');
            loadpref(this.context);
          }
        });
      });
    controller.repeat();
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Container(
      child: CircularProgressIndicator(),
    ));
  }
}

void loadpref(BuildContext ctx) async {
  print('Inside loadpref()');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  _email = (prefs.getString('email') ?? '');
  _password = (prefs.getString('pass') ?? '');
  print("Splash:Preference");
  print(_email);
  print(_password);
  if (_isEmailValid(_email ?? "no email")) {
    //try to login if got email;
    _onLogin(_email, _password, ctx);
  } else {
    //login as unregistered user
    Admin admin = new Admin(
        name: "not register", email: "user@noregister", phone: "not register");
    Navigator.push(
        ctx, MaterialPageRoute(builder: (context) => MainScreen(admin: admin)));
  }
}

bool _isEmailValid(String email) {
  return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
}

void _onLogin(String email, String pass, BuildContext ctx) {
  http.post(urlLogin, body: {
    "email": _email,
    "password": _password,
  }).then((res) {
    print(res.statusCode);
    var string = res.body;
    List dres = string.split(",");
    print("SPLASH:loading");
    print(dres);
    if (dres[0] == "success") {
      Admin admin = new Admin(name: dres[1], email: dres[2], phone: dres[3]);
      Navigator.push(ctx,
          MaterialPageRoute(builder: (context) => MainScreen(admin: admin)));
    } else {
      //allow login as unregistered user
      Admin admin = new Admin(
          name: "not register",
          email: "user@noregister",
          phone: "not register");
      Navigator.push(ctx,
          MaterialPageRoute(builder: (context) => MainScreen(admin: admin)));
    }
  }).catchError((err) {
    print(err);
  });
}
