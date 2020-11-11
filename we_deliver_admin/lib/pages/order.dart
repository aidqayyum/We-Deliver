import 'package:flutter/material.dart';
import 'package:we_deliver_admin/core/admin.dart';

class Order extends StatefulWidget{
  final Admin admin;

  Order({Key key, this.admin});
  
  @override
  _OrderState createState() => _OrderState();
}
 
class _OrderState extends State<Order> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Center(
          child: Container(
            child: Text('Hello World Cart'),
          ),
        ),
      ),
    );
  }
}