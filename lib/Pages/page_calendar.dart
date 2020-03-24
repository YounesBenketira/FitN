import 'dart:convert';

import 'package:fit_k/Logic/data_storage.dart';
import 'package:flutter/material.dart';


class CalendarPage extends StatefulWidget {
  List<Map> dataSet;

  CalendarPage({Key key, this.dataSet}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  Storage _storage;
  TextEditingController _textEditingController;
  String text;

  @override
  void initState() {
    DateTime now = new DateTime.now();
    DateTime todaysDate = new DateTime(now.year, now.month, now.day);

    _textEditingController = TextEditingController();
    _storage = Storage();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
      return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        TextField(
          controller: _textEditingController,
        ),
        Row(
          children: <Widget>[
            FlatButton(
              color: Colors.greenAccent,
              child: Text("Save"),
              onPressed: () {
                setState(() {
                  String jsonData = jsonEncode(widget.dataSet);
                  _storage.writeData(jsonData);
                });
              },
            ),
            FlatButton(
              color: Colors.redAccent,
              child: Text("Read"),
              onPressed: () {
                _storage.readData().then((List<dynamic> value) {
                  setState(() {
                    text = value.toString();
                  });
                });
              },
            ),
          ],
        ),
        Container(
            height: 400,
            width: double.infinity,
            child: Center(
              child: Text(
                "$text",
                style: TextStyle(fontSize: 20),
              ),
            )),
      ],
    );
  }
}
