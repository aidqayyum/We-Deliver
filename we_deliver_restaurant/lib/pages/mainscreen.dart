import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:we_deliver_restaurant/core/food.dart';
import 'package:we_deliver_restaurant/core/user.dart';
import 'package:we_deliver_restaurant/pages/foodscreen.dart';

import 'package:we_deliver_restaurant/pages/profile.dart';
import 'package:we_deliver_restaurant/pages/shoppingcartscreen.dart';

String urlgetuser = "https://itschizo.com/wedeliver/php/get_user.php";
int number = 0;

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  List foodList;
  double screenHeight, screenWidth;
  String titlecenter = "Loading Food...";
  String type = "Food";

  @override
  void initState() {
    super.initState();
    _loadFoods(type);
    refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        brightness: Brightness.light,
        elevation: 0,
        title: Text(
          'Home',
          style: TextStyle(color: Color(0xFF000000)),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.black,
            ),
            onPressed: () {
              _shoppingCartScreen();
            },
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(1.0, 23, 0.0, 1.0),
          children: <Widget>[
            new UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.yellowAccent),
                currentAccountPicture: new CircleAvatar(
                    radius: 60.0,
                    backgroundColor: const Color(0xFF778899),
                    backgroundImage: NetworkImage(
                        "https://itschizo.com/wedeliver/profile/${widget.user.email}.jpg?dummy=${(number)}'")),
                accountName: Text(
                    widget.user.name?.toUpperCase() ?? 'Not register',
                    style: TextStyle(fontSize: 16, color: Colors.black)),
                accountEmail: Text(widget.user.email,
                    style: TextStyle(fontSize: 16, color: Colors.black))),
            ListTile(
                leading: Icon(Icons.shopping_cart),
                title: Text("Order"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShoppingCartScreen(
                                user: widget.user,
                              )));
                }),
            ListTile(
                leading: Icon(Icons.payments_rounded),
                title: Text("Payment"),
                onTap: () {
                  Navigator.of(context).pop();
                }),
            ListTile(
                leading: Icon(Icons.person),
                title: Text("Profile"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Profile(
                                user: widget.user,
                              )));
                }),
            Container(
                child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                  child: Column(
                children: <Widget>[
                  Divider(),
                  ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Settings'),
                      onTap: () {
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                      leading: Icon(Icons.help),
                      title: Text('Help and Feedback'),
                      onTap: () {
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                      leading: Icon(Icons.transit_enterexit),
                      title: Text('Logout'),
                      onTap: () {
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                      leading: Icon(Icons.exit_to_app),
                      title: Text('Exit'),
                      onTap: () {
                        Navigator.of(context).pop();
                      }),
                ],
              )),
            ))
          ],
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
            ],
          ),
          Container(),
          foodList == null
              ? Flexible(
                  child: Container(
                      child: Center(
                          child: Text(
                  titlecenter,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ))))
              : Flexible(
                  child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: (screenWidth / screenHeight) / 0.7,
                  children: List.generate(foodList.length, (index) {
                    return Padding(
                        padding: EdgeInsets.all(8),
                        child: Card(
                          child: InkWell(
                            onTap: () => _loadFoodDetails(index),
                            child: Column(
                              children: [
                                Container(
                                    height: screenHeight / 4.5,
                                    width: screenWidth / 1.2,
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
                                SizedBox(height: 8),
                                Text(
                                  foodList[index]['foodname'],
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                //SizedBox(height: 8),
                                Text("RM " + foodList[index]['foodprice']),
                                //Text(foodList[index]['fdesc']),
                                Text("Quantity: " + foodList[index]['foodqty']),
                              ],
                            ),
                          ),
                        ));
                  }),
                ))
        ],
      ),
    );
  }

  void _shoppingCartScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                ShoppingCartScreen(user: widget.user)));
  }

  void _loadFoods(String ftype) {
    http.post("https://itschizo.com/wedeliver/php/load_foods.php", body: {
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

  _loadFoodDetails(int index) {
    Food curfood = new Food(
        foodid: foodList[index]['foodid'],
        foodname: foodList[index]['foodname'],
        foodprice: foodList[index]['foodprice'],
        foodqty: foodList[index]['foodqty'],
        foodimg: foodList[index]['imgname'],
        fooddesc: foodList[index]['fooddesc'],
        foodcurqty: "1");

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => FoodScreenDetails(
                  food: curfood,
                  user: widget.user,
                )));
  }
}
