import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:we_deliver_admin/pages/login.dart';

String pathAsset = 'assets/images/profile.jpg';
String urlUpload = "https://itschizo.com/wedeliver/php/register_admin.php";
File _image;
final TextEditingController _namecontroller = TextEditingController();
final TextEditingController _emcontroller = TextEditingController();
final TextEditingController _passcontroller = TextEditingController();
final TextEditingController _phcontroller = TextEditingController();
final TextEditingController _radcontroller = TextEditingController();
final TextEditingController _delcontroller = TextEditingController();

double screenHeight, screenWidth, latitude, longitude;
String _name, _email, _password, _phone;
String gmaploc = "";
Position _currentPosition;

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
  const RegisterScreen({Key key, File image}) : super(key: key);
}

class _RegisterUserState extends State<RegisterScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          brightness: Brightness.light,
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: _onBackPressAppBar,
          )),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
          child: RegisterWidget(),
        ),
      ),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    _image = null;
    Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(
              //admin: widget.admin,
              ),
        ));
    return Future.value(false);
  }
}

class RegisterWidget extends StatefulWidget {
  @override
  RegisterWidgetState createState() => RegisterWidgetState();
}

class RegisterWidgetState extends State<RegisterWidget> {
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
              child: Text(
                'Registeration',
                style: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      GestureDetector(
          onTap: _choose,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: _image == null
                      ? AssetImage(pathAsset)
                      : FileImage(_image),
                  fit: BoxFit.fill,
                )),
          )),
      Text(
        'Click on image above to take profile picture',
      ),
      Container(
          padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _namecontroller,
                decoration: InputDecoration(
                    labelText: 'NAME',
                    icon: Icon(Icons.person),
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.grey),
                    // hintText: 'EMAIL',
                    // hintStyle: ,
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow))),
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: _emcontroller,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelText: 'EMAIL',
                    icon: Icon(Icons.email),
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow))),
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: _passcontroller,
                decoration: InputDecoration(
                    labelText: 'PASSWORD ',
                    icon: Icon(Icons.lock),
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow))),
                obscureText: true,
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: _phcontroller,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    labelText: 'PHONE NUMBER',
                    icon: Icon(Icons.phone),
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow))),
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: _radcontroller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Radius (KM)',
                    icon: Icon(Icons.map_rounded),
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow))),
              ),
              TextField(
                controller: _delcontroller,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    labelText: 'Delivery Charge Per KM',
                    icon: Icon(Icons.delivery_dining),
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow))),
              ),
              SizedBox(height: 10.0),
              Container(
                  height: 30,
                  child: Row(
                    children: [
                      GestureDetector(
                        child: Icon(Icons.location_on),
                        onTap: _searchCurLoc,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(gmaploc),
                    ],
                  )),
              SizedBox(height: 40.0),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                minWidth: 300,
                height: 50,
                child: Text('Register',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    )),
                color: Colors.yellow,
                splashColor: Colors.blueGrey,
                textColor: Colors.black,
                elevation: 7.0,
                onPressed: _onRegister,
              ),
              SizedBox(height: 10),
              GestureDetector(
                  onTap: _onLogin,
                  child:
                      Text('Already register', style: TextStyle(fontSize: 16))),
              /*Container(
                      height: 40.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: AppColors.yellowColor,
                        color: AppColors.yellowLightColor,
                        elevation: 7.0,
                        child: GestureDetector(
                          on: _onRegister,
                          child: Center(
                            child: Text(
                              'REGISTER',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      )),*/
            ],
          )),
      SizedBox(height: 20.0),
    ]);
  }

  void _choose() async {
    // ignore: deprecated_member_use
    //_image = await ImagePicker.pickImage(source: ImageSource.camera);
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No Image');
      }
    });
  }

  void _onLogin() {
    // Navigator.pushReplacement(context,
    //     MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
    Navigator.pop(context);
  }

  void _onRegister() {
    print('onRegister Button from RegisterUser()');
    print(_image.toString());
    uploadData();
  }

  Future<void> uploadData() async {
    _name = _namecontroller.text;
    _email = _emcontroller.text;
    _password = _passcontroller.text;
    _phone = _phcontroller.text;
    print(_image);
    if ((_isEmailValid(_email)) &&
        (_password.length > 5) &&
        (_image != null) &&
        (_phone.length > 5)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Registration in progress");
      await pr.show();

      String base64Image = base64Encode(_image.readAsBytesSync());
      http.post(urlUpload, body: {
        "encoded_string": base64Image,
        "name": _name,
        "email": _email,
        "password": _password,
        "phone": _phone,
        "delivery": _delcontroller.text,
        "radius": _radcontroller.text,
        "latitude": _currentPosition.latitude.toString(),
        "longitude": _currentPosition.longitude.toString(),
      }).then((res) {
        print(res.body);
        if (res.body == "success") {
          Toast.show(
              "Registration success. An email has been sent to .$_email. Please check your email for verification. Also check in your spam folder.",
              context,
              duration: Toast.LENGTH_LONG,
              gravity: Toast.BOTTOM);
          _image = null;
          savepref(_email, _password);
          _namecontroller.text = '';
          _emcontroller.text = '';
          _phcontroller.text = '';
          _passcontroller.text = '';
          pr.hide();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginPage()));
        }
      }).catchError((err) {
        print(err);
      });
    } else {
      Toast.show("Check your registration information", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }
  /*ProgressDialog pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false);
    await pr.show();

    _name = _namecontroller.text;
    _email = _emcontroller.text;
    _password = _passcontroller.text;
    _phone = _phcontroller.text;
    print(_image);
    if ((_image == null) ||
        (!_isEmailValid(_email)) ||
        (_password.length < 5) ||
        (_phone.length < 5)) {
      Toast.show("Invalid Registration Data", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      return;
    }
    String base64Image = base64Encode(_image.readAsBytesSync());
    http.post(urlUpload, body: {
      "encoded_string": base64Image,
      "name": _name,
      "email": _email,
      "password": _password,
      "phone": _phone,
    }).then((res) {
      print(res.statusCode);
      print(res.body);
      _image = null;
      _namecontroller.text='';
      _emcontroller.text = '';
      _phcontroller.text = '';
      _passcontroller.text = '';
      Toast.show(res.body, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
    }).catchError((err) {
      print(err);
    });
   await pr.hide();
  }*/

  bool _isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  void savepref(String email, String pass) async {
    print('Inside savepref');
    _email = _emcontroller.text;
    _password = _passcontroller.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //true save pref
    await prefs.setString('email', email);
    await prefs.setString('pass', pass);
    print('Save pref $_email');
    print('Save pref $_password');
  }

  _searchCurLoc() {
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
      geolocator
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((Position position) {
        setState(() {
          _currentPosition = position;
          print("GEOLOCATOR");
          if (_currentPosition != null) {
            print(gmaploc);
            gmaploc = _currentPosition.latitude.toString() +
                "/" +
                _currentPosition.longitude.toString();
          }
        });
      }).catchError((e) {
        print(e);
      });
    } catch (exception) {
      print(exception.toString());
    }
  }
}
