import 'package:fit_k/Enums/cardTheme.dart';
import 'package:fit_k/Logic/data_storage.dart';
import 'package:fit_k/UI/ui_set.dart';
import 'package:flutter/material.dart';

import '../Enums/workout.dart';
import '../Logic/exercise.dart';
//import 'package:fit_k/Enums/cardTheme.dart';

class ExerciseCard extends StatefulWidget {
  Exercise exercise;

  String _title;
  List<Color> _theme = new List();
  Image _icon;

  Function deleteExercise;
  Function updateSets;

  ExerciseCard({this.exercise, this.deleteExercise, this.updateSets}) {
    // Dynamically set widget header
    switch (this.exercise.workout) {
      case Workout.Bench:
        this._title = "Bench";
        this._icon = Image.asset("images/BenchTEMP.png");
        break;
      case Workout.Squat:
        this._title = "Squat";
        this._icon = Image.asset("images/BarbellTEMP.png");
        break;
      case Workout.OverHeadPress:
        this._title = "OH Press";
        this._icon = Image.asset("images/DumbbellTEMP.png");
        break;
      case Workout.BentOverRow:
        this._title = "Row";
        this._icon = Image.asset("images/WeightsTEMP.png");
        break;
      case Workout.Deadlift:
        this._title = "Deadlift";
        this._icon = Image.asset("images/DeadliftTEMP.png");
        break;
    }

    // Dynamically set widget theme
    switch (this.exercise.theme) {
      case ColorTheme.Yellow:
        _theme.add(Colors.yellow[400]);
        _theme.add(Colors.yellow[700]);
        break;
      case ColorTheme.Blue:
        _theme.add(Colors.lightBlue[200]);
        _theme.add(Colors.lightBlue[500]);
        break;
      case ColorTheme.Purple:
        _theme.add(Colors.purpleAccent[100]);
        _theme.add(Colors.purpleAccent[700]);
        break;
      case ColorTheme.Peach:
        _theme.add(Colors.redAccent[100]);
        _theme.add(Colors.orangeAccent[700]);
        break;
      case ColorTheme.Green:
        _theme.add(Colors.greenAccent);
        _theme.add(Colors.greenAccent[700]);
        break;
    }
  }

  @override
  _ExerciseCardState createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  TextEditingController _repController;
  TextEditingController _weightController;
  Storage _storage;

