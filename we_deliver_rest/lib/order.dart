import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:we_deliver_rest/restaurant.dart';
import 'package:we_deliver_rest/user.dart';

double perpage = 1;

class Order extends StatefulWidget {
  final Restaurant rest;
  final User user;

  Order({Key key, this.rest, this.user});

  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  double screenHeight, screenWidth;
  List foodList;
  String titlecenter = "Loading Foods...";
  String type = "Food";

  @override
  void initState() {
    super.initState();
    _loadpaid();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Customer Order'),
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
          body: Column(children: [
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
                          //onTap: () => _loadPaidDetails(index),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                    height: screenHeight / 5,
                                    width: screenWidth / 2.5,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "https://itschizo.com/wedeliver2/food/food_images/${foodList[index]['imgname']}.jpg",
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
                                                style: TextStyle(fontSize: 16)),
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
          ])),
    );
  }

  void _loadpaid() {
    http.post("https://itschizo.com/wedeliver2/php/load_paids.php", body: {
      //"restid": widget.rest.restid,
      //"email": widget.user.email,
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
}
