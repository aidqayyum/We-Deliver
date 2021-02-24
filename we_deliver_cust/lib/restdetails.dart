import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'food.dart';
import 'restaurant.dart';
import 'package:http/http.dart' as http;
import 'foodscreen.dart';
import 'shoppingcartscreen.dart';
import 'user.dart';

class RestScreenDetails extends StatefulWidget {
  final Restaurant rest;
  final User user;

  const RestScreenDetails({Key key, this.rest, this.user}) : super(key: key);

  @override
  _RestScreenDetailsState createState() => _RestScreenDetailsState();
}

class _RestScreenDetailsState extends State<RestScreenDetails> {
  double screenHeight, screenWidth;
  List foodList;
  String titlecenter = "Loading Foods...";
  String type = "Food";
  GlobalKey<RefreshIndicatorState> refreshKey;

  @override
  void initState() {
    super.initState();
    _loadFoods(type);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0,
        backgroundColor: Colors.yellowAccent,
        centerTitle: true,
        title: Text(widget.rest.restname),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.black,
            ),
            onPressed: () {
              _shoppinCartScreen();
            },
          )
        ],
      ),
      body: Column(children: [
        Container(
            height: screenHeight / 4.8,
            width: screenWidth / 0.3,
            child: CachedNetworkImage(
              imageUrl:
                  "https://itschizo.com/wedeliver2/images/restaurant_images/${widget.rest.restimage}.jpg",
              fit: BoxFit.cover,
              placeholder: (context, url) => new CircularProgressIndicator(),
              errorWidget: (context, url, error) => new Icon(
                Icons.broken_image,
                size: screenWidth / 2,
              ),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.food_bank),
                  color: Colors.deepPurple,
                  iconSize: 32,
                  onPressed: () {
                    setState(() {
                      type = "Food";
                      _loadFoods(type);
                    });
                  },
                ),
                Text(
                  "Foods",
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.emoji_food_beverage),
                  color: Colors.deepPurple,
                  iconSize: 32,
                  onPressed: () {
                    setState(() {
                      type = "Drink";
                      _loadFoods(type);
                    });
                  },
                ),
                Text(
                  "Drinks",
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.phone),
                        color: Colors.deepPurple,
                        iconSize: 32,
                        onPressed: () {
                          setState(() {});
                        },
                      ),
                      Text(
                        "Call",
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.map),
                        color: Colors.deepPurple,
                        iconSize: 32,
                        onPressed: () {
                          setState(() {});
                        },
                      ),
                      Text(
                        "Map",
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
        Text("Menu for $type "),
        Divider(
          color: Colors.grey,
        ),
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
                child: RefreshIndicator(
                    key: refreshKey,
                    color: Colors.yellowAccent,
                    onRefresh: () async {
                      _loadFoods(type);
                    },
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: (screenWidth / screenHeight) / 0.62,
                      children: List.generate(foodList.length, (index) {
                        return Padding(
                            padding: EdgeInsets.all(2),
                            child: Card(
                                color: Colors.yellowAccent,
                                child: InkWell(
                                  onTap: () => _loadFoodDetails(index),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Container(
                                            height: screenHeight / 5,
                                            width: screenWidth / 1.2,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "https://itschizo.com/wedeliver2/images/food_images/${foodList[index]['imgname']}.jpg",
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  new CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      new Icon(
                                                Icons.broken_image,
                                                size: screenWidth / 2,
                                              ),
                                            )),
                                        SizedBox(height: 5),
                                        Text(
                                          foodList[index]['foodname'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text("RM " +
                                            foodList[index]['foodprice'] +
                                            " | Quantity:" +
                                            foodList[index]['foodqty']),
                                      ],
                                    ),
                                  ),
                                )));
                      }),
                    )),
              )
      ]),
    );
  }

  void _shoppinCartScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                ShoppingCartScreen(user: widget.user)));
  }

  Future<void> _loadFoods(String ftype) async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading...");
    await pr.show();
    http.post("https://itschizo.com/wedeliver2/php/load_foods.php", body: {
      "restid": widget.rest.restid,
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
    await pr.hide();
  }

  _loadFoodDetails(int index) {
    Food curfood = new Food(
        foodid: foodList[index]['foodid'],
        foodname: foodList[index]['foodname'],
        foodprice: foodList[index]['foodprice'],
        foodqty: foodList[index]['foodqty'],
        foodimg: foodList[index]['imgname'],
        foodcurqty: "1",
        restid: widget.rest.restid);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => FoodScreenDetails(
                  food: curfood,
                  user: widget.user,
                )));
  }
}
