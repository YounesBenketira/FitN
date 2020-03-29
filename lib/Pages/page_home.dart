import 'package:bordered_text/bordered_text.dart';
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
  static List<dynamic> dataSetCopy;

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
    dataSetCopy = widget.dataSet;

    _updateDataSet();
    getDateIndex();

//    excCount = widget.dataSet[dateIndex]['exercises'].length;

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
//            yesterIndex = dateIndex + 1;
          });

      if (dateIndex == null) {
        setState(() {
          widget.dataSet
              .add({'date': todaysDate.toIso8601String(), 'exercises': []});
          dateIndex = widget.dataSet.length - 1;
//          yesterIndex = dateIndex + 1;
          storage.save(widget.dataSet);
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
        print(dateIndex);
        print(data);
        exerciseList = data[dateIndex]['exercises'];
      }

      int setCount = 0;
      for (int i = 0; i < exerciseList.length; i++) {
        Exercise temp = Exercise.fromJson(exerciseList[i]);
        int sets = temp.getSetCount();
        setCount += sets;
      }

      setState(() {
        setsDone = setCount;
        excCount = exerciseList.length;
        _updateDataSet();
      });
    });
  }

  void _updateDataSet() {
    Future<List<dynamic>> future = storage.readData();

    future.then((var data) {
//      print(data);
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
//    print("BEFORE: " + widget.dataSet.toString());
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
//    print("AFTER: " + widget.dataSet.toString());
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
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 150,
//              decoration: BoxDecoration(
//                gradient: LinearGradient(
//                  begin: Alignment.topLeft,
//                  end: Alignment.bottomRight,
//                  colors: [
//                    Colors.lightBlueAccent,
//                    Colors.greenAccent,
//                  ],
//                ),
//              ),
              child: FittedBox(
                  fit: BoxFit.fill, child: Image.asset('images/unnamed.jpg')),
//              child: Image.network(
//                  'https://wallpapercave.com/wp/wp4250294.jpg'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                width: double.infinity,
                child: BorderedText(
                  strokeWidth: 1.5,
                  child: Text(
                    '$formattedDate',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontFamily: 'OpenSans-Bold',
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 130.0),
              child: _buildAddBtn(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 176),
              child: _buildExerciseList(),
            ),
          ],
        ),
      ],
    );
  }

