import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fit_k/Logic/data_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class StatisticsPage extends StatefulWidget {
  StatisticsPage({Key key}) : super(key: key);

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  List<dynamic> data;
  Storage _storage;
  int btnIndex;

  @override
  void initState() {
    _storage = Storage();
    _storage.readData().then((value) {
      setState(() {
        data = value;
      });
    });

    btnIndex = 0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget displayData;

    switch (btnIndex) {
      case 0:
        displayData = _buildWorkoutStats();
        break;
      case 1:
        displayData = _buildBodyStats();
        break;
      case 2:
        displayData = _buildStrengthStats();
    }

    return ListView(
      children: <Widget>[
        Container(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
          child: Text(
            'Information',
            style: TextStyle(fontSize: 40, fontFamily: 'OpenSans'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Container(
            height: 30,
            width: double.infinity,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Container(
                    width: 110,
                    child: RaisedButton(
                      color:
                          btnIndex == 0 ? Colors.lightBlueAccent : Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                        side: BorderSide(
                            color: btnIndex == 0 ? Colors.white : Colors.grey),
                      ),
                      child: Text(
                        'Workouts',
                        style: TextStyle(
                          fontSize: 17.5,
                          color: btnIndex == 0 ? Colors.white : Colors.black54,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          btnIndex = 0;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Container(
                    width: 110,
                    child: RaisedButton(
                      color:
                          btnIndex == 1 ? Colors.lightBlueAccent : Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                        side: BorderSide(
                            color: btnIndex == 1 ? Colors.white : Colors.grey),
                      ),
                      child: Text(
                        'Body',
                        style: TextStyle(
                          fontSize: 17.5,
                          color: btnIndex == 1 ? Colors.white : Colors.black54,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          btnIndex = 1;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Container(
                    width: 110,
                    child: RaisedButton(
                      color:
                          btnIndex == 2 ? Colors.lightBlueAccent : Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                        side: BorderSide(
                            color: btnIndex == 2 ? Colors.white : Colors.grey),
                      ),
                      child: Text(
                        'Strength',
                        style: TextStyle(
                          fontSize: 17.5,
                          color: btnIndex == 2 ? Colors.white : Colors.black54,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          btnIndex = 2;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        displayData,
      ],
    );
  }

  Widget _buildWorkoutStats() {
    String highestWeightLabel = 'Heaviest Lift';
    String mostDoneLabel = 'Most Sets';
    String distanceRanLabel = 'Distance Ran';
    String averageLabel = 'Days/Week';

    int highestWeight = 0;
    if (data != null) {
      for (int i = 0; i < data.length; i++)
        for (int k = 0; k < data[i]['exercises'].length; k++)
          for (int p = 0; p < data[i]['exercises'][k]['setList'].length; p++)
            if (data[i]['exercises'][k]['setList'][p.toString()][1] >
                highestWeight) {
              // @TODO extract more info
              highestWeight =
                  data[i]['exercises'][k]['setList'][p.toString()][1];
            }
    }

    String highestWeightData = highestWeight.toString() + ' lbs';

    int setsDone = 0;
    String exerciseName = '';

    if (data != null) {
      for (int i = 0; i < data.length; i++)
        for (int k = 0; k < data[i]['exercises'].length; k++)
          if (data[i]['exercises'][k]['setList'].length > setsDone) {
            setsDone = data[i]['exercises'][k]['setList'].length;
            exerciseName = data[i]['exercises'][k]['title'];
          }
    }

    String mostDoneData = exerciseName + ' (x$setsDone)';

    List<WeekDay> weekDayData = [
      new WeekDay('Sun'),
      new WeekDay('Mon'),
      new WeekDay('Tue'),
      new WeekDay('Wed'),
      new WeekDay('Thurs'),
      new WeekDay('Fri'),
      new WeekDay('Sat'),
    ];

    List<charts.Series<WeekDay, String>> seriesList = [
      new charts.Series<WeekDay, String>(
          id: 'Weekdays',
          colorFn: (WeekDay day, __) {
            if (day.isLastWeek())
              return charts.MaterialPalette.red.shadeDefault;
            else
              return charts.MaterialPalette.blue.shadeDefault;
          },
          domainFn: (WeekDay day, _) => day.name,
          measureFn: (WeekDay day, _) => day._exerciseCount,
          data: weekDayData,
          // Set a label accessor to control the text of the bar label.
          labelAccessorFn: (WeekDay day, _) =>
              '${day._exerciseCount.toString()}')
    ];

    bool isLastWeek = false;
    if (data != null) {
      for (int i = data.length - 1; i > data.length - 8; i--) {
        if (i < 0) break;

        DateTime date = DateTime.parse(data[i]['date']);
        int exerciseCount = 0;
        for (int k = 0; k < data[i]['exercises'].length; k++)
          if (data[i]['exercises'][k]['setList'].length > 0) exerciseCount++;

        switch (date.weekday) {
          case 1: // monday
            weekDayData[1].setExerciseCount(exerciseCount);
            weekDayData[1].lastWeek = isLastWeek;
            break;
          case 2:
            weekDayData[2].setExerciseCount(exerciseCount);
            weekDayData[2].lastWeek = isLastWeek;
            break;
          case 3:
            weekDayData[3].setExerciseCount(exerciseCount);
            weekDayData[3].lastWeek = isLastWeek;
            break;
          case 4:
            weekDayData[4].setExerciseCount(exerciseCount);
            weekDayData[4].lastWeek = isLastWeek;
            break;
          case 5:
            weekDayData[5].setExerciseCount(exerciseCount);
            weekDayData[5].lastWeek = isLastWeek;
            break;
          case 6: // Saturday
            weekDayData[6].setExerciseCount(exerciseCount);
            weekDayData[6].lastWeek = isLastWeek;
            break;
          case 7: // Sunday
            weekDayData[0].setExerciseCount(exerciseCount);
            weekDayData[0].lastWeek = isLastWeek;
            isLastWeek = true;
            break;
        }

//        print(date);
//        print(date.weekday);
      }
    }

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 5.0, // has the effect of softening the shadow
                  spreadRadius: 3, // has the effect of extending the shadow
                  offset: Offset(
                    2.0, // horizontal, move right 10
                    4.0, // vertical, move down 10
                  ),
                )
              ],
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  height: 5,
                ),
                Text(
                  '# Exercises',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      fontFamily: "OpenSans"),
                ),
                Container(
                  height: 120,
//                  child: HorizontalBarLabelChart.withSampleData(),
                  child: ExercisesBarChart(
                    seriesList,
                    animate: true,
                  ),
                )
              ],
            ),
          ),
        ),
        Statistic(
          label: highestWeightLabel,
          data: highestWeightData,
        ),
        Statistic(
          label: mostDoneLabel,
          data: mostDoneData,
        ),
        Statistic(
          label: distanceRanLabel,
          data: '125 km',
        ),
        Statistic(
          label: averageLabel,
          data: '3.5 Days',
        ),
        Container(
          height: 10,
        ),
      ],
    );
  }

  bool showBMIChart = false;
  bool showWHeightChart = false;
  bool showWHipChart = false;
  bool showLBS = true;
  bool showSettings = false;

  String verbalRatingBMI;
  Color verbalColorBMI;
  String verbalRatingWHeightR;
  Color verbalColorWHeightR;
  String verbalRatingWHipR;
  Color verbalColorWHipR;

  double bmi;
  double waistHeightRatio;
  double waistHipRatio;

  Widget _buildBodyStats() {
    TextEditingController heightController = TextEditingController();
    TextEditingController weightController = TextEditingController();
    TextEditingController waistController = TextEditingController();
    TextEditingController hipController = TextEditingController();
    int lastLength = 0;

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 6.0),
          child: InkWell(
            onTap: () {
              setState(() {
                showSettings = !showSettings;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    'Measurements',
                    style: TextStyle(fontSize: 25, fontFamily: 'OpenSans-Bold'),
                  ),
                ),
                showSettings
                    ? Icon(Icons.arrow_drop_down)
                    : Icon(Icons.arrow_right),
              ],
            ),
          ),
        ),
        showSettings
            ? Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: 140,
                child: RaisedButton(
                  color: showLBS ? Colors.blue : Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(6.0),
                    side: BorderSide(
                        color: showLBS ? Colors.white : Colors.grey),
                  ),
                  child: Text(
                    'LBS & Inches',
                    style: TextStyle(
                      fontSize: 17.5,
                      color: showLBS ? Colors.white : Colors.black54,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      showLBS = true;
                    });
                  },
                ),
              ),
              Container(
                width: 140,
                child: RaisedButton(
                  color: showLBS ? Colors.white : Colors.blue,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(6.0),
                    side: BorderSide(
                        color: showLBS ? Colors.grey : Colors.white),
                  ),
                  child: Text(
                    'Kgs & CM',
                    style: TextStyle(
                      fontSize: 17.5,
                      color: showLBS ? Colors.black54 : Colors.white,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      showLBS = false;
                    });
                  },
                ),
              )
            ],
          ),
        )
            : Container(),
        Align(
            alignment: Alignment.topLeft,
            child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Body Mass Index (BMI)',
                      style:
                      TextStyle(fontSize: 25, fontFamily: 'OpenSans-Bold'),
                    ),
                    Container(
                      width: 50,
                      child: Image.asset("images/scale.png"),
                    ),
                  ],
                ))),
        showBMIChart
            ? Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
              child: Container(
                width: double.infinity,
                height: 300,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: showLBS
                      ? Image.asset(
                      'images/Statistics/LBS-&-Inches-Chart.png')
                      : Image.asset(
                      'images/Statistics/KGS-&-CM-CHART.png'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
              child: Text(
                bmi.round().toString() + " = " + verbalRatingBMI,
                style: TextStyle(
                    fontSize: 25,
                    color: verbalColorBMI,
                    fontFamily: "OpenSans-Bold"),
              ),
            ),
          ],
        )
            : Container(),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 8.0),
                  child: TextField(
                      controller: weightController,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme
                            .of(context)
                            .primaryColorDark,
                        fontSize: 20,
                      ),
