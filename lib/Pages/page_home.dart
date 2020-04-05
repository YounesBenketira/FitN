import 'package:bordered_text/bordered_text.dart';
import 'package:fit_k/Logic/data_storage.dart';
import 'package:fit_k/Logic/exercise.dart';
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
  List<dynamic> dataSet;

  HomePage({Key key, this.dataSet}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Storage _storage;

  DateTime _todaysDate = Storage.todaysDate;
  String _formattedDate;

  int _dateIndex;

  static List<dynamic> _futureData;

  @override
  void initState() {
    _storage = Storage();
    _updateDataSet();
    _getDateIndex();

    var formatter = new DateFormat.yMMMMd('en_US');
    _formattedDate = formatter.format(_todaysDate);

    _futureData = widget.dataSet;

    super.initState();
  }

  void _getDateIndex() {
    Future data = _getData();
    data.then((var value) {
      List<dynamic> dataSet = value;

      for (int i = 0; i < dataSet.length; i++)
        if (DateTime.parse(dataSet[i]['date']) == _todaysDate)
          setState(() {
            _dateIndex = i;
          });

      if (_dateIndex == null) {
        setState(() {
          if (widget.dataSet == null) _updateDataSet();

          widget.dataSet
              .add({'date': _todaysDate.toIso8601String(), 'exercises': []});
          _dateIndex = widget.dataSet.length - 1;
          _storage.save(widget.dataSet);
        });
      }
    });
  }

  void _updateDataSet() {
    Future<List<dynamic>> future = _storage.readData();

    future.then((var data) {
      setState(() {
        widget.dataSet = data;
      });
    });
  }

  void removeExercise(int index) {
    List<dynamic> exerciseList = widget.dataSet[_dateIndex]['exercises'];
    setState(() {
      exerciseList.removeAt(index);
    });

    for (int i = index; i < exerciseList.length; i++) {
      Exercise temp;
      if (exerciseList[i].runtimeType == Exercise)
        temp = exerciseList[i];
      else
        temp = Exercise.fromJson(exerciseList[i]);

      temp.id--;
      exerciseList[i] = temp.toJson();
    }

    _storage.save(widget.dataSet);
  }

  void addExercise(Exercise ex) {
    setState(() {
      if (widget.dataSet.length == 0) {
        ex.id = 0;
        widget.dataSet.add({
          'date': _todaysDate.toIso8601String(),
          'exercises': [ex]
        });
      } else {
        ex.id = widget.dataSet[_dateIndex]['exercises'].length;
        widget.dataSet[_dateIndex]['exercises'].add(ex);
      }
    });
    _storage.save(widget.dataSet);
  }

  Future _getData() async {
    var data = await _storage.readData();
//    await new Future.delayed(new Duration(microseconds: 1));
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Stack(
          children: <Widget>[
            _buildDayInformation(),
            Padding(
              padding: const EdgeInsets.only(top: 130.0),
              child: _buildButtons(),
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

  Widget _buildDayInformation() {
    return Stack(
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
            fit: BoxFit.fill,
            child: Image.asset('images/Backgrounds/bg1.jpg'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Container(
            width: double.infinity,
            child: BorderedText(
              strokeWidth: 1.5,
              child: Text(
                '$_formattedDate',
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
      ],
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          height: 40,
          width: 120,
          child: RaisedButton(
            color: Colors.lightBlue,
            elevation: 5,
            onPressed: () {},
            child: Text(
              "Copy",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
//            shape:
//                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
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
//          color: Colors.lightBlueAccent,
            onPressed: () {
              Navigator.of(context).pushNamed(
                '/creationPage',
                arguments: addExercise,
              );
            },
//            shape:
//                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
      ],
    );
  }

  Widget _buildButtons2() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        FlatButton(
          color: Colors.white,
          highlightColor: Colors.blue.withOpacity(0.2),
          child: Text(
            'Copy',
            style: TextStyle(
                color: Colors.blue, fontSize: 25, fontFamily: 'OpenSans'),
          ),
          onPressed: () {},
        ),
        FlatButton(
          color: Colors.white,
          highlightColor: Colors.greenAccent.withOpacity(0.2),
          child: Text(
            'Add Exercise',
            style: TextStyle(
                color: Colors.greenAccent,
                fontSize: 25,
                fontFamily: 'OpenSans'),
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  AsyncSnapshot _lastSnapshot =
      AsyncSnapshot.withData(ConnectionState.done, _futureData);

  Widget _buildExerciseList() {
    Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
      List<dynamic> values;
//      print('DATA = ' + snapshot.data.toString());
//      print('INDEX = ' + _dateIndex.toString());
//      print(snapshot.data[_dateIndex]);
      if (snapshot.data == null || snapshot.data.length == 0)
        values = [];
      else {
        // @TODO can cause error in future
        if (_dateIndex == null) _dateIndex = snapshot.data.length - 1;
        values = snapshot.data[_dateIndex]['exercises'];
      }

      return Container(
//        color: Colors.purple,
        child: new ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          primary: false,
          shrinkWrap: true,
          itemCount: values.length,
          itemBuilder: (BuildContext context, int index) {
            Exercise temp;
            if (values[index].runtimeType == Exercise)
              temp = values[index];
            else
              temp = Exercise.fromJson(values[index]);

            return new Column(
              children: <Widget>[
                ExerciseCard(
                  exercise: temp,
                  deleteExercise: removeExercise,
                  updateDataSet: _updateDataSet,
                ),
              ],
            );
          },
        ),
      );
    }

    var futureBuilder = new FutureBuilder(
      future: _getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            if (_lastSnapshot == null) return new Text('');
            return createListView(context, _lastSnapshot);
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else {
//              print(snapshot);
              _lastSnapshot = snapshot;
              return createListView(context, snapshot);
            }
        }
      },
    );

    return futureBuilder;
  }
}
