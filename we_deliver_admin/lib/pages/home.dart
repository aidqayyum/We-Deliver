import 'package:flutter/material.dart';
import 'package:we_deliver_admin/core/admin.dart';

class Home extends StatefulWidget{
  final Admin admin;

  Home({Key key, this.admin});
  
  @override
  _HomeState createState() => _HomeState();
}
 
class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    );
  }
}