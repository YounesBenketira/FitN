import 'package:flutter/material.dart';

class StatisticsPage extends StatefulWidget {
  StatisticsPage({Key key}) : super(key: key);

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  static DateTime now = new DateTime.now();
  DateTime todaysDate = new DateTime(now.year, now.month, now.day);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.red,
      child: Center(
        child: Text(
          "Statistics",
          style: TextStyle(fontSize: 60),
        ),
      ),
    );
  }
}