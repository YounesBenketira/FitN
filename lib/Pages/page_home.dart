import 'dart:async';

import 'package:fit_k/Enums/cardTheme.dart';
import 'package:fit_k/Logic/data_storage.dart';
import 'package:fit_k/Logic/exercise.dart';
import 'package:fit_k/UI/card_Exercise.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  List<dynamic> dataSet;
  Function showSnackbar;
  Function savePageData;
  Function readPageData;
  Timer timer;

  HomePage(
      {Key key,
      this.dataSet,
      this.showSnackbar,
      this.savePageData,
      this.readPageData})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  Storage _storage;
  DateTime _todaysDate = Storage.todaysDate;
  String _formattedDate;
  int _dateIndex;
  static List<dynamic> _futureData;

  AnimationController controller;

  // Timer variables
  bool showTimer = false;
  int lastLength;
  String countdownTime = '00:00';
  TextEditingController timeController;

  @override
  void initState() {
    timeController = TextEditingController();

    var data = widget.readPageData();
    if (data != null && widget.timer != null) {
      widget.timer.cancel();
      setState(() {
        countdownTime = data;

        showTimer = true;

        _startTimer();
      });
    }

    _storage = Storage();

    _updateDataSet();
    _getDateIndex();

    var formatter = new DateFormat.MMMMEEEEd('en_US');
    _formattedDate = formatter.format(_todaysDate);

    _futureData = widget.dataSet;

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );

    super.initState();
  }

  void _getDateIndex() {
    Future data = _getData();
    data.then((var value) {
      List<dynamic> dataSet = value;

      _dateIndex = null;
      for (int i = 0; i < dataSet.length; i++) {
        if (DateTime.parse(dataSet[i]['date']) == _todaysDate) {
          setState(() {
            _dateIndex = i;
          });
        }
      }

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
    _futureData = widget.dataSet;
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
//        print(widget.dataSet.length);
//        print(_dateIndex);
        ex.id = widget.dataSet[_dateIndex]['exercises'].length;
        widget.dataSet[_dateIndex]['exercises'].add(ex);
      }
    });

    _futureData = widget.dataSet;
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
            _buildPageHeader(),
            Padding(
              padding: const EdgeInsets.only(top: 180.0),
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 130.0),
              child: _buildButtons(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 185),
              child: _buildExerciseList(),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    timeController.dispose();
    super.dispose();
  }

  void _pauseTimer() {
    if (widget.timer != null) {
      widget.savePageData(countdownTime);
      widget.timer.cancel();
    }
  }

  void _startTimer() {
    List time;
    if (countdownTime == '00:00') {
      setState(() {
        countdownTime = timeController.text;
      });

      List temp = timeController.text.split(':');
      time = [int.parse(temp[0]), int.parse(temp[1])];

      timeController.text = '';

      if (time[1] > 60) time[1] = 60;
    } else {
      List temp = countdownTime.split(':');
      time = [int.parse(temp[0]), int.parse(temp[1])];
    }

    widget.timer = Timer.periodic(Duration(seconds: 1), (timezr) {
      if (time[1] != 0) time[1]--;

      String minutes;
      String seconds;

      time[0] < 10
          ? minutes = '0' + time[0].toString()
          : minutes = time[0].toString();
      time[1] < 10
          ? seconds = '0' + time[1].toString()
          : seconds = time[1].toString();

      if (mounted)
        setState(() {
          countdownTime = minutes + ':' + seconds;
        });
      else {
        countdownTime = minutes + ':' + seconds;
        widget.savePageData(countdownTime);
      }

      if (time[1] == 0) {
        if (time[0] == 0) {
          widget.timer.cancel();
          widget.timer = null;
          showTimer = false;
        }
        time[0]--;
        time[1] = 60;
      }
    });
  }

  Widget _buildPageHeader() {
    if (widget.dataSet == null || widget.dataSet.length == 0)
      widget.dataSet = [
        {'date': _todaysDate.toIso8601String(), 'exercises': []}
      ];
    if (_dateIndex == null) {
      if (widget.dataSet.length == 0)
        _dateIndex = 0;
      else
        _dateIndex = widget.dataSet.length - 1;
    }

    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 220,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xff17EAD9),
                Color(0xff6078EA),
              ],
            ),
          ),
