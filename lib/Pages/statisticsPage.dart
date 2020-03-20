import 'package:fit_k/exercise.dart';
import 'package:flutter/material.dart';

class StatisticsPage extends StatefulWidget {
  List<Exercise> dataSet;

  StatisticsPage({Key key, this.dataSet}) : super(key: key);

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.red,
      child: Center(
        child: Text(
          widget.dataSet.length.toString(),
          style: TextStyle(fontSize: 60),
        ),
      ),
    );
  }
}
