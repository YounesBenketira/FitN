import 'package:fit_k/Enums/cardTheme.dart';
import 'package:fit_k/Logic/data_storage.dart';
import 'package:fit_k/UI/ui_set.dart';
import 'package:flutter/material.dart';

import '../Logic/exercise.dart';
//import 'package:fit_k/Enums/cardTheme.dart';

class ExerciseCard extends StatefulWidget {
  Exercise exercise;

  List<Color> _theme = new List();

  Function deleteExercise;
  Function updateDataSet;

  ExerciseCard({this.exercise, this.deleteExercise, this.updateDataSet}) {
    // Dynamically set widget theme
    switch (this.exercise.theme) {
      case ColorTheme.Red:
        _theme.add(Color(0xffe52d27));
        _theme.add(Color(0xffFF512F));
        break;
      case ColorTheme.Blue:
        _theme.add(Color(0xff17EAD9));
        _theme.add(Color(0xff6078EA));
        break;
      case ColorTheme.Pink:
        _theme.add(Color(0xfffa71cd));
        _theme.add(Color(0xffc471f5));
        break;
      case ColorTheme.Peach:
        _theme.add(Color(0xffFCE38A));
        _theme.add(Color(0xffF38181));
        break;
      case ColorTheme.Green:
        _theme.add(Color(0xff42E695));
        _theme.add(Color(0xff3BB2B8));
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
        Positioned(
          left: 6,
          child: Container(height: 70, child: widget.exercise.icon),
        ),
        Positioned(
          left: 78,
          top: 12.5,
          child: Container(
            width: 170,
            height: 30,
            child: FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.contain,
                child: Text(
                  widget.exercise.title,
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: "OpenSans"),
                )),
          ),
        ),
        _buildButtons(),
        Positioned(
            top: 70,
            left: 22.5,
            child: Text(
              'x${widget.exercise.setList.length.toString()}',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
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
        height: 106,
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
//                  color: widget._theme[0].withOpacity(0.9),
                  color: Colors.grey.withOpacity(0.7),
                  blurRadius: 5.0, // has the effect of softening the shadow
                  spreadRadius: 3, // has the effect of extending the shadow
                  offset: Offset(
                    2.0, // horizontal, move right 10
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
                topRight: Radius.circular(30),
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
      padding: const EdgeInsets.only(left: 10, top: 0),
      child: Align(
          alignment: Alignment.topLeft,
          child: Row(
            children: <Widget>[],
          )),
    );
  }

  Widget _buildButtons() {
    Widget _minusBtn() {
      Text displayText;
      if (widget.exercise.setList.length == 0)
        displayText = Text(
          'Remove this exercise?',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        );
      else
        displayText = Text(
          'Remove the last set?',
          style: TextStyle(fontSize: 23),
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
                  ),
                ),
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
                        if (widget.exercise.setList.length == 0) {
                          widget.deleteExercise(id);
                          final snackBar = SnackBar(
                            content: Text('Exercise Removed!'),
                            backgroundColor: Colors.redAccent,
                            duration: Duration(seconds: 2),
                          );
                          Scaffold.of(this.context).showSnackBar(snackBar);
                        } else {
                          widget.exercise
                              .removeSet(widget.exercise.getSetCount() - 1);
                          _storage.removeSet(
                              widget.exercise, widget.updateDataSet);
                        }
                      });
//                        widget.updateSets();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Remove",
                      style: TextStyle(fontSize: 19, color: Colors.white),
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
        width: 35,
        height: 35,
        child: IconButton(
          iconSize: 20,
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
          height: 220.0,
          child: Form(
            child: Column(children: <Widget>[
              Container(
                width: double.infinity,
                height: 15,
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
                            color: Theme.of(context).primaryColorDark,
                            fontSize: 20,
                          ),
                          controller: _repController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "# of Repititions",
                              hintStyle: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 20),
                              contentPadding: EdgeInsets.only(bottom: 1),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
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
                            color: Theme
                                .of(context)
                                .primaryColorDark,
                            fontSize: 20,
                          ),
                          controller: _weightController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "Weight (lbs./kg)",
                              hintStyle: TextStyle(
                                color: Theme
                                    .of(context)
                                    .primaryColor,
                                fontSize: 20,
                              ),
                              alignLabelWithHint: true,
                              contentPadding: EdgeInsets.only(bottom: 1),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme
                                      .of(context)
                                      .primaryColor,
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
//                          print("AFTER: " + widget.exercise.toString());
                        });
                        _storage.saveSet(widget.exercise, widget.updateDataSet);
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
        width: 35,
        height: 35,
        child: IconButton(
          iconSize: 20,
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
      right: 25,
      child: Row(
        children: <Widget>[
          _minusBtn(),
          Container(
            width: 5,
          ),
          _plusBtn(),
        ],
      ),
    );
  }

  Widget _buildSetLog() {
    List<Widget> setList = new List();
    for (int i = 0; i < widget.exercise.setList.length; i++) {
      SetUI set = SetUI(
          rep: widget.exercise.setList[i.toString()][0],
          weight: widget.exercise.setList[i.toString()][1]);
      setList.add(set);
    }
    ;

    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 75, right: 22),
      child: Container(
        height: 59,
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
