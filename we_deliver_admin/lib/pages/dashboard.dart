import 'package:flutter/material.dart';
import 'package:we_deliver_admin/core/admin.dart';

class Dashboard extends StatefulWidget{
  final Admin admin;

  Dashboard({Key key, this.admin});
  
  @override
  _DashboardState createState() => _DashboardState();
}
 
class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    );
  }
}