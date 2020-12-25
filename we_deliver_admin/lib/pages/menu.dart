import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;
import 'package:we_deliver_admin/core/admin.dart';
import 'package:we_deliver_admin/core/food.dart';
import 'package:we_deliver_admin/smallpages/addfoodscreen.dart';
import 'package:we_deliver_admin/smallpages/updatefoodscreen.dart';

double perpage = 1;

class Menu extends StatefulWidget {
  final Admin admin;

  const Menu({Key key, this.admin}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  double screenHeight, screenWidth;
  List foodList;
  String titlecenter = "Loading Foods...";
  String type = "Food";

  @override
  void initState() {
    super.initState();
    _loadFoods(type);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
            appBar: AppBar(
              title:
                  Text('FOOD MENU', style: TextStyle(color: Color(0xFF030303))),
              brightness: Brightness.light,
              elevation: 0,
              backgroundColor: Colors.yellowAccent,
              centerTitle: true,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.yellowAccent,
                ),
                onPressed: () {},
              ),
            ),
            floatingActionButton: SpeedDial(
              animatedIcon: AnimatedIcons.menu_close,
              backgroundColor: Colors.yellow,
              children: [
                SpeedDialChild(
                    backgroundColor: Colors.yellowAccent,
                    child: Icon(
                      Icons.fastfood,
                      color: Colors.black,
                    ),
                    label: "Add Food",
                    labelBackgroundColor: Colors.yellowAccent,
                    onTap: _newFoodScreen),
              ],
            ),
            body: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                IconButton(
                  icon: Icon(Icons.food_bank),
                  iconSize: 32,
                  onPressed: () {
                    setState(() {
                      type = "Food";
                      _loadFoods(type);
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.emoji_food_beverage),
                  iconSize: 32,
                  onPressed: () {
                    setState(() {
                      type = "Beverage";
                      _loadFoods(type);
                    });
                  },
                ),
              ]),
              Divider(
                color: Colors.grey,
              ),
              Flexible(
                child: ListView.builder(
                    //Step 6: Count the data
                    itemCount: foodList == null ? 1 : foodList.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Container();
                      }
                      if (index == foodList.length && perpage > 1) {
                        return Container(
                          width: 250,
                          color: Colors.yellow[300],
                          child: MaterialButton(
                            child: Text(
                              "Load More",
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: () {},
                          ),
                        );
                      }
                      index -= 1;
                      return Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Card(
                          color: Colors.yellowAccent,
                          elevation: 1,
                          child: InkWell(
                            onTap: () => _loadFoodDetails(index),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      height: screenHeight / 5,
                                      width: screenWidth / 2.5,
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "https://itschizo.com/wedeliver/foodimages/${foodList[index]['imgname']}.jpg",
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            new CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            new Icon(
                                          Icons.broken_image,
                                          size: screenWidth / 2,
                                        ),
                                      )),
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                              foodList[index]['foodname']
                                                  .toString()
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(height: 5),
                                          Text(
                                              "RM " +
                                                  foodList[index]['foodprice'] +
                                                  " | Qty: " +
                                                  foodList[index]['foodqty'],
                                              style: TextStyle(fontSize: 16)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text("Description: ",
                                                  style:
                                                      TextStyle(fontSize: 16)),
                                              /*Text(
                                                foodList[index]['status'],
                                              ),*/
                                              /*IconButton(
                                                icon: Icon(Icons.check),
                                                iconSize: 16,
                                                onPressed: () {
                                                  setState(() {});
                                                },
                                              ),*/
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Text(foodList[index]['fooddesc'],
                                              style: TextStyle(fontSize: 14)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ])));
  }

  void _loadFoods(String ftype) {
    http.post("https://itschizo.com/wedeliver/php/load_foods.php", body: {
      "adminid": widget.admin.adminid,
      "type": ftype,
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        foodList = null;
        setState(() {
          titlecenter = "No $type Available";
        });
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          foodList = jsondata["foods"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  _loadFoodDetails(int index) async {
    Food curfood = new Food(
        foodid: foodList[index]['foodid'],
        foodname: foodList[index]['foodname'],
        foodprice: foodList[index]['foodprice'],
        foodqty: foodList[index]['foodqty'],
        fooddesc: foodList[index]['fooddesc'],
        foodimg: foodList[index]['imgname'],
        adminid: widget.admin.adminid);

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => UpdateFoodScreen(
                  food: curfood,
                )));
    _loadFoods(type);
  }

  Future<void> _newFoodScreen() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => AddFoodScreen(
                  admin: widget.admin,
                )));
    _loadFoods(type);
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: new Text(
              'Are you sure?',
              style: TextStyle(
                  //color: Colors.white,
                  ),
            ),
            content: new Text(
              'Do you want to exit an App',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Text(
                    "Exit",
                    style: TextStyle(
                        //color: Color.fromRGBO(101, 255, 218, 50),
                        ),
                  )),
              MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        //color: Color.fromRGBO(101, 255, 218, 50),
                        ),
                  )),
            ],
          ),
        ) ??
        false;
  }
}
