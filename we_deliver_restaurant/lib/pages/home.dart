import 'package:flutter/material.dart';
import 'package:we_deliver_restaurant/core/user.dart';

class Home extends StatefulWidget{
  final User user;

  Home({Key key, this.user});
  
  @override
  _HomeState createState() => _HomeState();
}
 
class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0,
        backgroundColor: Colors.yellow,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
          icon: Icon(Icons.search,
          color: Colors.black),
          onPressed: (){},
          ),],
      ),
      body: SingleChildScrollView(
        child:Center(
                child: Container(
                  child: Text('Welcome'),
                ),
      ),
      ),
    );
  }
}