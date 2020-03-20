import 'package:flutter/material.dart';

import '../workout.dart';

class ExerciseCard extends StatefulWidget {
  Workout exercise;
  String title;
  Map<int, List> setList;

  ExerciseCard({this.exercise, this.setList}) {
    // @TODO implement custom colors
    // @TODO implement custom Icons
    switch (this.exercise) {
      case Workout.Bench:
        this.title = "Bench";
        break;
      case Workout.Squat:
        this.title = "Squat";
        break;
      case Workout.OverHeadPress:
        this.title = "Over-Head Press";
        break;
      case Workout.BentOverRow:
        this.title = "Bent-Over Row";
        break;
      case Workout.Deadlift:
        this.title = "Deadlift";
        break;
    }
  }

  @override
  _ExerciseCardState createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
          child: Container(
            height: 125,
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFFFB295).withOpacity(0.9),
                      blurRadius: 8.0, // has the effect of softening the shadow
                      spreadRadius: 1, // has the effect of extending the shadow
                      offset: Offset(
                        1.1, // horizontal, move right 10
                        4.0, // vertical, move down 10
                      ),
                    )
                  ],
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFFB295),
                      Color(0xFFFA7D82),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(70),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )),
              width: double.infinity,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5, top: 0),
          child: Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: <Widget>[
                  Container(
                      height: 65,
                      child: Container(
                          width: 50,
                          child: Icon(
                            Icons.verified_user, // @TODO fix icons
                          ))),
                  Text(
                    widget.title,
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: 75,
                    color: Colors.cyanAccent,
                  ),
                ],
              )),
        ),
        Padding(
            padding: EdgeInsets.only(top: 13, right: 55),
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                width: 40,
                height: 40,
                child: IconButton(
                  icon: Icon(Icons.add), // @TODO add minus button
                  color: Colors.white,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          elevation: 16,
                          child: Container(
                            height: 200.0,
                            child: Form(
                              child: Column(children: <Widget>[
                                Container(
                                  width: double.infinity,
                                  height: 20,
                                ),
                                Container(
                                  height: 50,
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: 50,
                                      ),
                                      Expanded(
                                        child: TextField(
                                            textAlign: TextAlign.center,
//                      textAlignVertical: TextAlignVertical.center,
                                            style: TextStyle(
                                                color: Colors.lightBlue,
                                                fontSize: 17),
//                                            controller: _repController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
//                            labelText: " Reps",
//                            labelStyle: TextStyle(color: Colors.lightBlue),
                                                hintText: "Repititions",
                                                hintStyle: TextStyle(
                                                    color: Colors.lightBlue),
                                                contentPadding:
                                                    EdgeInsets.only(bottom: 1),
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.lightBlue,
                                                      width: 1),
                                                ),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0)))),
                                      ),
                                      Container(
                                        width: 50,
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 10,
                                ),
                                Container(
                                  height: 50,
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: 50,
                                      ),
                                      Expanded(
                                        child: TextField(
                                            textAlign: TextAlign.center,
//                      textAlignVertical: TextAlignVertical.center,
                                            style: TextStyle(
                                                color: Colors.lightBlue,
                                                fontSize: 17),
//                                            controller: _weightController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
//                            labelText: " Weight(lbs.)",
//                            labelStyle: TextStyle(color: Colors.lightBlue),
                                                hintText: "Weight",
                                                hintStyle: TextStyle(
                                                    color: Colors.lightBlue),
                                                alignLabelWithHint: true,
                                                contentPadding:
                                                    EdgeInsets.only(bottom: 1),
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.lightBlue,
                                                      width: 1),
                                                ),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0)))),
                                      ),
                                      Container(
                                        width: 50,
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 5,
                                ),
                                Row(children: <Widget>[
                                  Container(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: RaisedButton(
                                        color: Colors.redAccent,
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        )),
                                  ),
                                  Container(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: RaisedButton(
                                        color: Colors.lightBlueAccent[200],
                                        onPressed: () {
//                                          _add();
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "Add",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        )),
                                  ),
                                  Container(
                                    width: 20,
                                  ),
                                ]),
                              ]),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            )),
        Padding(
            padding: EdgeInsets.only(top: 13, right: 105),
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                width: 40,
                height: 40,
                child: IconButton(
                  icon: Icon(Icons.add),
                  color: Colors.white,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          elevation: 16,
                          child: Container(
                            height: 200.0,
                            child: Form(
                              child: Column(children: <Widget>[
                                Container(
                                  width: double.infinity,
                                  height: 20,
                                ),
                                Container(
                                  height: 50,
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: 50,
                                      ),
                                      Expanded(
                                        child: TextField(
                                            textAlign: TextAlign.center,
//                      textAlignVertical: TextAlignVertical.center,
                                            style: TextStyle(
                                                color: Colors.lightBlue,
                                                fontSize: 17),
//                                            controller: _repController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
//                            labelText: " Reps",
//                            labelStyle: TextStyle(color: Colors.lightBlue),
                                                hintText: "Repititions",
                                                hintStyle: TextStyle(
                                                    color: Colors.lightBlue),
                                                contentPadding:
                                                    EdgeInsets.only(bottom: 1),
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.lightBlue,
                                                      width: 1),
                                                ),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0)))),
                                      ),
                                      Container(
                                        width: 50,
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 10,
                                ),
                                Container(
                                  height: 50,
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: 50,
                                      ),
                                      Expanded(
                                        child: TextField(
                                            textAlign: TextAlign.center,
//                      textAlignVertical: TextAlignVertical.center,
                                            style: TextStyle(
                                                color: Colors.lightBlue,
                                                fontSize: 17),
//                                            controller: _weightController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
//                            labelText: " Weight(lbs.)",
//                            labelStyle: TextStyle(color: Colors.lightBlue),
                                                hintText: "Weight",
                                                hintStyle: TextStyle(
                                                    color: Colors.lightBlue),
                                                alignLabelWithHint: true,
                                                contentPadding:
                                                    EdgeInsets.only(bottom: 1),
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.lightBlue,
                                                      width: 1),
                                                ),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0)))),
                                      ),
                                      Container(
                                        width: 50,
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 5,
                                ),
                                Row(children: <Widget>[
                                  Container(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: RaisedButton(
                                        color: Colors.redAccent,
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        )),
                                  ),
                                  Container(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: RaisedButton(
                                        color: Colors.lightBlueAccent[200],
                                        onPressed: () {
//                                          _add();
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "Add",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        )),
                                  ),
                                  Container(
                                    width: 20,
                                  ),
                                ]),
                              ]),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            )),
        Padding(
            padding: const EdgeInsets.only(top: 62.5, left: 6),
            child: Container(
              width: 80,
              child: Column(
                children: <Widget>[
                  Text(
                    "Sets:",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.normal),
                  ),
                  Text(
                    widget.setList.length.toString(),
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )),
        Padding(
          // exercise List
          padding: const EdgeInsets.only(top: 57, left: 80, right: 22),
          child: Container(
//        color: Colors.transparent,
            height: 75,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
//            border: Border.all(
//              color: Colors.green,
//              width: 1,
//            ),
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                // @TODO fix setList of each exercise
//                ...widget.setList[0].map((entry) {
//                  return entry;
//                }).toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
