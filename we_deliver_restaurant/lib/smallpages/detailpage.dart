import 'package:flutter/material.dart';
import 'package:we_deliver_restaurant/core/food.dart';
import 'package:we_deliver_restaurant/pages/cart.dart';
import 'package:we_deliver_restaurant/pages/mainscreen.dart';

class DetailPage extends StatefulWidget {
  final Food food;

  const DetailPage({Key key, this.food}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  double screenHeight, screenWidth;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.food.fname,
            style: TextStyle(
                color: Color(0xFF000000),
                fontSize: 22,
                fontFamily: 'Montserrat')),
        brightness: Brightness.light,
        backgroundColor: Colors.yellowAccent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
          onPressed: _onBackPressAppBar,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.shopping_bag_outlined,
              color: Colors.black,
            ),
            onPressed: _addToCart,
          ),
        ],
      ),
      backgroundColor: Colors.yellowAccent,
      /*body: Center(
        child: Column(children: [
          Container(
              height: screenHeight / 3,
              width: screenWidth / 0.1,
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                      "https://itschizo.com/aidil_qayyum/srs2/images/${widget.food1.fimage}.jpg",

                      //placeholder: (context, url) => new CircularProgressIndicator(),
                      //errorWidget: (context, url, error) => new Icon(
                      //Icons.broken_image,
                      //size: screenWidth / 2,
                    )),
              )),
        ]),
      ),*/
      body: Column(
        children: <Widget>[
          SizedBox(height: 25),
          Container(
            height: 270,
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
                          "https://itschizo.com/aidil_qayyum/srs2/images/${widget.food.fimage}.jpg",
                      child: Image(
                        image: NetworkImage(
                          "https://itschizo.com/aidil_qayyum/srs2/images/${widget.food.fimage}.jpg",
                        ),
                      ),
                    )),
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
                    widget.food.fname,
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: <Widget>[
                      Text(
                        "RM " + widget.food.fprice,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow[700],
                        ),
                      ),
                      SizedBox(width: 30),
                      _foodCounter(),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Category: ",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        widget.food.fcat,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(widget.food.fdesc),
                  Expanded(child: SizedBox()),
                  Row(
                    children: [
                      Expanded(
                        child: RaisedButton(
                          onPressed: () {},
                          padding: EdgeInsets.symmetric(vertical: 16),
                          color: Colors.yellowAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(18),
                            ),
                          ),
                          child: Text(
                            "Add To Cart",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(
              //user: widget.user,
              ),
        ));
    return Future.value(false);
  }

  void _addToCart() {
    Navigator.of(context).pop();
    Navigator.push(
        context, MaterialPageRoute(builder: (BuildContext context) => Cart()));
  }
}

Widget _foodCounter() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.yellowAccent,
      borderRadius: BorderRadius.all(
        Radius.circular(12),
      ),
    ),
    child: Row(
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.remove,
            color: Colors.black,
          ),
          onPressed: null,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "1",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.add,
            color: Colors.black,
          ),
          onPressed: null,
        ),
      ],
    ),
  );
}
