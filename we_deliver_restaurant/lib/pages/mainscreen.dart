import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:we_deliver_restaurant/core/user.dart';
import 'package:we_deliver_restaurant/pages/cart.dart';
import 'package:we_deliver_restaurant/pages/favourite.dart';
import 'package:we_deliver_restaurant/pages/home.dart';
import 'package:we_deliver_restaurant/pages/profile.dart';

String urlgetuser = "https://itschizo.com/aidil_qayyum/srs2/php/get_user.php";
int number = 0;

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  //List<Widget> tabs;
  List foodList;
  double screenHeight, screenWidth;
  String titlecenter = "Loading Menu...";

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadRestaurant();
    /*tabs = [
      Home(user: widget.user),
      Fav(user: widget.user),
      Cart(user: widget.user),
      Profile(user: widget.user),
    ];*/
  }

  String $pagetitle = "We Deliver";

  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        brightness: Brightness.light,
        elevation: 0,
        title: Text(
          'Home',
          style: TextStyle(color: Color(0xFFFFC508)),
        ),
        actions: [
          IconButton(icon: Icon(Icons.search_outlined), onPressed: () {}),
          IconButton(
              icon: Icon(Icons.shopping_cart_outlined), onPressed: () {}),
        ],
        iconTheme: IconThemeData(color: Colors.yellow[700]),
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
                        "https://itschizo.com/aidil_qayyum/srs2/profile/${widget.user.email}.jpg?dummy=${(number)}'")),
                accountName: Text(
                    widget.user.name?.toUpperCase() ?? 'Not register',
                    style: TextStyle(fontSize: 16, color: Colors.black)),
                accountEmail: Text(widget.user.email,
                    style: TextStyle(fontSize: 16, color: Colors.black))),
            ListTile(
                leading: Icon(Icons.restaurant_menu),
                title: Text("Favourites"),
                onTap: () {
                  Navigator.of(context).pop();
                }),
            ListTile(
                leading: Icon(Icons.shopping_cart),
                title: Text("Order"),
                onTap: () {
                  Navigator.of(context).pop();
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
                  /*ListTile(
                          leading: Icon(Icons.add_to_home_screen),
                          title: Text('Login'),
                          onTap: () {
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) => LoginPage()));
                          }),*/
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
      /*body: tabs[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.yellow[700],
        unselectedItemColor: Colors.grey[850],
        onTap: onTapped,
        currentIndex: currentTabIndex,
        elevation: 0,
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
            ),
            title: Text("Favourite"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart,
            ),
            title: Text("Cart"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            title: Text("Profile"),
          )
        ],
      ),*/
      body: Column(
        children: [
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
                  //crossAxisSpacing: 0.5,
                  //mainAxisSpacing: 3.0,
                  childAspectRatio: (screenWidth / screenHeight) / 0.8,
                  children: List.generate(foodList.length, (index) {
                    return Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 20.0),
                        child: Card(
                          child: InkWell(
                            onTap: () => () {}, //_loadRestaurantDetail(index),
                            child: Column(
                              children: [
                                Container(
                                    height: screenHeight / 4.3,
                                    width: screenWidth / 1.2,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(
                                              "https://itschizo.com/aidil_qayyum/srs2/images/${foodList[index]['fimage']}.jpg",
                                            )))),
                                SizedBox(height: 8),
                                Text(
                                  foodList[index]['fname'],
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Text("RM " + foodList[index]['fprice']),
                                //Text(foodList[index]['fdesc']),
                                Text(foodList[index]['fcat']),
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

  /*Future<String> makeRequest() async {
    String urlLoadFood =
        "https://itschizo.com/aidil_qayyum/srs2/php/load_food.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading All Posted Menu");
    pr.show();
    http.post(urlLoadFood, body: {
      "email": widget.user.email ?? "notavail",
    }).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        foodList = extractdata["wedeliver"];
        //perpage = (foodList.length / 10);
        print("data");
        print(foodList);
        pr.hide();
      });
    }).catchError((err) {
      print(err);
      pr.hide();
    });
    return null;
  }*/
  void _loadRestaurant() async {
    http.post("https://itschizo.com/aidil_qayyum/srs2/php/load_food.php",
        body: {
          //"location": "Changlun",
        }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        foodList = null;
        setState(() {
          titlecenter = "No Menu Found";
        });
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          foodList = jsondata["wedeliver"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }
}
