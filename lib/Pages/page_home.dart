import 'package:fit_k/Logic/data_storage.dart';
import 'package:fit_k/Logic/exercise.dart';
import 'package:fit_k/UI/card_Exercise.dart';
import 'package:fit_k/UI/popup_AddExercise.dart';
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
  List<dynamic> dataSet;

  HomePage({Key key, this.dataSet}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Storage storage;
  DateTime todaysDate;
  DateTime yesterdaysDate;
  String formattedDate;
  int setsDone;
  int excCount;
  int dateIndex;
  int yesterIndex;

  @override
  void initState() {
    storage = Storage();
    _updateDataSet();
    getDateIndex();
    var now = new DateTime.now();
    todaysDate = new DateTime(now.year, now.month, now.day);
    yesterdaysDate =
        new DateTime(now.year, now.month, now.subtract(Duration(days: 1)).day);

    var formatter = new DateFormat.yMMMMd('en_US');
    formattedDate = formatter.format(todaysDate);
    updateSets();

    super.initState();
  }

  void getDateIndex() {
    Future data = _getData();
    data.then((var value) {
      List<dynamic> dataSet = value;

      for (int i = 0; i < dataSet.length; i++)
        if (DateTime.parse(dataSet[i]['date']) == todaysDate)
          setState(() {
            dateIndex = i;
            yesterIndex = dateIndex + 1;
          });

      if (dateIndex == null) {
        dataSet.add({'date': todaysDate.toIso8601String(), 'exercises': []});
        setState(() {
          dateIndex = dataSet.length - 1;
          yesterIndex = dateIndex + 1;
        });
      }
    });
  }

  void updateSets() {
    Future data = _getData();
    data.then((var data) {
      List<dynamic> exerciseList;

      if (data.length == 0)
        exerciseList = new List();
      else {
        if (dateIndex == null) dateIndex = data.length - 1;
        exerciseList = data[dateIndex]['exercises'];
      }

      int setCount = 0;
      for (int i = 0; i < exerciseList.length; i++) {
        int sets = Exercise.fromJson(exerciseList[i]).getSetCount();
        setCount += sets;
      }

      setState(() {
        setsDone = setCount;
        excCount = exerciseList.length;
      });
    });
  }

  void _updateDataSet() {
    Future<List<dynamic>> future = storage.readData();

    future.then((var data) {
      setState(() {
        widget.dataSet = data;
      });
    });
  }

  void removeExercise(int index) {
    List<dynamic> exerciseList = widget.dataSet[dateIndex]['exercises'];
    setState(() {
      exerciseList.removeAt(index);
    });

//      print(exerciseList);
//      print(exerciseList[0].runtimeType);

    for (int i = index; i < exerciseList.length; i++) {
      Exercise temp;
      if (exerciseList[i].runtimeType == Exercise)
        temp = exerciseList[i];
      else
        temp = Exercise.fromJson(exerciseList[i]);

      temp.id--;
      exerciseList[i] = temp.toJson();
    }

    excCount--;
    storage.save(widget.dataSet);
  }

  void addExerciseYesterday(Exercise ex) {
//    print("BEfore " + widget.dataSet.toString());
    for (int i = 0; i < widget.dataSet.length; i++) {
      if (DateTime.parse(widget.dataSet[i]['date']) == yesterdaysDate) {
        ex.id = widget.dataSet[i]['exercises'].length;
        widget.dataSet[yesterIndex]['exercises'].add(ex);
        storage.save(widget.dataSet);
        return;
      }
    }
//    print("Middle " + widget.dataSet.toString());

    ex.id = 0;
    widget.dataSet.add({
      'date': yesterdaysDate.toIso8601String(),
      'exercises': [ex],
    });

//    print("End " + widget.dataSet.toString());
    storage.save(widget.dataSet);
  }

  void addExercise(Exercise ex) {
    setState(() {
      excCount++;

      if (widget.dataSet.length == 0) {
        ex.id = 0;
        widget.dataSet.add({
          'date': todaysDate.toIso8601String(),
          'exercises': [ex]
        });
      } else {
        ex.id = widget.dataSet[dateIndex]['exercises'].length;
        widget.dataSet[dateIndex]['exercises'].add(ex);
      }
    });
    storage.save(widget.dataSet);
  }

  Future _getData() async {
    var data = await storage.readData();
//    await new Future.delayed(new Duration(microseconds: 1));
    return data;
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
    String exerciseCounter = "  ";
    if (excCount != null)
      exerciseCounter = excCount.toString();

    String setCounter = "  ";
    if (setsDone != null)
      setCounter = setsDone.toString();

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
                      "$exerciseCounter Exercises",
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
                      "$setCounter Sets",
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
                List<dynamic> exerciseList = new List();
                if (widget.dataSet.length != 0)
                  exerciseList = widget.dataSet[dateIndex]['exercises'];
                return ExerciseCreationPopup(
                  exerciseList: exerciseList,
                  addExercise: addExercise,
//                  addExercise: addExerciseYesterday,
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
//      print(dateIndex);
//      print(snapshot.data);
      if (snapshot.data.length == 0)
        values = [];
      else {
        values = snapshot.data[dateIndex]['exercises'];
      }
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
//      return new ListView.builder(
//        primary: false,
//        shrinkWrap: true,
//        itemCount: values.length,
//        itemBuilder: (BuildContext context, int index) {
////          print(values);
//          return new Column(
//            children: <Widget>[
//              ExerciseCard(
//                exercise: Exercise.fromJson(values[index]),
//                deleteExercise: removeExercise,
//                updateSets: updateSets,
//              ),
//            ],
//          );
//        },
//      );
    }

    var futureBuilder = new FutureBuilder(
      future: _getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          return new Text('loading...');
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
