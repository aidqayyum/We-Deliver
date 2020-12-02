import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:we_deliver_restaurant/core/food.dart';
import 'package:we_deliver_restaurant/core/user.dart';
import 'package:we_deliver_restaurant/main.dart';
import 'package:we_deliver_restaurant/pages/cart.dart';
//import 'package:we_deliver_restaurant/pages/favourite.dart';
//import 'package:we_deliver_restaurant/pages/home.dart';
import 'package:we_deliver_restaurant/pages/profile.dart';
import 'package:we_deliver_restaurant/smallpages/detailpage.dart';

String urlgetuser = "https://itschizo.com/aidil_qayyum/srs2/php/get_user.php";
int number = 0;

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  //List<Widget> tabs;
  List foodList;
  double screenHeight, screenWidth;
  String titlecenter = "Loading Menu...";
  String cartquantity = "0";
  int quantity = 1;
  String server = "https://itschizo.com/aidilqayyum/srs2";

  @override
  void initState() {
    super.initState();
    _loadRestaurant();
    _loadCartQuantity();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    /*tabs = [
      Home(user: widget.user),
      Fav(user: widget.user),
      Cart(user: widget.user),
      Profile(user: widget.user),
    ];*/
  }

  String $pagetitle = "We Deliver";
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
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search_outlined), onPressed: () {}),
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
            /*ListTile(
                leading: Icon(Icons.restaurant_menu),
                title: Text("Favourites"),
                onTap: () {
                  Navigator.of(context).pop();
                }),*/
            ListTile(
                leading: Icon(Icons.shopping_cart),
                title: Text("Order"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Cart(
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
          Container(
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.yellow, offset: Offset(1, 1), blurRadius: 20)
            ]),
            child: Padding(
              padding: EdgeInsets.all(4),
              child: Image.asset("assets/images/drinks.png",
                  width: 50, height: 40),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
              height: 40,
              child: Column(
                children: [
                  Container(),
                  SizedBox(height: 5),
                  Text(
                    "Drinks",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  )
                ],
              )),
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
                  childAspectRatio: (screenWidth / screenHeight) / 0.9,
                  children: List.generate(foodList.length, (index) {
                    return Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 20.0),
                        child: Card(
                          child: InkWell(
                            onTap: () => _loadMenuDetails(index),
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
                                //SizedBox(height: 8),
                                Text("RM " + foodList[index]['fprice']),
                                //Text(foodList[index]['fdesc']),
                                Text(foodList[index]['fcat']),
                                Text("Quantity: " +
                                    foodList[index]['fquantity']),
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  minWidth: 100,
                                  height: 30,
                                  child: Text(
                                    'Add to Cart',
                                  ),
                                  color: Colors.yellowAccent,
                                  textColor: Colors.black,
                                  elevation: 10,
                                  onPressed: () => _addtocartdialog(index),
                                ),
                              ],
                            ),
                          ),
                        ));
                  }),
                ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => Cart(user: widget.user)));
          _loadRestaurant();
          _loadCartQuantity();
        },
        child: Icon(
          Icons.shopping_cart_outlined,
          color: Colors.black,
        ),
        backgroundColor: Colors.yellowAccent,
        //label: Text(cartquantity),
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
    await http.post("https://itschizo.com/aidil_qayyum/srs2/php/load_food.php",
        body: {}).then((res) {
      if (res.body == "nodata") {
        cartquantity = "0";
        titlecenter = "No product found";
        setState(() {
          titlecenter = "No Menu Found";
          foodList = null;
        });
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          foodList = jsondata["wedeliver"];
          cartquantity = widget.user.quantity;
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  _loadMenuDetails(int index) {
    print(foodList[index]['fname']);
    Food foods = new Food(
      fid: foodList[index]['fid'],
      fname: foodList[index]['fname'],
      fprice: foodList[index]['fprice'],
      fdesc: foodList[index]['fdesc'],
      fcat: foodList[index]['fcat'],
      fquantity: foodList[index]['fquantity'],
      fimage: foodList[index]['fimage'],
    );
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => DetailPage(food: foods)));
  }

  _addtocartdialog(int index) {
    quantity = 1;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, newSetState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Add " + foodList[index]['fname'] + " to Cart?",
                style: TextStyle(
                  color: Colors.yellowAccent,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Select quantity of product",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () => {
                              newSetState(() {
                                if (quantity > 1) {
                                  quantity--;
                                }
                              })
                            },
                            child: Icon(
                              MdiIcons.minus,
                              color: Colors.yellowAccent,
                            ),
                          ),
                          Text(
                            quantity.toString(),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          FlatButton(
                            onPressed: () => {
                              newSetState(() {
                                if (quantity <
                                    (int.parse(foodList[index]['fquantity']) -
                                        2)) {
                                  quantity++;
                                } else {
                                  Toast.show("Quantity not available", context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.BOTTOM);
                                }
                              })
                            },
                            child: Icon(
                              MdiIcons.plus,
                              color: Colors.yellowAccent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              actions: <Widget>[
                MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      _addtoCart(index);
                    },
                    child: Text(
                      "Yes",
                      style: TextStyle(
                        color: Colors.yellowAccent,
                      ),
                    )),
                MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.yellowAccent,
                      ),
                    )),
              ],
            );
          });
        });
  }

  void _addtoCart(int index) {
    try {
      int cquantity = int.parse(foodList[index]["fquantity"]);
      print(cquantity);
      print(foodList[index]["fid"]);
      print(widget.user.email);
      if (cquantity > 0) {
        ProgressDialog pr = new ProgressDialog(context,
            type: ProgressDialogType.Normal, isDismissible: true);
        pr.style(message: "Add to cart...");
        pr.show();
        String urlLoadJobs = server + "/php/add_cart.php";
        http.post(urlLoadJobs, body: {
          "email": widget.user.email,
          "proid": foodList[index]["fid"],
          "cquantity": quantity.toString(),
        }).then((res) {
          print(res.body);
          if (res.body == "failed") {
            Toast.show("Failed add to cart", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            pr.hide();
            return;
          } else {
            List respond = res.body.split(",");
            setState(() {
              cartquantity = respond[1];
              widget.user.quantity = cartquantity;
            });
            Toast.show("Success add to cart", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
          pr.hide();
        }).catchError((err) {
          print(err);
          pr.hide();
        });
        pr.hide();
      } else {
        Toast.show("Out of stock", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } catch (e) {
      Toast.show("Failed add to cart", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _loadCartQuantity() async {
    String urlLoadJobs = server + "/php/cart_quantity.php";
    await http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      if (res.body == "nodata") {
      } else {
        widget.user.quantity = res.body;
      }
    }).catchError((err) {
      print(err);
    });
  }

  gotoCart() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => Cart(
                  user: widget.user,
                )));
    _loadRestaurant();
    _loadCartQuantity();
  }
}