//          child: FittedBox(
//            fit: BoxFit.fill,
//            child: Image.asset('images/Backgrounds/bg2.jpg'),
//          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 12.5),
          child: Container(
            width: double.infinity,
            child: Text(
              '$_formattedDate',
//              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontFamily: 'OpenSans-Bold',
                fontWeight: FontWeight.w500,
              ),
//                textAlign: TextAlign.left,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 59, left: 60.0, right: 60.0),
          child: Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                border:
                Border.all(color: Colors.white.withOpacity(0.8), width: 2),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.replay,
                      size: 30,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        showTimer = false;
                        widget.timer.cancel();
                        widget.timer = null;
                        countdownTime = '00:00';
                        timeController.text = '';
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
//                    color: Colors.pink,
                        child: showTimer
                            ? Container(
                          width: 100,
                          child: Text(
                            countdownTime,
//                          textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white, fontSize: 35),
                          ),
                        )
                            : Container(
                          width: 100,
                          child: TextField(
                            controller: timeController,
                            onChanged: (time) {
                              if (lastLength == 3 &&
                                  time.length < lastLength ||
                                  lastLength == time.length) {
                                timeController.value =
                                    timeController.value.copyWith(
                                        text: time.substring(0, 0),
                                        selection:
                                        const TextSelection.collapsed(
                                            offset: 0));
                              } else if (time.length == 2) {
                                timeController.value =
                                    timeController.value.copyWith(
                                        text: time + ':',
                                        selection:
                                        const TextSelection.collapsed(
                                            offset: 3));
                              } else if (time.length > 5) {
                                timeController.value =
                                    timeController.value.copyWith(
                                        text: time.substring(0, 5),
                                        selection:
                                        const TextSelection.collapsed(
                                            offset: 5));
                              }
                              lastLength = time.length;
                            },
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                            ),
                            decoration: InputDecoration.collapsed(
                              hintText: countdownTime,
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 35,
                              ),
                            ),
                          ),
                        )),
                  ),
                  IconButton(
                    icon: showTimer
                        ? Icon(
                      Icons.pause,
                      size: 35,
                      color: Colors.white,
                    )
                        : Icon(
                      Icons.play_arrow,
                      size: 35,
                      color: Colors.white,
                    ),
                    splashColor: Colors.white,
                    onPressed: () {
                      if ((timeController.text == '' ||
                          timeController.text.contains(' ') ||
                          timeController.text.contains('-') ||
                          timeController.text.contains('.') ||
                          timeController.text.contains(',')) &&
                          countdownTime == '00:00') {
                        final snackBar = SnackBar(
                          content: Text(
                            'Incorrect Input!',
//                            textAlign: TextAlign.center,
                          ),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                        );
                        Scaffold.of(this.context).showSnackBar(snackBar);
                        return;
                      }
                      setState(() {
                        showTimer = !showTimer;
                      });
                      showTimer ? _startTimer() : _pauseTimer();
                    },
                  ),
                ],
              )),
        ),
      ],
    );
  }

  Widget _buildButtons() {
    List pastWorkouts;
    if (widget.dataSet == null)
      pastWorkouts = [];
    else
      pastWorkouts = widget.dataSet.map((entry) {
        if (entry['date'] == _todaysDate.toIso8601String()) return Container();

        var formatter = new DateFormat.MMMMEEEEd('en_US');
        String weekDay = formatter.format(DateTime.parse(entry['date']));

        if (entry['exercises'].length == 0) return Container();
        List<Exercise> exercises = List();
        if (entry['exercises'][0] is Exercise)
          exercises = entry['exercises'];
        else {
          for (int i = 0; i < entry['exercises'].length; i++) {
            exercises.add(Exercise.fromJson(entry['exercises'][i]));
          }
        }

        List temp = new List();

        for (int i = 0; i < exercises.length; i++) {
          Exercise exercise = exercises[i];
          if (exercise.setList.length > 0)
            temp.add(Exercise(
                workout: exercise.workout,
                theme: exercise.theme,
                id: temp.length));
        }

        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            onTap: () {
              for (int i = 0; i < widget.dataSet.length; i++) {
                if (widget.dataSet[i]['date'] ==
                    _todaysDate.toIso8601String()) {
                  setState(() {
                    widget.dataSet[i]['exercises'] = List.from(temp);
                  });
                }
              }
              _storage.save(widget.dataSet);
              Navigator.of(context).pop();
              final snackBar = SnackBar(
                content: Text('Workout Copied Successfully!'),
                backgroundColor: Colors.blueAccent[400],
                duration: Duration(seconds: 2),
              );
              Scaffold.of(this.context).showSnackBar(snackBar);
            },
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.6),
                    blurRadius: 5.0,
                    // has the effect of softening the shadow
                    spreadRadius: 1.5,
                    // has the effect of extending the shadow
                    offset: Offset(
                      0.5,
                      // horizontal, move right 10
                      1.5, // vertical, move down 10
                    ),
                  )
                ],
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 10),
                    child: Align(
                      child: Text(
                        weekDay,
                        style: TextStyle(
                            fontSize: 20, fontFamily: 'OpenSans-Bold'),
                      ),
                      alignment: Alignment.topLeft,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                      width: double.infinity,
                      height: 35,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          ...exercises.map((entry) {
                            Color color;
                            // Yellow, Blue, Purple, Peach, Green
                            switch (entry.theme) {
                              case ColorTheme.Red:
                                color = Colors.red;
                                break;
                              case ColorTheme.Blue:
                                color = Colors.blue;
                                break;
                              case ColorTheme.Pink:
                                color = Colors.pinkAccent;
                                break;
                              case ColorTheme.Peach:
                                color = Colors.orangeAccent;
                                break;
                              case ColorTheme.Green:
                                color = Colors.green;
                                break;
                            }

                            return Row(
                              children: <Widget>[
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                  ),
                                ),
                                Container(
                                  width: 5,
                                ),
                                Text(
                                  entry.title,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'OpenSans',
                                  ),
                                ),
                                Container(
                                  width: 15,
                                ),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList();

    bool showList = false;
    for (int i = 0; i < pastWorkouts.length; i++)
      if (pastWorkouts[i].runtimeType == Padding) showList = true;

    Widget copyDialog = Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//                  elevation: 16,
        child: Container(
            width: double.infinity,
            height: 350,
            child: showList
                ? ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[...pastWorkouts],
            )
                : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  decoration: BoxDecoration(
//                            color: Colors.blueAccent.withOpacity(0.5),
                      border: Border.all(
                          color: Colors.grey.withOpacity(0.8), width: 2),
                      borderRadius:
                      BorderRadius.all(Radius.circular(20))),
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Text(
                        'No Workouts Found!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'OpenSans',
                            color: Colors.grey.withOpacity(0.9)),
                      ),
                    ),
                  )),
            )));

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          height: 40,
//          width: 120,
//          color: Colors.transparent,
          child: RaisedButton(
//            shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.all(
//                  Radius.circular(15),
//                ),
//                side: BorderSide(color: Colors.white)),
            color: Colors.white.withOpacity(0.3),
            highlightColor: Colors.white.withOpacity(0.5),
            splashColor: Colors.white.withOpacity(0.5),
            elevation: 0,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return copyDialog;
                  });
            },
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
//          width: 220,
          child: RaisedButton.icon(
            color: Colors.white.withOpacity(0.3),
            highlightColor: Colors.white.withOpacity(0.5),
            splashColor: Colors.white.withOpacity(0.5),
//            shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.all(
//                  Radius.circular(15),
//                ),
//                side: BorderSide(color: Colors.white)),
            elevation: 0,
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
//            color: Colors.greenAccent[400],
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

  AsyncSnapshot _lastSnapshot =
      AsyncSnapshot.withData(ConnectionState.done, _futureData);

  Widget _buildExerciseList() {
//    print(_lastSnapshot);
    Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
      List<dynamic> values;
//      print('DATA = ' + snapshot.data.toString());
//      print('INDEX = ' + _dateIndex.toString());
//      print(snapshot.data[_dateIndex]);
      if (snapshot.data == null || snapshot.data.length == 0)
        values = [];
      else {
        // @TODO can cause error in future
        if (_dateIndex == null || _dateIndex >= snapshot.data.length)
          _dateIndex = snapshot.data.length - 1;
        values = snapshot.data[_dateIndex]['exercises'];
      }

//      print(snapshot.data);
//      print(_dateIndex);

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
//            print(widget.dataSet);
            if (_lastSnapshot == null) return new Text('');
            return createListView(context, _lastSnapshot);
          default:
//              print('BEFORE ' + _lastSnapshot.toString());
//            print('changeLast');
//              _lastSnapshot = snapshot;
//              _getData().then((value) {
//                print(value);
//              });
//              print('AFTER ' + widget.dataSet.toString());
//          print(snapshot);
            _lastSnapshot = snapshot;
            return createListView(context, snapshot);
        }
      },
    );

    return futureBuilder;
  }
}