//                  controller: _repController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: showLBS ? "Weight (lbs.)" : "Weight (kgs.)",
                          hintStyle: TextStyle(
                              color: Theme
                                  .of(context)
                                  .primaryColor,
                              fontSize: 20),
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
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 12.0),
                  child: TextField(
                    controller: heightController,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme
                          .of(context)
                          .primaryColorDark,
                      fontSize: 20,
                    ),
//                  controller: _repController,
                    keyboardType: TextInputType.number,
                    onChanged: (text) {
                      int inputLength = text.length;

                      if (!showLBS) return;

                      if (inputLength == 1) {
                        if (lastLength == 0) {
                          heightController.value =
                              heightController.value.copyWith(
                                text: text + "\"",
                                selection: const TextSelection.collapsed(
                                    offset: 2),
                              );
                        } else {
                          lastLength = 0;
                          heightController.value =
                              heightController.value.copyWith(
                                text: "",
                                selection: const TextSelection.collapsed(
                                    offset: 0),
                              );
                          return;
                        }
                      } else if (inputLength > 4) {
                        heightController.value =
                            heightController.value.copyWith(
                              text: text.substring(0, 4),
                              selection: const TextSelection.collapsed(
                                  offset: 4),
                            );
                      }

                      lastLength = inputLength;
                    },
                    decoration: InputDecoration(
                        hintText: showLBS ? "Height (Ft\"in)" : "Height (cm)",
                        hintStyle: TextStyle(
                            color: Theme
                                .of(context)
                                .primaryColor,
                            fontSize: 20),
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
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            width: 120,
            child: RaisedButton(
              color: Colors.white,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
//                side: BorderSide(color: Colors.red)
              ),
              child: Text(
                'Calculate',
                style: TextStyle(
                    fontSize: 17.5,
                    color: Colors.lightBlueAccent,
                    fontFamily: 'OpenSans'),
              ),
              onPressed: () {
                //@TODO Toast when invalid entries
                //@TODO error handling

                try {
                  double.parse(heightController.text.toString()[0]);
                  double.parse(heightController.text.toString().substring(2));
                  double.parse(weightController.text);
                } on RangeError catch (e) {
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
                } on FormatException catch (e) {
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

                String heightInput = heightController.text.toString();
                double heightInches = (double.parse(heightInput[0]) * 12) +
                    double.parse(heightInput.substring(2));
                double heightMeters = ((double.parse(heightInput[0]) * 30.48) +
                    (double.parse(heightInput.substring(2)) * 2.54)) /
                    100;

                double weight = double.parse(weightController.text);

                if (showLBS)
                  bmi = 703 * (weight / (heightInches * heightInches));
                else
                  bmi = weight / heightMeters * heightMeters;

                setState(() {
                  if (bmi < 18) {
                    verbalRatingBMI = "Underweight";
                    verbalColorBMI = Colors.blueAccent;
                  } else if (bmi < 25) {
                    verbalRatingBMI = "Healthy";
                    verbalColorBMI = Colors.green;
                  } else if (bmi < 30) {
                    verbalRatingBMI = "Overweight";
                    verbalColorBMI = Colors.yellow;
                  } else {
                    verbalRatingBMI = "Extremely Obese";
                    verbalColorBMI = Colors.red;
                  }

                  showBMIChart = true;
                });
              },
            ),
          ),
        ),
        Container(
          height: 10,
        ),
        Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Waist / Height Ratio',
                    style: TextStyle(fontSize: 26, fontFamily: 'OpenSans-Bold'),
                  ),
                  Container(
                    width: 60,
                    child: Image.asset("images/diet.png"),
                  ),
                ],
              ),
            )),
        showWHeightChart
            ? Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 5.0, top: 5.0, left: 10, right: 10),
              child: Container(
                width: double.infinity,
                height: 250,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Image.asset(
                      'images/Statistics/WaistHeightRatioChart.png'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
              child: Text(
                waistHeightRatio.toStringAsFixed(3) +
                    " = " +
                    verbalRatingWHeightR,
                style: TextStyle(
                    fontSize: 25,
                    color: verbalColorWHeightR,
                    fontFamily: "OpenSans-Bold"),
              ),
            ),
          ],
        )
            : Container(),
        Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 8.0),
                child: TextField(
                    controller: waistController,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme
                          .of(context)
                          .primaryColorDark,
                      fontSize: 20,
                    ),
