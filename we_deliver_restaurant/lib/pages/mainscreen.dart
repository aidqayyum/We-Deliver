import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  List<Widget> tabs;

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabs = [
      Home(user: widget.user),
      Fav(user: widget.user),
      Cart(user: widget.user),
      Profile(user: widget.user),
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
    //SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      /*appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle:true,
        iconTheme: IconThemeData(color: Colors.yellow[700]),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: <Widget>[
            new UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.white),
              currentAccountPicture: new CircleAvatar(
                radius: 60.0,
                backgroundColor: const Color(0xFF778899),
                backgroundImage: 
                NetworkImage("http://itschizo.com/aidil_qayyum/srs2/profile/${widget.admin.email}.jpg?dummy=${(number)}'")
              ),
              accountName: Text(widget.admin.name?.toUpperCase() ?? 'Not register',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black)), 
              accountEmail: Text(widget.admin.email,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black))),
              ListTile(
                leading: Icon(Icons.dashboard),
                title: Text("Dashboard"),
                onTap: () {
                    Navigator.of(context).pop();
                  }),
              ListTile(
                leading: Icon(Icons.restaurant_menu),
                title: Text("Menu"),
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
                leading: Icon(Icons.person),
                title: Text("Profile"),
                onTap: () {
                    Navigator.of(context).pop();
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
                      ],)
                  ),)
              )
          ],
          ),
      ),*/
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
      ),
    );
  }
}
