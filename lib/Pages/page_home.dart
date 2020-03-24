import 'package:fit_k/Logic/data_storage.dart';
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
  final List<Map> dataSet;
  final int dateIndex;

  HomePage({Key key, this.dataSet, this.dateIndex}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Storage storage;
  DateTime todaysDate;
  String formattedDate;
  int setsDone;

  @override
  void initState() {
    storage = Storage();
    var now = new DateTime.now();
    todaysDate = new DateTime(now.year, now.month, now.day);

    var formatter = new DateFormat.yMMMMd('en_US');
    formattedDate = formatter.format(todaysDate);
    updateSets();

    super.initState();
  }

  void updateSets() {
    storage.readData().then((List<dynamic> data) {
      print(data);
      List<dynamic> exerciseList;
      if(data.length == 0)
        exerciseList = new List();
      else
        exerciseList = data[widget.dateIndex]['exercises'];

      int setCount = 0;
      for(int i = 0; i < exerciseList.length; i++){
        int sets = Exercise.fromJson(exerciseList[i]).getSetCount();
        setCount += sets;
      }

      print("before " + setsDone.toString());
      setState(() {
        setsDone = setCount;
        print("after " + setsDone.toString());
      });
    });
  }

  // @TODO Edit data
  void removeExercise(int index) {
//    print(index);
    setState(() {
      widget.dataSet[widget.dateIndex]['exercises'].removeAt(index);
      Exercise.updateExerciseCount();

      for (int i = index; i < widget.dataSet[0]['exercises'].length; i++)
        widget.dataSet[0]['exercises'][i].id--;

      storage.save(widget.dataSet);
    });
  }

  // @TODO Edit data
  void addExercise(Exercise ex) {
    setState(() {
      widget.dataSet[0]['exercises'].add(ex);

      storage.save(widget.dataSet);
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
                      "${widget.dataSet[0]['exercises'].length} Exercises",
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
                  exerciseList: widget.dataSet[0]['exercises'],
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
    Widget createListView(BuildContext context, AsyncSnapshot snapshot) {

      List<dynamic> values;
      if(snapshot.data.length == 0)
        values = [];
      else
        values = snapshot.data[widget.dateIndex]['exercises'];
//      print(snapshot.data[0]['exercises']);

      return new ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: values.length,
        itemBuilder: (BuildContext context, int index) {
//          print(values);
          return new Column(
            children: <Widget>[
              ExerciseCard(
                exercise: Exercise.fromJson(values[index]),
                deleteExercise: removeExercise,
                updateSets: updateSets,
              ),
            ],
          );
        },
      );
    }

    Future _getData() async {
      var data = await storage.readData();
//    await new Future.delayed(new Duration(microseconds: 1));
      return data;
    }

    var futureBuilder = new FutureBuilder(
      future: _getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Text('');
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return createListView(context, snapshot);
        }
      },
    );

    return futureBuilder;
  }
}