  @override
  void initState() {
    _repController = new TextEditingController();
    _weightController = new TextEditingController();

    _storage = Storage();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildCard(),
        _buildHeader(),
        _buildButtons(),
        Positioned(
            top: 60,
            left: 6,
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
                    widget.exercise.setList.length.toString(),
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )),
        _buildSetLog(),
      ],
    );
  }

  Widget _buildCard() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
      child: Container(
        height: 125,
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: widget._theme[0].withOpacity(0.9),
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
                  widget._theme[0],
                  widget._theme[1],
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
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 5, top: 0),
      child: Align(
          alignment: Alignment.topLeft,
          child: Row(
            children: <Widget>[
              Container(
                  height: 65, child: Container(width: 75, child: widget._icon)),
              Container(
                width: 5,
              ),
              Container(
                width: 150,
                height: 35,
                child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.contain,
                    child: Text(
                      widget._title,
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
              ),
            ],
          )),
    );
  }

  Widget _buildButtons() {
    Widget _minusBtn() {
      Text displayText;
      if (widget.exercise.setList.length == 0)
        displayText = Text(
          'Remove this exercise?',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        );
      else
        displayText = Text(
          'Remove the last set?',
          style: TextStyle(fontSize: 25),
        );

      Dialog removeDialogue = Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 16,
        child: Container(
          height: 155.0,
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 25.0),
              child: displayText,
            ),
            Row(children: <Widget>[
              Container(
                width: 20,
              ),
              Expanded(
                child: RaisedButton(
                    color: Colors.lightBlueAccent[200],
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )),
              ),
              Container(
                width: 20,
              ),
              Expanded(
                child: RaisedButton(
                    color: Colors.red,
                    onPressed: () {
                      setState(() {
                        int id = widget.exercise.id;
                        if (widget.exercise.setList.length == 0)
                          widget.deleteExercise(id);
                        else {
                          widget.exercise
                              .removeSet(widget.exercise.getSetCount() - 1);
                          _storage.removeSet(
                              widget.exercise, widget.updateSets);
                        }
                      });
//                        widget.updateSets();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Remove",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )),
              ),
              Container(
                width: 20,
              ),
            ]),
//            Container(
//              height: 30,
//            ),
          ]),
        ),
      );

      return Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        width: 40,
        height: 40,
        child: IconButton(
          icon: Icon(Icons.remove),
          color: Colors.white,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return removeDialogue;
              },
            );
          },
        ),
      );
    }

    Widget _plusBtn() {
      Dialog addDialog = Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 16,
        child: Container(
          height: 240.0,
          child: Form(
            child: Column(children: <Widget>[
              Container(
                width: double.infinity,
                height: 15,
              ),
              Text(
                'Add Set',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
              ),
              Container(
                width: double.infinity,
                height: 12,
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
                          style: TextStyle(
//                            color: Colors.lightBlue,
                            fontSize: 20,
                          ),
                          controller: _repController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "# of Repititions",
                              hintStyle: TextStyle(
//                                color: Colors.lightBlue,
                                  fontSize: 20),
                              contentPadding: EdgeInsets.only(bottom: 1),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(
//                                  color: Colors.lightBlue,
                                  width: 1,
                                ),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)))),
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
                          style: TextStyle(
//                            color: Colors.lightBlue,
                            fontSize: 20,
                          ),
                          controller: _weightController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "Weight (lbs./kg)",
                              hintStyle: TextStyle(
//                                color: Colors.lightBlue,
                                fontSize: 20,
                              ),
                              alignLabelWithHint: true,
                              contentPadding: EdgeInsets.only(bottom: 1),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(
//                                  color: Colors.lightBlue,
                                  width: 1,
                                ),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)))),
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
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )),
                ),
                Container(
                  width: 20,
                ),
                Expanded(
                  child: RaisedButton(
                      color: Colors.lightBlueAccent[200],
                      onPressed: () {
                        setState(() {
                          // @ TODO Error handling
                          int reps = int.parse(_repController.text);
                          int weight = int.parse(_weightController.text);
//                          print("BEFORE: " + widget.exercise.toString());
                          widget.exercise.setList.putIfAbsent(
                              widget.exercise.setList.length.toString(),
                              () => [reps, weight]);

                          _storage.saveSet(widget.exercise, widget.updateSets);
//                          print("AFTER: " + widget.exercise.toString());
                        });

                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Add",
                        style: TextStyle(fontSize: 20, color: Colors.white),
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

      return Container(
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
                return addDialog;
              },
            );
          },
        ),
      );
    }

    return Positioned(
      top: 12,
      right: 55,
      child: Row(
        children: <Widget>[
          _minusBtn(),
          Container(
            width: 10,
          ),
          _plusBtn(),
        ],
      ),
    );
  }

  Widget _buildSetLog() {
//
//    Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
//      Map<String, dynamic> values;
//      if (snapshot.data.length == 0)
//        values = {};
//      else
//        values = snapshot.data;
//
//      return Padding(
//        padding: const EdgeInsets.only(left: 83.0, top: 58, right: 20),
//        child: Container(
//          height: 72,
//          width: double.infinity,
//          decoration: BoxDecoration(
//            color: Colors.white.withOpacity(0.25),
//            borderRadius: BorderRadius.all(Radius.circular(8)),
//          ),
//          child: new ListView.builder(
//            primary: true,
//            shrinkWrap: true,
//            scrollDirection: Axis.horizontal,
//            itemCount: values.length,
//            itemBuilder: (BuildContext context, int index) {
////              print(values);
//              return new Row(
//                children: <Widget>[
//                  Set(values[index.toString()][0], values[index.toString()][1]),
//                ],
//              );
//            },
//          ),
//        ),
//      );
//    }
//
//    Future _getData() async {
//      var data = await _storage.readData();
//
//      Exercise exercise =
//          Exercise.fromJson(data[0]['exercises'][widget.exercise.id]);
////    await new Future.delayed(new Duration(microseconds: 1));
//      return exercise.setList;
//    }
//
//    var futureBuilder = new FutureBuilder(
//      future: _getData(),
//      builder: (BuildContext context, AsyncSnapshot snapshot) {
//        switch (snapshot.connectionState) {
//          case ConnectionState.none:
//          case ConnectionState.waiting:
//            return new Text('');
//          default:
//            if (snapshot.hasError)
//              return new Text('Error: ${snapshot.error}');
//            else
//              return createListView(context, snapshot);
//        }
//      },
//    );
//
//    return futureBuilder;

    List<Widget> setList = new List();
    for (int i = 0; i < widget.exercise.setList.length; i++) {
      SetUI set = SetUI(
          rep: widget.exercise.setList[i.toString()][0],
          weight: widget.exercise.setList[i.toString()][1]);
      setList.add(set);
    }
    ;

    return Padding(
      padding: const EdgeInsets.only(top: 55, left: 80, right: 22),
      child: Container(
        height: 75,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.25),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            ...setList.map((entry) {
              return entry;
            }).toList(),
          ],
        ),
      ),
    );
  }
}
