import 'package:fit_k/exercise.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final Map<DateTime, List<Exercise>> dataSet;

  HomePage({Key key, this.dataSet}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
//    print(DateTime.now());
//    print("Data Set INfo:");
//    print(widget.dataSet);
//    bool isSame = ((DateTime.now().difference(widget.dataSet.keys.first).inDays) == 0);
//    print(isSame);
//    print("");

    return Column(
      children: <Widget>[
        _buildDayInformation(),
        _buildAddBtn(),
//        _buildExerciseList(),
      ],
    );
  }

  Widget _buildDayInformation() {
    return Column(children: <Widget>[
      Padding(
        // Today's Date
        padding: const EdgeInsets.all(15.0),
        child: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8.0,
                spreadRadius: 0.1,
                offset: Offset(
                  1.1, // horizontal, move right 10
                  2.0, // vertical, move down 10
                ),
              )
            ],
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Center(
              child: Text(
            DateTime.now().toString(),
            style: TextStyle(
              fontSize: 28,
              color: Colors.lightBlueAccent,
              fontWeight: FontWeight.bold,
            ),
          )),
        ),
      ),
      Padding(
        // Exercise & Sets Done
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child: Container(
          height: 50,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8.0,
                        spreadRadius: 0.1,
                        offset: Offset(
                          1.1, // horizontal, move right 10
                          2.0, // vertical, move down 10
                        ),
                      )
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Center(
                    child: Text(
                      "Exercises",
                      style: TextStyle(
                        color: Colors.lightBlueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 20,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8.0,
                        spreadRadius: 0.1,
                        offset: Offset(
                          1.1, // horizontal, move right 10
                          2.0, // vertical, move down 10
                        ),
                      )
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Center(
                    child: Text(
                      "Sets",
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.lightBlueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    ]);
  }

  Widget _buildAddBtn() {
    Widget _popup() {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 16,
        child: Container(
          height: 200.0,
          child: Column(children: <Widget>[
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
                      //
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
      );
    }

    // @TODO implement addExercise Button/Dialogue
    void _addExercise() {
      showDialog(
        context: context,
        builder: (context) {
          return _popup();
        },
      );

      //widget.dataSet;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 5),
      child: Container(
        height: 40,
        width: double.infinity,
        child: RaisedButton(
          highlightElevation: 8,
          color: Colors.lightBlueAccent[100],
          onPressed: _addExercise,
          child: Text(
            "Add Exercise",
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  ListView _buildExerciseList() {
//    bool isSame = ((DateTime.now().difference(widget.dataSet.keys.first).inDays) == 0);
//
//    DateTime now = new DateTime.now();
//    DateTime todaysDate = new DateTime(now.year, now.month, now.day);

    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
//        ...widget.dataSet[DateTime.now()].map((entry) {
//          return ExerciseCard(
//            exercise: entry.workout,
//            setList: entry.setList,
//          );
//        }).toList(),
      ],
    );
  }
}
