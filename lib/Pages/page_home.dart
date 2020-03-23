import 'package:fit_k/Logic/exercise.dart';
import 'package:fit_k/UI/popup_AddExercise.dart';
import 'package:fit_k/UI/card_Exercise.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/*
  @TODO Fix following UI components
    - Delete Set
    - Remove Exercise
    - Add Exercise
    - Add Set
    = Bottom Navigation Icons
    = Bottom Navigation Border
    ? Day Review
 */

class HomePage extends StatefulWidget {
  final Map<DateTime, List<Exercise>> dataSet;

  HomePage({Key key, this.dataSet}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime todaysDate;
  String formattedDate;
  int setsDone;

  @override
  void initState() {
    var now = new DateTime.now();
    todaysDate = new DateTime(now.year, now.month, now.day);

    var formatter = new DateFormat.yMMMMd('en_US');
    formattedDate = formatter.format(todaysDate);
    updateSets();

    super.initState();
  }

  void updateSets() {
    int setCount = 0;
    for (int i = 0; i < widget.dataSet[todaysDate].length; i++) {
      int sets = widget.dataSet[todaysDate][i].getSetCount();

      setCount += sets;
    }
    setState(() {
      setsDone = setCount;
    });
  }

  void removeExercise(int index) {
    print(index);
    setState(() {
      widget.dataSet[todaysDate].removeAt(index);
      Exercise.updateExerciseCount();

      for (int i = index; i < widget.dataSet[todaysDate].length; i++)
        widget.dataSet[todaysDate][i].id--;
    });
  }

  void addExercise(Exercise ex) {
    setState(() {
      widget.dataSet[todaysDate].add(ex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        _buildDayInformation(),
        _buildAddBtn(),
        _buildExerciseList(),
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
            formattedDate,
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
                      "${widget.dataSet[todaysDate].length} Exercises",
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
                      "$setsDone Sets",
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

    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 5),
      child: Container(
        height: 40,
        width: double.infinity,
        child: RaisedButton(
          highlightElevation: 8,
          color: Colors.lightBlueAccent[100],
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return ExerciseCreationPopup(
                  exerciseList: widget.dataSet[todaysDate],
                  addExercise: addExercise,
                );
              },
            );
          },
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

  Widget _buildExerciseList() {
    return Column(
      children: widget.dataSet[todaysDate].map((entry) {
        return ExerciseCard(
          exercise: entry,
          deleteExercise: removeExercise,
          updateSets: updateSets,
        );
      }).toList(),
    );
  }
}
