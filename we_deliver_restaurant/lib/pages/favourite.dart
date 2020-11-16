import 'package:flutter/material.dart';
import 'package:we_deliver_restaurant/core/user.dart';

class Fav extends StatefulWidget{
  final User user;

  Fav({Key key, this.user});
  
  @override
  _FavState createState() => _FavState();
}
 
class _FavState extends State<Fav> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    );
  }
}