//                  controller: _repController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: showLBS ? "Waist (in)" : "Waist (cm)",
                        hintStyle: TextStyle(
                            color: Theme
                                .of(context)
                                .primaryColor,
                            fontSize: 20),
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
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 12.0),
                child: TextField(
                  controller: heightController,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme
                        .of(context)
                        .primaryColorDark,
                    fontSize: 20,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (text) {
                    int inputLength = text.length;

                    if (!showLBS) return;

                    if (inputLength == 1) {
                      if (lastLength == 0) {
                        heightController.value =
                            heightController.value.copyWith(
                              text: text + "\"",
                              selection: const TextSelection.collapsed(
                                  offset: 2),
                            );
                      } else {
                        lastLength = 0;
                        heightController.value =
                            heightController.value.copyWith(
                              text: "",
                              selection: const TextSelection.collapsed(
                                  offset: 0),
                            );
                        return;
                      }
                    } else if (inputLength > 4) {
                      heightController.value = heightController.value.copyWith(
                        text: text.substring(0, 4),
                        selection: const TextSelection.collapsed(offset: 4),
                      );
                    }

                    lastLength = inputLength;
                  },
                  decoration: InputDecoration(
                      hintText: showLBS ? "Height (Ft\"in)" : "Height (cm)",
                      hintStyle: TextStyle(
                          color: Theme
                              .of(context)
                              .primaryColor, fontSize: 20),
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
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            width: 120,
            child: RaisedButton(
              color: Colors.white,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
//                side: BorderSide(color: Colors.red)
              ),
              child: Text(
                'Calculate',
                style: TextStyle(
                    fontSize: 17.5,
                    color: Colors.lightBlueAccent,
                    fontFamily: 'OpenSans'),
              ),
              onPressed: () {
                double waistCM;
                double heightCM;

                if (showLBS) {
                  try {
                    double.parse(heightController.text[0]);
                    double.parse(heightController.text.substring(2));
                    double.parse(waistController.text);
                  } catch (FormatException) {
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

                  waistCM = double.parse(waistController.text) * 2.54;
                  heightCM = ((double.parse(heightController.text[0]) * 30.48) +
                      (double.parse(heightController.text.substring(2)) *
                          2.54));
                } else {
                  try {
                    double.parse(waistController.text);
                    double.parse(heightController.text);
                  } catch (FormatException) {
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

                  waistCM = double.parse(waistController.text);
                  heightCM = double.parse(heightController.text);
                }

//                print(heightCM.toString() + " " + waistCM.toString());
//                print(waistCM/heightCM);

                setState(() {
                  showWHeightChart = true;
                  waistHeightRatio = waistCM / heightCM;
                  if (waistHeightRatio >= 0.63) {
                    verbalRatingWHeightR = "Highly Obese";
                    verbalColorWHeightR = Colors.red[700];
                  } else if (waistHeightRatio >= 0.58) {
                    verbalRatingWHeightR = "Extremely Overweight";
                    verbalColorWHeightR = Colors.redAccent;
                  } else if (waistHeightRatio >= 0.53) {
                    verbalRatingWHeightR = "Overweight";
                    verbalColorWHeightR = Colors.orangeAccent;
                  } else if (waistHeightRatio >= 0.46) {
                    verbalRatingWHeightR = "Healthy";
                    verbalColorWHeightR = Colors.yellow;
                  } else if (waistHeightRatio >= 0.43) {
                    verbalRatingWHeightR = "Slender & Healthy";
                    verbalColorWHeightR = Colors.lightBlueAccent;
                  } else if (waistHeightRatio >= 0.35) {
                    verbalRatingWHeightR = "Extremely Slim";
                    verbalColorWHeightR = Colors.lightBlue;
                  } else {
                    verbalRatingWHeightR = "Abnormally Slim";
                    verbalColorWHeightR = Colors.blue;
                  }
                });
              },
            ),
          ),
        ),
        Container(
          height: 10,
        ),
        Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Waist / Hip Ratio',
                    style: TextStyle(fontSize: 26, fontFamily: 'OpenSans-Bold'),
                  ),
                  Container(
                    width: 60,
                    child: Image.asset("images/waist.png"),
                  ),
                ],
              ),
            )),
        showWHipChart
            ? Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 5.0, top: 5.0, left: 10, right: 10),
              child: Container(
                width: double.infinity,
                height: 150,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Image.asset(
                      'images/Statistics/WaistHipRatioChart.png'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
              child: Text(
                waistHipRatio.toStringAsFixed(3) +
                    " = " +
                    verbalRatingWHipR,
                style: TextStyle(
                    fontSize: 25,
                    color: verbalColorWHipR,
                    fontFamily: "OpenSans-Bold"),
              ),
            ),
          ],
        )
            : Container(),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 8.0),
                  child: TextField(
                      controller: waistController,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme
                            .of(context)
                            .primaryColorDark,
                        fontSize: 20,
                      ),
