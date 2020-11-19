import 'package:flutter/material.dart';
import 'package:we_deliver_restaurant/core/user.dart';

class Fav extends StatefulWidget {
  final User user;

  Fav({Key key, this.user});

  @override
  _FavState createState() => _FavState();
}

class _FavState extends State<Fav> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
        automaticallyImplyLeading: false,
        brightness: Brightness.light,
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          child: Text('Welcome'),
        ),
      ),
    );
  }
}
