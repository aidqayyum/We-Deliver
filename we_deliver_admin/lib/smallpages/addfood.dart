import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:toast/toast.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:we_deliver_admin/core/admin.dart';
import 'package:we_deliver_admin/pages/mainscreen.dart';
import 'package:we_deliver_admin/pages/menu.dart';

File _image;
String pathAsset = 'assets/images/add.png';
String urlUpload = "https://itschizo.com/aidil_qayyum/srs2/php/upload_food.php";
String urlgetadmin = "https://itschizo.com/aidil_qayyum/srs2/php/get_admin.php";

TextEditingController _foodcontroller = TextEditingController();
final TextEditingController _pricecontroller = TextEditingController();
final TextEditingController _desccontroller = TextEditingController();
//final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
//Position _currentPosition;
//String _currentAddress = "Searching your current location...";

class AddFood extends StatefulWidget {
  final Admin admin;

  AddFood({Key key, this.admin});

  @override
  _AddFoodState createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('ADD MENU', style: TextStyle(color: Color(0xFF030303))),
          brightness: Brightness.light,
          elevation: 0,
          backgroundColor: Colors.yellow,
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: _onBackPressAppBar),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
            child: AddNewMenu(widget.admin),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => Menu(
            admin: widget.admin,
          ),
        ));
    return Future.value(false);
  }
}

class AddNewMenu extends StatefulWidget {
  final Admin admin;
  AddNewMenu(this.admin);

  @override
  _AddNewMenuState createState() => _AddNewMenuState();
}

class _AddNewMenuState extends State<AddNewMenu> {
  final picker = ImagePicker();
  String defaultValue = 'Pickup';
  @override
  void initState() {
    super.initState();
    //_getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
            onTap: _choose,
            child: Container(
              width: 220,
              height: 250,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image:
                    _image == null ? AssetImage(pathAsset) : FileImage(_image),
                fit: BoxFit.fill,
              )),
            )),
        SizedBox(height: 10.0),
        Text('Click on image above to take picture'),
        TextField(
            controller: _foodcontroller,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: "Food Name",
              icon: Icon(Icons.restaurant_menu),
            )),
        TextField(
            controller: _pricecontroller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Food Price",
              icon: Icon(Icons.attach_money),
            )),
        TextField(
          controller: _desccontroller,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: "Food Description",
            icon: Icon(Icons.info_outline),
          ),
        ),
        SizedBox(height: 20.0),
        MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            minWidth: 400,
            height: 50,
            child: Text(
              "Add Food",
              style: new TextStyle(fontSize: 18.0, color: Colors.black),
            ),
            color: Colors.yellow,
            //textColor: Colors.black,
            elevation: 10,
            onPressed: _onAddMenu),
      ],
    );
  }

  Future _choose() async {
    /*// ignore: deprecated_member_use
    //_image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {});
    // ignore: deprecated_member_use
    //_image = await ImagePicker.pickImage(source: ImageSource.gallery);*/
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No Image');
      }
    });
  }

  void _onAddMenu() {
    if (_image == null) {
      Toast.show("Please take picture", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (_foodcontroller.text.isEmpty) {
      Toast.show("Please enter food name", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (_pricecontroller.text.isEmpty) {
      Toast.show("Please enter food price", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (_desccontroller.text.isEmpty) {
      Toast.show("Please enter food description", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Adding...");
    pr.show();
    String base64Image = base64UrlEncode(_image.readAsBytesSync());

    http.post(urlUpload, body: {
      "encoded_string": base64Image,
      "email": widget.admin.email,
      "fname": _foodcontroller.text,
      "fprice": _pricecontroller.text,
      "fdesc": _desccontroller.text
    }).then((res) {
      print(res.body);
      Toast.show(res.body, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      if (res.body.contains("success")) {
        _image = null;
        _foodcontroller.text = "";
        _pricecontroller.text = "";
        _desccontroller.text = "";
        pr.hide();
        print(widget.admin.email);
        _onLogin(widget.admin.email, context);
      } else {
        pr.hide();
        Toast.show(res.body + ". Please reload", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.hide();
    });
  }

  void _onLogin(String email, BuildContext ctx) {
    http.post(urlgetadmin, body: {
      "email": email,
    }).then((res) {
      print(res.statusCode);
      var string = res.body;
      List dres = string.split(",");
      print(dres);
      if (dres[0] == "success") {
        Admin admin = new Admin(name: dres[1], email: dres[2], phone: dres[3]);
        Navigator.push(ctx,
            MaterialPageRoute(builder: (context) => MainScreen(admin: admin)));
      }
    }).catchError((err) {
      print(err);
    });
  }
}
