import 'package:flutter/material.dart';
import 'package:we_deliver_admin/core/admin.dart';

class AddFood extends StatefulWidget{
  final Admin admin;

  AddFood({Key key, this.admin});
  
  @override
  _AddFoodState createState() => _AddFoodState();
}
 
class _AddFoodState extends State<AddFood> {
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