import 'package:flutter/material.dart';
import 'package:we_deliver_restaurant/core/user.dart';

class Cart extends StatefulWidget {
  final User user;

  Cart({Key key, this.user});

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          elevation: 0,
          backgroundColor: Colors.yellow,
          centerTitle: true,
          title: Text("Order Cart",
              style: TextStyle(fontSize: 25.0, color: Colors.black)),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {}), //_onBackPressAppBar,)
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              child: Text(''),
            ),
          ),
        ),
        bottomNavigationBar: _buildTotalContainer());
  }

  Widget _buildTotalContainer() {
    return Container(
      height: 210.0,
      padding: EdgeInsets.only(
        left: 30.0,
        right: 30.0,
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Subtotal",
                style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(''),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Discount",
                style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(''),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Tax",
                style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(''),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Divider(
            height: 2.0,
            color: Colors.black,
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Total",
                style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(''),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          GestureDetector(
            onTap: () {
              //Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SignInPage()));
            },
            child: Container(
              height: 50.0,
              decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(35.0)),
              child: Center(
                child: Text(
                  "Pay",
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
