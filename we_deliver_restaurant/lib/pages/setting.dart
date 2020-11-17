import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:we_deliver_restaurant/core/user.dart';
import 'package:we_deliver_restaurant/pages/profile.dart';

class Setting extends StatefulWidget{
  final User user;

  Setting({Key key, this.user});
  
  @override
  _SettingState createState() => _SettingState();

}
 
class _SettingState extends State<Setting> {
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
        title: Text('EDIT PROFILE',
        style: TextStyle(color: Color(0xFF030303),
        fontSize: 25,
        fontFamily: 'Montserrat')),
        brightness: Brightness.light,
        elevation: 0,
        backgroundColor: Colors.yellow,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
              color: Colors.black,
          ),
          onPressed: _onBackPressAppBar),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20.0,
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
                      ListTile(
                        leading: Icon(Icons.person,
                        color: Colors.yellow,),
                        trailing: Icon(Icons.arrow_right,
                        color: Colors.black,),
                        title: Text( widget.user.name?.toUpperCase() ?? 'Not register',
                        style: TextStyle(fontSize: 20.0)),
                        onTap: (){},
                      ),
                      Divider(
                        height: 0.0,
                        color: Colors.grey,
                      ),
                      ListTile(
                        leading: Icon(Icons.phone_android,
                        color: Colors.yellow,),
                        trailing: Icon(Icons.arrow_right,
                        color: Colors.black,),
                        title: Text(widget.user.phone ?? 'Not register',
                        style: TextStyle(fontSize: 20.0)),
                      ),
                      Divider(
                        height: 0.0,
                        color: Colors.grey,
                      ),
                      ListTile(
                        leading: Icon(Icons.email,
                        color: Colors.yellow,),
                        trailing: Icon(Icons.arrow_right,
                        color: Colors.black,),
                        title: Text(widget.user.email ?? 'Not register',
                        style: TextStyle(fontSize: 20.0)),
                      ),
                      Divider(
                        height: 10.0,
                        color: Colors.grey,
                      ),
                      ListTile(
                        leading: Icon(Icons.location_on,
                        color: Colors.yellow,),
                        trailing: Icon(Icons.arrow_right,
                        color: Colors.black,),
                        title: Text(_currentAddress,
                        style: TextStyle(fontSize: 20.0)),                            
                      ),
                      Divider(
                        height: 10.0,
                        color: Colors.grey,
                      ),
                      ListTile(
                        leading: Icon(Icons.visibility,
                        color: Colors.yellow,),
                        trailing: Icon(Icons.arrow_right,
                        color: Colors.black,),
                        title: Text("Password",
                        style: TextStyle(fontSize: 20.0)),
                        onTap: (){},
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
            ],
          ),
        ),
      ),
    );
  }
  Future<bool> _onBackPressAppBar() async {
    Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => Profile(
            //user: widget.user,
          ),
        ));
    return Future.value(false);
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