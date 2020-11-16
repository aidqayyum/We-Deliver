import 'package:flutter/material.dart';
import 'package:we_deliver_restaurant/core/user.dart';

class Cart extends StatefulWidget{
  final User user;

  Cart({Key key, this.user});
  
  @override
  _CartState createState() => _CartState();
}
 
class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    );
  }
}