//  @override
//  Widget build(BuildContext context) {
//    return ListView(
//      scrollDirection: Axis.vertical,
//      children: <Widget>[
////        _buildDayInformation(),
//        _buildAddBtn(),
//        _buildExerciseList(),
//      ],
//    );
//  }

  Widget _buildDayInformation() {
    String exerciseCounter = "0";
    if (excCount != null) exerciseCounter = excCount.toString();

    String setCounter = "0";
    if (setsDone != null) setCounter = setsDone.toString();

    Widget card = Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 15, left: 12, right: 12),
      child: Container(
        height: 125,
//        color: Colors.white,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8.0, // has the effect of softening the shadow
                  spreadRadius: 1, // has the effect of extending the shadow
                  offset: Offset(
                    1.1, // horizontal, move right 10
                    4.0, // vertical, move down 10
                  ),
                )
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              )),
          width: double.infinity,
        ),
      ),
    );

    return Stack(
      children: <Widget>[
        card,
        Padding(
          padding: const EdgeInsets.only(top: 52, left: 60, right: 60),
          child: Center(
            child: Container(
              width: double.infinity,
              height: 2,
              color: Colors.black87,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Center(
            child: Text(
              formattedDate,
              style: TextStyle(
                fontSize: 28,
                fontFamily: 'OpenSans',
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Positioned(
          left: 35,
          top: 50,
          child: Text(
            'Sets Done',
            style: TextStyle(
              fontSize: 30,
              color: Colors.black,
              fontFamily: 'OpenSans',
//              color: Colors.black54,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        Positioned(
          left: 35,
          top: 85,
          child: Text(
            'Exercises Done',
            style: TextStyle(
              fontSize: 30,
              color: Colors.black,
              fontFamily: 'OpenSans',
//              color: Colors.black54,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        Positioned(
            right: 50,
            top: 51,
            child: Text(
              '$setCounter',
              style: TextStyle(
                fontSize: 35,
                color: Theme.of(context).primaryColor,
              ),
            )),
        Positioned(
            right: 50,
            top: 86,
            child: Text(
              '$exerciseCounter',
              style: TextStyle(
                fontSize: 35,
                color: Theme.of(context).primaryColor,
//              fontWeight: FontWeight.bold
              ),
            )),
      ],
    );
//    return Column(children: <Widget>[
//      Padding(
//        // Today's Date
//        padding: const EdgeInsets.all(15.0),
//        child: Container(
//          width: double.infinity,
//          height: 40,
//          decoration: BoxDecoration(
//            color: Colors.white,
//            boxShadow: [
//              BoxShadow(
//                color: Colors.black26,
//                blurRadius: 8.0,
//                spreadRadius: 0.1,
//                offset: Offset(
//                  1.1, // horizontal, move right 10
//                  2.0, // vertical, move down 10
//                ),
//              )
//            ],
//            borderRadius: BorderRadius.all(Radius.circular(10)),
//          ),
//          child: Center(
//              child: Text(
//            formattedDate,
//            style: TextStyle(
//              fontSize: 28,
//              color: Theme.of(context).primaryColor,
////              color: Colors.black38,
//              fontWeight: FontWeight.bold,
//            ),
//          )),
//        ),
//      ),
//      Padding(
//        // Exercise & Sets Done
//        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
//        child: Container(
//          height: 50,
//          child: Row(
//            children: <Widget>[
//              Expanded(
//                child: Container(
//                  decoration: BoxDecoration(
//                    color: Colors.white,
//                    boxShadow: [
//                      BoxShadow(
//                        color: Colors.black26,
//                        blurRadius: 8.0,
//                        spreadRadius: 0.1,
//                        offset: Offset(
//                          1.1, // horizontal, move right 10
//                          2.0, // vertical, move down 10
//                        ),
//                      )
//                    ],
//                    borderRadius: BorderRadius.all(Radius.circular(10)),
//                  ),
//                  child: Center(
//                    child: Text(
//                      "Exercises $exerciseCounter",
//                      style: TextStyle(
//                        color: Theme.of(context).primaryColor,
////                        color: Colors.black38,
//                        fontWeight: FontWeight.bold,
//                        fontSize: 27,
//                      ),
//                    ),
//                  ),
//                ),
//              ),
//              Container(
//                width: 20,
//              ),
//              Expanded(
//                child: Container(
//                  decoration: BoxDecoration(
//                    color: Colors.white,
//                    boxShadow: [
//                      BoxShadow(
//                        color: Colors.black26,
//                        blurRadius: 8.0,
//                        spreadRadius: 0.1,
//                        offset: Offset(
//                          1.1, // horizontal, move right 10
//                          2.0, // vertical, move down 10
//                        ),
//                      )
//                    ],
//                    borderRadius: BorderRadius.all(Radius.circular(10)),
//                  ),
//                  child: Center(
//                    child: Text(
//                      "Sets $setCounter",
//                      style: TextStyle(
//                        fontSize: 28,
//                        color: Theme.of(context).primaryColor,
////                        color: Colors.black38,
//                        fontWeight: FontWeight.bold,
//                      ),
//                    ),
//                  ),
//                ),
//              ),
//            ],
//          ),
//        ),
//      )
//    ]);
  }

  Widget _buildAddBtn() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          height: 40,
          width: 120,
          child: RaisedButton(
            color: Colors.lightBlueAccent,
            elevation: 5,
            onPressed: () {},
            child: Text(
              "Copy",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
        Container(
          height: 40,
          width: 220,
          child: RaisedButton.icon(
            elevation: 5,
            icon: Icon(
              Icons.add,
              size: 30,
              color: Colors.white,
            ),
            label: Text(
              "Add Exercise",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            highlightElevation: 8,
            color: Colors.greenAccent[400],
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
                  );
                },
              );
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
      ],
    );
  }

  AsyncSnapshot lastSnapshot;

  Widget _buildExerciseList() {
    Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
      List<dynamic> values;

      if (snapshot.data.length == 0)
        values = [];
      else {
        values = snapshot.data[dateIndex]['exercises'];
      }

      return new ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        primary: false,
        shrinkWrap: true,
        itemCount: values.length,
        itemBuilder: (BuildContext context, int index) {
          return new Column(
//            crossAxisAlignment: CrossAxisAlignment.center,
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

    var futureBuilder = new FutureBuilder(
      future: _getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            if (lastSnapshot == null) return new Text('');
            return createListView(context, lastSnapshot);
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else {
              lastSnapshot = snapshot;
              return createListView(context, snapshot);
            }
        }
      },
    );

    return futureBuilder;
  }
}
