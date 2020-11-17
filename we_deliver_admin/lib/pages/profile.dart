import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:we_deliver_admin/core/admin.dart';
import 'package:we_deliver_admin/pages/login.dart';
import 'package:we_deliver_admin/pages/order.dart';
import 'package:we_deliver_admin/pages/mainscreen.dart';
import 'package:we_deliver_admin/pages/register.dart';
import 'package:we_deliver_admin/widgets/list.dart';

String urlgetuser = "http://itschizo.com/aidil_qayyum/srs2/php/admin/get_admin.php";
int number = 0;
class Profile extends StatefulWidget{
  final Admin admin;

  Profile({Key key, this.admin});
  
  @override
  _ProfileState createState() => _ProfileState();
}
 
class _ProfileState extends State<Profile> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress = "Searching current location...";

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    _getCurrentLocation();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "PROFILE",
                style: TextStyle(
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 120.0,
                    width: 120.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.0),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 3.0,
                            offset: Offset(0, 4.0),
                            color: Colors.black38),
                      ],
                      image: new DecorationImage(
                         fit: BoxFit.cover,
                         image: new NetworkImage(
                             "http://itschizo.com/aidil_qayyum/srs2/profile/${widget.admin.email}.jpg?dummy=${(number)}'"),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(widget.admin.name?.toUpperCase() ?? 'Not register',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(widget.admin.phone ?? 'Not register',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey),
                      ),
                      SizedBox(height: 20.0),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                "Account",
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              Card(
                elevation: 3.0,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      CustomListTile(
                        icon: Icons.email,
                        text: widget.admin.email ?? 'Not register',
                      ),
                      Divider(
                        height: 10.0,
                        color: Colors.grey,
                      ),
                      Center(
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                           Icons.location_on,
                           color: Colors.yellow,),
                          SizedBox(width: 20,),
                          Flexible(
                             child: Text(_currentAddress),                             
                          ),
                        ],
                       ),
                      ),
                      Divider(
                        height: 10.0,
                        color: Colors.grey,
                      ),
                      CustomListTile(
                        icon: Icons.payment,
                        text: "Payment",
                      ),
                      Divider(
                        height: 10.0,
                        color: Colors.grey,
                      ),
                      CustomListTile(
                        icon: Icons.edit,
                        text: "Edit Profile",
                      ),
                      Divider(
                        height: 10.0,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                "Other",
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        MaterialButton(
                          onPressed: _gotologinPage,
                          child:Text("Login",
                          style: TextStyle(
                            fontSize: 20.0)
                          )),
                        // SizedBox(height: 10.0,),
                        Divider(
                          height: 30.0,
                          color: Colors.grey,
                        ),
                        MaterialButton(
                          onPressed: _gotoRegisterPage,
                          child:Text("Register",
                          style: TextStyle(
                            fontSize: 20.0)
                          )),
                        // SizedBox(height: 10.0,),
                        Divider(
                          height: 30.0,
                          color: Colors.grey,
                        ),
                        MaterialButton(                          
                          onPressed: (){},                          
                          child:Text("Logout",                          
                          style: TextStyle(
                            fontSize: 18.0),
                          )),
                        // SizedBox(height: 10.0,),
                        Divider(
                          height: 30.0,
                          color: Colors.grey,
                        ),
                        MaterialButton(
                          onPressed: (){},
                          child:Text("Exit      ",
                          style: TextStyle(
                            fontSize: 18.0)
                          )),
                        // SizedBox(height: 10.0,),
                        Divider(
                          height: 30.0,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _gotologinPage() {
    // flutter defined function
    //print(widget.user.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Go to login page?"), //+ widget.user.name),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()));
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void _gotoRegisterPage() {
    // flutter defined function
    //print(widget.user.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Go to register page?"), //+ widget.user.name),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => RegisterScreen()));
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _getCurrentLocation() async {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        print(_currentPosition);
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }
  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name},${place.locality}, ${place.postalCode}, ${place.country}";
        //load data from database into list array 'data'
      });
    } catch (e) {
      print(e);
    }
  }
}