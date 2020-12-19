import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:we_deliver_admin/core/admin.dart';

class AddFoodScreen extends StatefulWidget {
  final Admin admin;

  const AddFoodScreen({Key key, this.admin}) : super(key: key);
  @override
  _AddFoodScreenState createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final TextEditingController _foodnamecontroller = TextEditingController();
  final TextEditingController _foodpricecontroller = TextEditingController();
  final TextEditingController _foodqtycontroller = TextEditingController();
  final TextEditingController _fooddesccontroller = TextEditingController();

  String _foodname = "";
  String _foodprice = "";
  String _foodqty = "";
  String _fooddesc = "";
  double screenHeight, screenWidth;
  File _image;
  String pathAsset = 'assets/images/add.png';
  int _radioValue = 0;
  String foodtype = "Food";

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('ADD FOOD', style: TextStyle(color: Color(0xFF030303))),
        brightness: Brightness.light,
        elevation: 0,
        backgroundColor: Colors.yellowAccent,
        centerTitle: true,
      ),
      body: Container(
          child: Padding(
              padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                        onTap: () => {_onPictureSelection()},
                        child: Container(
                          height: screenHeight / 2.9,
                          width: screenWidth / 1.6,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: _image == null
                                  ? AssetImage(pathAsset)
                                  : FileImage(_image),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(
                              width: 3.0,
                              color: Colors.yellow,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(
                                    15.0) //         <--- border radius here
                                ),
                          ),
                        )),
                    SizedBox(height: 5),
                    Text("Click image to take food picture",
                        style: TextStyle(fontSize: 15.0, color: Colors.black)),
                    SizedBox(height: 5),
                    /*Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Food"),
                        new Radio(
                          value: 0,
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange,
                        ),
                        Text("Beverage"),
                        new Radio(
                          value: 1,
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange,
                        ),
                      ],
                    ),*/
                    TextField(
                        controller: _foodnamecontroller,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            labelText: 'Food Name',
                            icon: Icon(Icons.fastfood_outlined))),
                    TextField(
                        controller: _foodpricecontroller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Food Price', icon: Icon(Icons.money))),
                    TextField(
                        controller: _fooddesccontroller,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            labelText: 'Food Description',
                            icon: Icon(Icons.description))),
                    TextField(
                        controller: _foodqtycontroller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Quantity Available',
                            icon: Icon(Icons.confirmation_num))),
                    SizedBox(height: 15),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      minWidth: 300,
                      height: 50,
                      child: Text(
                        'Add New Food',
                        style: TextStyle(fontSize: 18),
                      ),
                      color: Colors.yellowAccent,
                      textColor: Colors.black,
                      elevation: 15,
                      onPressed: newFoodDialog,
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ))),
    );
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          foodtype = "Food";
          break;
        case 1:
          foodtype = "Beverage";
          break;
      }
    });
  }

  _onPictureSelection() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            //backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: new Container(
              //color: Colors.white,
              height: screenHeight / 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Take picture from:",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                          child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 100,
                        height: 100,
                        child: Text('Camera',
                            style: TextStyle(
                              color: Colors.black,
                            )),
                        //color: Color.fromRGBO(101, 255, 218, 50),
                        color: Colors.yellowAccent,
                        textColor: Colors.black,
                        elevation: 10,
                        onPressed: () =>
                            {Navigator.pop(context), _chooseCamera()},
                      )),
                      SizedBox(width: 10),
                      Flexible(
                          child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 100,
                        height: 100,
                        child: Text('Gallery',
                            style: TextStyle(
                              color: Colors.black,
                            )),
                        //color: Color.fromRGBO(101, 255, 218, 50),
                        color: Colors.yellowAccent,
                        textColor: Colors.black,
                        elevation: 10,
                        onPressed: () => {
                          Navigator.pop(context),
                          _chooseGallery(),
                        },
                      )),
                    ],
                  ),
                ],
              ),
            ));
      },
    );
  }

  void _chooseCamera() async {
    // ignore: deprecated_member_use
    _image = await ImagePicker.pickImage(source: ImageSource.camera);
    //_cropImage();
    setState(() {});
  }

  void _chooseGallery() async {
    // ignore: deprecated_member_use
    _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    //_cropImage();
    setState(() {});
  }

  /*Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
              ]
            : [
                CropAspectRatioPreset.square,
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Resize',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }*/

  void newFoodDialog() {
    _foodname = _foodnamecontroller.text;
    _foodprice = _foodpricecontroller.text;
    _foodqty = _foodqtycontroller.text;
    _fooddesc = _fooddesccontroller.text;

    if (_foodname == "" &&
        _foodprice == "" &&
        _foodqty == "" &&
        _fooddesc == "") {
      Toast.show(
        "Fill all required fields",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Register new Food? ",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Are you sure?",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _onAddFood();
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onAddFood() {
    final dateTime = DateTime.now();
    _foodname = _foodnamecontroller.text;
    _foodprice = _foodpricecontroller.text;
    _foodqty = _foodqtycontroller.text;
    _fooddesc = _fooddesccontroller.text;
    String base64Image = base64Encode(_image.readAsBytesSync());

    http.post("https://itschizo.com/wedeliver/php/add_food.php", body: {
      "foodname": _foodname,
      "foodprice": _foodprice,
      "foodqty": _foodqty,
      "fooddesc": _fooddesc,
      //"foodtype": foodtype,
      "encoded_string": base64Image,
      "imagename": _foodname + "-${dateTime.microsecondsSinceEpoch}",
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show(
          "Success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
        Navigator.pop(context);
      } else {
        Toast.show(
          "Failed 1",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      }
    }).catchError((err) {
      print(err);
    });
  }
}