//                  controller: _repController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: showLBS ? "Waist (in)" : "Waist (cm)",
                          hintStyle: TextStyle(
                              color: Theme
                                  .of(context)
                                  .primaryColor,
                              fontSize: 20),
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
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 8.0),
                  child: TextField(
                      controller: hipController,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme
                            .of(context)
                            .primaryColorDark,
                        fontSize: 20,
                      ),
//                  controller: _repController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: showLBS ? "Hip (in)" : "Hip (cm)",
                          hintStyle: TextStyle(
                              color: Theme
                                  .of(context)
                                  .primaryColor,
                              fontSize: 20),
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
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            width: 120,
            child: RaisedButton(
              color: Colors.white,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
//                side: BorderSide(color: Colors.red)
              ),
              child: Text(
                'Calculate',
                style: TextStyle(
                    fontSize: 17.5,
                    color: Colors.lightBlueAccent,
                    fontFamily: 'OpenSans'),
              ),
              onPressed: () {
                double waist;
                double hip;

                try {
                  waist = double.parse(waistController.text);
                  hip = double.parse(hipController.text);
                } catch (e) {
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

                if (showLBS) {} else {}

                setState(() {
                  showWHipChart = true;

                  waistHipRatio = waist / hip;

                  if (waistHipRatio >= 1) {
                    verbalRatingWHipR = "High Risk";
                    verbalColorWHipR = Colors.red[700];
                  } else if (waistHipRatio >= 0.96) {
                    verbalRatingWHipR = "Moderate Risk";
                    verbalColorWHipR = Colors.orangeAccent;
                  } else {
                    verbalRatingWHipR = "Low health risk";
                    verbalColorWHipR = Colors.green;
                  }
                });
              },
            ),
          ),
        ),
        Container(
          height: 10,
        ),
      ],
    );
  }

  bool isMale = true;
  bool showChart = false;
  String imageSource;
  List ratingRanges;
  int weightRangeIndex;
  int bodyWeight;
  int oneRepMax;

  String verbalRating;
  Color verbalColor;

  String _exercise;
  List _exerciseOptions = [
    "Bench Press",
    "Squat",
    "Deadlift",
    "Military Press"
  ];

  double averageWeightLifted = 0;

  Widget _buildStrengthStats() {
    TextEditingController weightController = new TextEditingController();
    TextEditingController liftController = new TextEditingController();

    if (data != null) {
      double sum = 0;
      int count = 0;
      for (int i = data.length - 1; i > data.length - 8; i--) {
        if (i < 0) break;
        for (int k = 0; k < data[i]['exercises'].length; k++)
          for (int p = 0; p < data[i]['exercises'][k]['setList'].length; p++) {
            sum += data[i]['exercises'][k]['setList'][p.toString()][1];
            count++;
          }
      }

      averageWeightLifted = sum / count;
    }

    if (averageWeightLifted.isNaN) averageWeightLifted = 0;

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
              left: 25.0, right: 25.0, top: 10.0, bottom: 20.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 5.0, // has the effect of softening the shadow
                  spreadRadius: 3, // has the effect of extending the shadow
                  offset: Offset(
                    2.0, // horizontal, move right 10
                    4.0, // vertical, move down 10
                  ),
                )
              ],
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  height: 5,
                ),
                Text(
                  'Average Weight Lifted',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      fontFamily: "OpenSans"),
                ),
                Container(
                  height: 100,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 7.5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
//                            height: 50,
                            width: 60,
                            child: Image.asset("images/Exercises/Barbell.png"),
                          ),
                          Container(
                            width: 10,
                          ),
                          Text(
                            averageWeightLifted.toStringAsFixed(2) + " lbs",
                            style: TextStyle(
                                fontSize: 45, color: Colors.lightBlueAccent),
                          ),
                        ],
                      ),
                      Text(
                        "in the last week",
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              "Strength Standards",
              style: TextStyle(
                  fontSize: 30,
                  fontFamily: "OpenSans",
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        showChart
            ? Column(
          children: <Widget>[
            Container(
              height: 10,
            ),
            Container(
//                    width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[400],
                    blurRadius:
                    5, // has the effect of softening the shadow
                    spreadRadius:
                    1, // has the effect of extending the shadow
                    offset: Offset(
                      1.0, // horizontal, move right 10
                      2.0, // vertical, move down 10
                    ),
                  )
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 5.0, right: 5.0, top: 2.5, bottom: 2.5),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Weight Class",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Text(
                      ratingRanges[weightRangeIndex][0].toString() +
                          " lbs",
                      style: TextStyle(fontSize: 17.5),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 5.0, top: 5.0, left: 10, right: 10),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[400],
                      blurRadius:
                      5, // has the effect of softening the shadow
                      spreadRadius:
                      1, // has the effect of extending the shadow
                      offset: Offset(
                        1.0, // horizontal, move right 10
                        2.0, // vertical, move down 10
                      ),
                    )
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 7, bottom: 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            "Beginner",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(ratingRanges[weightRangeIndex][1]
                              .toString()),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            "Novice",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                          Text(ratingRanges[weightRangeIndex][2]
                              .toString()),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            "Intermediate",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                          Text(ratingRanges[weightRangeIndex][3]
                              .toString()),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            "Advanced",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.purple),
                          ),
                          Text(ratingRanges[weightRangeIndex][4]
                              .toString()),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            "Elite",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orangeAccent),
                          ),
                          Text(ratingRanges[weightRangeIndex][5]
                              .toString() +
                              '+'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Column(
                children: <Widget>[
                  Text(
                    "Strength Class",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.grey[700],
                        fontFamily: "OpenSans-Bold"),
                  ),
                  Text(
                    verbalRating,
                    style: TextStyle(
                        fontSize: 25,
                        color: verbalColor,
                        fontFamily: "OpenSans-Bold"),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 30.0, right: 30.0, top: 5, bottom: 5),
              child: Container(
                height: 2,
                color: Colors.grey[500],
              ),
            ),
          ],
        )
            : Container(),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Container(
            width: 230,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(
                width: 2,
                color: Colors.grey[300],
              ),
            ),
            child: Center(
              child: DropdownButton(
                hint: Text("Select an Exercise"),
                style: TextStyle(fontSize: 22.5, color: Colors.black),
                value: _exercise,
                items: _exerciseOptions.map((value) {
                  return DropdownMenuItem(
                    child: Text(value),
                    value: value,
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _exercise = value;
                  });
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: 140,
                child: RaisedButton(
                  color: isMale ? Colors.blue : Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(6.0),
                    side: BorderSide(
                      color: isMale ? Colors.white : Colors.grey,
                    ),
                  ),
                  child: Text(
                    'Male',
                    style: TextStyle(
                      fontSize: 17.5,
                      color: isMale ? Colors.white : Colors.black54,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      isMale = true;
                    });
                  },
                ),
              ),
              Container(
                width: 140,
                child: RaisedButton(
                  color: isMale ? Colors.white : Colors.blue,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(6.0),
                    side:
                    BorderSide(color: isMale ? Colors.grey : Colors.white),
                  ),
                  child: Text(
                    'Female',
                    style: TextStyle(
                      fontSize: 17.5,
                      color: isMale ? Colors.black54 : Colors.white,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      isMale = false;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.5, bottom: 8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 8.0),
                  child: TextField(
                      controller: weightController,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme
                            .of(context)
                            .primaryColorDark,
                        fontSize: 20,
                      ),
//                  controller: _repController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: showLBS
                              ? "Body Weight (lbs.)"
                              : "Body Weight (kgs.)",
                          hintStyle: TextStyle(
                              color: Theme
                                  .of(context)
                                  .primaryColor,
                              fontSize: 20),
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
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 12.0),
                  child: TextField(
                    controller: liftController,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme
                          .of(context)
                          .primaryColorDark,
                      fontSize: 20,
                    ),
//                  controller: _repController,
                    keyboardType: TextInputType.number,
                    onChanged: (text) {},
                    decoration: InputDecoration(
                        hintText:
                        showLBS ? "1 Rep Max (lbs.)" : "1 Rep Max (kgs.)",
                        hintStyle: TextStyle(
                            color: Theme
                                .of(context)
                                .primaryColor,
                            fontSize: 20),
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
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 120,
          child: RaisedButton(
            color: Colors.white,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0),
//                side: BorderSide(color: Colors.red)
            ),
            child: Text(
              'Calculate',
              style: TextStyle(
                  fontSize: 17.5,
                  color: Colors.lightBlueAccent,
                  fontFamily: 'OpenSans'),
            ),
            onPressed: () {
              switch (_exercise) {
                case "Bench Press":
                  if (isMale) {
                    imageSource =
                    "images/Statistics/StrengthStandards/Male-Bench-Press-Standards.jpg";

                    // BW, [Ranges]
                    ratingRanges = [
                      [114, 84, 107, 130, 179, 222],
                      [123, 91, 116, 142, 194, 242],
                      [132, 98, 125, 153, 208, 260],
                      [148, 109, 140, 172, 324, 291],
                      [165, 119, 152, 187, 255, 319],
                      [181, 128, 164, 201, 275, 343],
                      [198, 135, 173, 213, 289, 362],
                      [220, 142, 183, 225, 306, 381],
                      [242, 149, 190, 232, 316, 395],
                      [275, 153, 196, 239, 325, 407],
                      [319, 156, 199, 244, 333, 416],
                      [320, 159, 204, 248, 340, 425],
                    ];
                  } else {
                    imageSource =
                    "images/Statistics/StrengthStandards/Female-Bench-Press-Standards.jpg";

                    // BW, [Ranges]
                    ratingRanges = [
                      [97, 49, 63, 73, 94, 116],
                      [105, 53, 68, 79, 102, 124],
                      [114, 57, 73, 85, 109, 133],
                      [123, 60, 77, 90, 116, 142],
                      [132, 64, 82, 95, 122, 150],
                      [148, 70, 90, 105, 135, 165],
                      [165, 76, 97, 113, 146, 183],
                      [181, 81, 104, 122, 158, 192],
                      [198, 88, 112, 130, 167, 205],
                      [200, 92, 118, 137, 177, 217],
                    ];
                  }
                  break;
                case "Squat":
                  if (isMale) {
                    imageSource =
                    "images/Statistics/StrengthStandards/Male-Squat-Standards.jpg";

                    // BW, [Ranges]
                    // BW, [Ranges]
                    ratingRanges = [
                      [114, 78, 144, 174, 240, 320],
                      [123, 84, 155, 190, 259, 346],
                      [132, 91, 168, 205, 278, 369],
                      [148, 101, 188, 230, 313, 410],
                      [165, 110, 204, 250, 342, 445],
                      [181, 119, 220, 269, 367, 479],
                      [198, 125, 232, 285, 387, 504],
                      [220, 132, 244, 301, 409, 532],
                      [242, 137, 255, 311, 423, 551],
                      [275, 141, 261, 319, 435, 567],
                      [319, 144, 267, 326, 445, 580],
                      [320, 147, 272, 332, 454, 593],
                    ];
                  } else {
                    imageSource =
                    "images/Statistics/StrengthStandards/Female-Squat-Standards.jpg";

                    ratingRanges = [
                      [97, 46, 84, 98, 129, 163],
                      [105, 49, 91, 106, 140, 174],
                      [114, 53, 98, 114, 150, 187],
                      [123, 56, 103, 121, 160, 199],
                      [132, 59, 110, 127, 168, 211],
                      [148, 65, 121, 141, 185, 232],
                      [165, 70, 130, 151, 200, 256],
                      [181, 75, 139, 164, 215, 268],
                      [198, 81, 150, 174, 229, 288],
                      [200, 85, 158, 184, 242, 303],
                    ];
                  }
                  break;
                case "Deadlift":
                  if (isMale) {
                    imageSource =
                    "images/Statistics/StrengthStandards/Male-Deadlift-Standards.jpg";

                    ratingRanges = [
                      [114, 97, 179, 204, 299, 387],
                      [123, 105, 194, 222, 320, 414],
                      [132, 113, 209, 239, 342, 438],
                      [148, 126, 234, 269, 380, 482],
                      [165, 137, 254, 293, 411, 518],
                      [181, 148, 274, 315, 438, 548],
                      [198, 156, 289, 333, 457, 567],
                      [220, 164, 305, 351, 479, 586],
                      [242, 172, 318, 363, 490, 596],
                      [275, 176, 326, 373, 499, 602],
                      [319, 180, 333, 381, 506, 608],
                      [320, 183, 340, 388, 512, 617],
                    ];
                  } else {
                    imageSource =
                    "images/Statistics/StrengthStandards/Female-Deadlift-Standards.jpg";

                    ratingRanges = [
                      [97, 57, 105, 122, 175, 232],
                      [105, 61, 114, 132, 189, 242],
                      [114, 66, 122, 142, 200, 253],
                      [123, 70, 129, 151, 211, 263],
                      [132, 74, 137, 159, 220, 273],
                      [148, 81, 151, 176, 241, 295],
                      [165, 88, 162, 189, 258, 319],
                      [181, 94, 174, 204, 273, 329],
                      [198, 101, 187, 217, 284, 349],
                      [200, 107, 197, 229, 297, 364],
                    ];
                  }
                  break;
                case "Military Press":
                  if (isMale) {
                    imageSource =
                    "images/Statistics/StrengthStandards/Male-Military-Press-Standards.jpg";

                    ratingRanges = [
                      [114, 53, 72, 90, 107, 129],
                      [123, 57, 78, 98, 116, 141],
                      [132, 61, 84, 105, 125, 151],
                      [148, 69, 94, 119, 140, 169],
                      [165, 75, 102, 129, 153, 186],
                      [181, 81, 110, 138, 164, 218],
                      [198, 85, 116, 146, 173, 234],
                      [220, 89, 122, 155, 183, 255],
                      [242, 93, 127, 159, 189, 264],
                      [275, 96, 131, 164, 194, 272],
                      [319, 98, 133, 167, 199, 278],
                      [320, 100, 136, 171, 203, 284],
                    ];
                  } else {
                    imageSource =
                    "images/Statistics/StrengthStandards/Female-Military-Press-Standards.jpg";

                    ratingRanges = [
                      [97, 31, 42, 50, 66, 85],
                      [105, 33, 46, 53, 71, 91],
                      [114, 36, 49, 58, 76, 97],
                      [123, 38, 52, 61, 81, 104],
                      [132, 40, 55, 65, 85, 110],
                      [148, 44, 60, 72, 94, 121],
                      [165, 48, 65, 77, 102, 134],
                      [181, 51, 70, 83, 110, 140],
                      [198, 55, 75, 88, 117, 151],
                      [200, 58, 79, 93, 123, 159],
                    ];
                  }
                  break;
              }

              // Figure out what's the closest weight range for the user
              try {
                int.parse(weightController.text);
                int.parse(liftController.text);
                ratingRanges.length;
              } on FormatException catch (e) {
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
              } catch (NoSuchMethodError) {
                final snackBar = SnackBar(
                  content: Text(
                    'Please Select an Exercise!',
//                            textAlign: TextAlign.center,
                  ),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 2),
                );
                Scaffold.of(this.context).showSnackBar(snackBar);
                return;
              }

              bodyWeight = int.parse(weightController.text);
              int distanceFromRange = 999;
              int weightRange;

              for (int i = 0; i < ratingRanges.length - 1; i++) {
                int distanceFromFirst = (ratingRanges[i][0] - bodyWeight).abs();
                int distanceFromSecond =
                (ratingRanges[i + 1][0] - bodyWeight).abs();

                if (distanceFromFirst < distanceFromSecond &&
                    distanceFromFirst < distanceFromRange) {
                  distanceFromRange = distanceFromFirst;
                  weightRange = ratingRanges[i][0];
                  weightRangeIndex = i;
                } else if (distanceFromSecond < distanceFromFirst &&
                    distanceFromSecond < distanceFromRange) {
                  distanceFromRange = distanceFromSecond;
                  weightRange = ratingRanges[i + 1][0];
                  weightRangeIndex = i + 1;
                } else {
                  if (distanceFromFirst < distanceFromRange) {
                    distanceFromRange = distanceFromFirst;
                    weightRange = ratingRanges[i + 1][0];
                    weightRangeIndex = i + 1;
                  }
                }
              }
//                print(weightRange);
//                print(distanceFromRange);

              oneRepMax = int.parse(liftController.text);
              distanceFromRange = 999;
              int ratingClass;
              int indexRatingClass;
              for (int i = 0; i < ratingRanges.length; i++) {
                if (ratingRanges[i][0] == weightRange) {
                  for (int k = 1; k < ratingRanges[i].length - 1; k++) {
                    int distanceFromFirst =
                    (ratingRanges[i][k] - oneRepMax).abs();
                    int distanceFromSecond =
                    (ratingRanges[i][k + 1] - oneRepMax).abs();

                    if (distanceFromFirst < distanceFromSecond &&
                        distanceFromFirst < distanceFromRange) {
                      distanceFromRange = distanceFromFirst;
                      ratingClass = ratingRanges[i][k];
                      indexRatingClass = k;
                    } else if (distanceFromSecond < distanceFromFirst &&
                        distanceFromSecond < distanceFromRange) {
                      distanceFromRange = distanceFromSecond;
                      ratingClass = ratingRanges[i][k + 1];
                      indexRatingClass = k + 1;
                    } else {
                      if (distanceFromFirst < distanceFromRange) {
                        distanceFromRange = distanceFromFirst;
                        ratingClass = ratingRanges[i][k];
                        indexRatingClass = k;
                      }
                    }
                  }
                }
              }

//                print(indexRatingClass);
              switch (indexRatingClass) {
                case 1:
                  verbalRating = "Beginner";
                  verbalColor = Colors.black;
                  break;
                case 2:
                  verbalRating = "Novice";
                  verbalColor = Colors.green;
                  break;
                case 3:
                  verbalRating = "Intermediate";
                  verbalColor = Colors.blue;
                  break;
                case 4:
                  verbalRating = "Advanced";
                  verbalColor = Colors.purple;
                  break;
                case 5:
                  verbalRating = "Elite";
                  verbalColor = Colors.orange;
                  break;
              }
              setState(() {
                showChart = true;
              });
            },
          ),
        ),
