import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:we_deliver_rest/restaurant.dart';

class Dashboard extends StatefulWidget {
  final Restaurant rest;

  Dashboard({Key key, this.rest});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<PieChartSectionData> _sections = List<PieChartSectionData>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    PieChartSectionData _item1 = PieChartSectionData(
        color: Colors.yellowAccent,
        value: 40,
        title: 'JAN',
        radius: 50,
        titleStyle: TextStyle(color: Colors.white, fontSize: 18));

    PieChartSectionData _item2 = PieChartSectionData(
        color: Colors.redAccent,
        value: 30,
        title: 'FEB',
        radius: 50,
        titleStyle: TextStyle(color: Colors.white, fontSize: 18));

    PieChartSectionData _item3 = PieChartSectionData(
        color: Colors.green,
        value: 20,
        title: 'MAR',
        radius: 50,
        titleStyle: TextStyle(color: Colors.white, fontSize: 18));

    PieChartSectionData _item4 = PieChartSectionData(
        color: Colors.blue,
        value: 10,
        title: 'APR',
        radius: 50,
        titleStyle: TextStyle(color: Colors.white, fontSize: 18));

    PieChartSectionData _item5 = PieChartSectionData(
        color: Colors.purpleAccent,
        value: 10,
        title: 'MAY',
        radius: 50,
        titleStyle: TextStyle(color: Colors.white, fontSize: 18));

    _sections = [_item1, _item2, _item3, _item4, _item5];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Dashboard'),
          brightness: Brightness.light,
          elevation: 0,
          backgroundColor: Colors.yellowAccent,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.yellowAccent,
            ),
            onPressed: () {},
          ),
        ),
        body: Container(
          child: AspectRatio(
            aspectRatio: 1,
            child: FlChart(
              chart: PieChart(
                PieChartData(
                  sections: _sections,
                  borderData: FlBorderData(show: false),
                  centerSpaceRadius: 60,
                  sectionsSpace: 0,
                ),
              ),
            ),
          ),
        ));
  }
}
