import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:we_deliver_rest/dashboard.dart';
import 'package:we_deliver_rest/mainscreen.dart';
import 'package:we_deliver_rest/order.dart';
import 'package:we_deliver_rest/restaurant.dart';

class MainScreens extends StatefulWidget {
  final Restaurant rest;

  const MainScreens({Key key, this.rest}) : super(key: key);

  @override
  _MainScreensState createState() => _MainScreensState();
}

class _MainScreensState extends State<MainScreens> {
  List<Widget> tabs;

  int currentTabIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabs = [
      Dashboard(rest: widget.rest),
      MainScreen(rest: widget.rest),
      Order(rest: widget.rest),
    ];
  }

  String $pagetitle = "We Deliver";

  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[currentTabIndex],
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
            icon: Icon(Icons.dashboard),
            title: Text("Dashboard"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.restaurant_menu,
            ),
            title: Text("Menu"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart,
            ),
            title: Text("Order"),
          ),
          /*BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            title: Text("Profile"),
          )*/
        ],
      ),
    );
  }
}