//        Text(data.toString()),
      ],
    );
  }
}

class Statistic extends StatelessWidget {
  final String label;
  final String data;

//  final List<dynamic> data;

  const Statistic({Key key, this.label, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Image statIcon;

    switch (label) {
      case 'Heaviest Lift':
        statIcon = Image.asset('images/Statistics/hand.png');
        break;
      case 'Most Sets':
        statIcon = Image.asset('images/Statistics/heart.png');
        break;
      case 'Distance Ran':
        statIcon = Image.asset('images/Exercises/cardio.png');
        break;
      case 'Days/Week':
        statIcon = Image.asset('images/Statistics/routine.png');
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 10),
      child: Stack(
        children: <Widget>[
          Container(
            // Card
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 5.0, // has the effect of softening the shadow
                  spreadRadius: 2, // has the effect of extending the shadow
                  offset: Offset(
                    2.0, // horizontal, move right 10
                    4.0, // vertical, move down 10
                  ),
                )
              ],
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0, left: 7.5, right: 15.0),
            child: Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 50,
//              height: 50,
//            decoration: BoxDecoration(
//              color: Colors.lightBlueAccent,
//              shape: BoxShape.circle
//            ),
                        child: statIcon,
                      ),
                      Container(
                        width: 5,
                      ),
                      Text(
                        label,
                        style:
                        TextStyle(fontSize: 20, fontFamily: 'OpenSans-Bold'),
                      ),
                    ],
                  ),
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      data,
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'OpenSans',
                          color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ),
