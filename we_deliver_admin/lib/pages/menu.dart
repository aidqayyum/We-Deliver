import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:toast/toast.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:we_deliver_admin/core/admin.dart';
import 'package:we_deliver_admin/core/food.dart';
import 'package:we_deliver_admin/smallpages/addfood.dart';
import 'package:we_deliver_admin/smallpages/fooddetails.dart';

class Menu extends StatefulWidget {
  final Admin admin;

  Menu({Key key, this.admin});

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List menuList;
  double screenHeight, screenWidth;
  String titlecenter = "Loading Menu...";

  @override
  void initState() {
    super.initState();
    _loadRestaurant();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      body: Column(
        children: [
          menuList == null
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
                  childAspectRatio: (screenWidth / screenHeight) / 0.8,
                  children: List.generate(menuList.length, (index) {
                    return Padding(
                        padding: EdgeInsets.all(1),
                        child: Card(
                          child: InkWell(
                            onTap: () => _loadRestaurantDetail(index),
                            child: Column(
                              children: [
                                Container(
                                    height: screenHeight / 3.8,
                                    width: screenWidth / 1.2,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(
                                              "http://itschizo.com/aidil_qayyum/srs2/images/${menuList[index]['fimage']}.jpg",
                                              /*fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          new CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          new Icon(
                                        Icons.broken_image,
                                        size: screenWidth / 2,
                                      ),*/
                                            )))),
                                SizedBox(height: 5),
                                Text(
                                  menuList[index]['fname'],
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(menuList[index]['fprice']),
                                Text(menuList[index]['fcategory']),
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

  void _loadRestaurant() {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading All Posted Menu");
    pr.show();
    http.post("https://itschizo.com/aidil_qayyum/srs2/php/load_food.php",
        body: {
          //"category": "Western",
          "email": widget.admin.email ?? "notavail",
        }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        menuList = null;
        setState(() {
          titlecenter = "No Menu Found";
        });
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          menuList = jsondata["wedeliver"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  _loadRestaurantDetail(int index) {
    print(menuList[index]['fname']);
    Food food = new Food(
        fid: menuList[index]['fid'],
        fname: menuList[index]['fname'],
        fprice: menuList[index]['fprice'],
        fdesc: menuList[index]['fdesc'],
        fcategory: menuList[index]['fcategory'],
        fimage: menuList[index]['fimage']);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => FoodDetails(food: food)));
  }
}
