import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:we_deliver_restaurant/core/food.dart';
import 'package:we_deliver_restaurant/core/user.dart';

class FoodScreenDetails extends StatefulWidget {
  final Food food;
  final User user;

  const FoodScreenDetails({Key key, this.food, this.user}) : super(key: key);

  @override
  _FoodScreenDetailsState createState() => _FoodScreenDetailsState();
}

class _FoodScreenDetailsState extends State<FoodScreenDetails> {
  double screenHeight, screenWidth;
  int selectedQty = 0;

  @override
  void initState() {
    super.initState();
    selectedQty = int.parse(widget.food.foodcurqty) ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    var foodQty =
        Iterable<int>.generate(int.parse(widget.food.foodqty) + 1).toList();
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.food.foodname,
              style: TextStyle(
                color: Color(0xFF000000),
                fontSize: 22,
                fontFamily: 'Montserrat',
              )),
          brightness: Brightness.light,
          backgroundColor: Colors.yellowAccent,
          elevation: 0,
        ),
        backgroundColor: Colors.yellowAccent,
        body: Column(
          children: [
            SizedBox(height: 25),
            Container(
              height: 230,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Image(
                    image: AssetImage("assets/images/bg.png"),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Hero(
                      tag:
                          "https://itschizo.com/wedeliver/foodimages/${widget.food.foodimg}.jpg",
                      child: Image(
                        image: NetworkImage(
                          "https://itschizo.com/wedeliver/foodimages/${widget.food.foodimg}.jpg",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    )),
                padding: EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.food.foodname,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          "Select Quantity",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(width: 5),
                        NumberPicker.horizontal(
                          decoration: BoxDecoration(
                            border: new Border(
                              top: new BorderSide(
                                style: BorderStyle.solid,
                                color: Colors.redAccent,
                              ),
                              bottom: new BorderSide(
                                style: BorderStyle.solid,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                          initialValue: selectedQty,
                          minValue: 1,
                          maxValue: foodQty.length - 1,
                          step: 1,
                          zeroPad: false,
                          onChanged: (value) =>
                              setState(() => selectedQty = value),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Price RM " +
                          (selectedQty * double.parse(widget.food.foodprice))
                              .toStringAsFixed(2),
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow[700]),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(widget.food.fooddesc),
                    SizedBox(height: 30),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      minWidth: 400,
                      height: 50,
                      child: Text(
                        'Add To Cart',
                        style:
                            TextStyle(fontSize: 18, fontFamily: 'Montserrat'),
                      ),
                      color: Colors.yellowAccent,
                      textColor: Colors.black,
                      elevation: 15,
                      onPressed: _onOrderDialog,
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  void _onOrderDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Order " + widget.food.foodname + "?",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Quantity " + selectedQty.toString(),
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
                _orderFood();
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

  void _orderFood() {
    http.post("https://itschizo.com/wedeliver/php/insert_order.php", body: {
      "email": widget.user.email,
      "foodid": widget.food.foodid,
      "foodqty": selectedQty.toString(),
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
          "Failed",
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