//          Positioned(
//            top: 5,
//            left: 7.5,
//            child: Container(
//              width: 50,
////              height: 50,
////            decoration: BoxDecoration(
////              color: Colors.lightBlueAccent,
////              shape: BoxShape.circle
////            ),
//              child: statIcon,
//            ),
//          ),
//          Positioned(
//            top: 17,
//            left: 65,
//            child: FittedBox(
//              fit: BoxFit.fitWidth,
//              child: Text(
//                label,
//                style: TextStyle(fontSize: 20, fontFamily: 'OpenSans-Bold'),
//              ),
//            ),
//          ),
//          Positioned(
//            top: 12,
//            right: 25,
//            child: Text(
//              data,
//              style: TextStyle(
//                  fontSize: 22.5, fontFamily: 'OpenSans', color: Colors.blue),
//            ),
//          )
        ],
      ),
    );
  }
}

class ExercisesBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  ExercisesBarChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new charts.BarChart(
      seriesList,
      animate: animate,
      vertical: true,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      // Hide domain axis.
      primaryMeasureAxis:
      new charts.NumericAxisSpec(renderSpec: new charts.NoneRenderSpec()),
//      domainAxis:
//      new charts.OrdinalAxisSpec(renderSpec: new charts.NoneRenderSpec()),
    );
  }
}

class WeekDay {
  final String name;
  bool lastWeek;
  int _exerciseCount;

  WeekDay(this.name);

  void setExerciseCount(int count) {
    this._exerciseCount = count;
  }

  bool isLastWeek() {
    return this.lastWeek;
  }
}
