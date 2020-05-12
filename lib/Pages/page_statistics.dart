import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fit_k/Logic/data_storage.dart';
import 'package:flutter/material.dart';

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
            'Statistics',
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
    String mostDoneLabel = 'Most Done';
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
                  '# of Exercises',
                  style: TextStyle(fontSize: 25, fontFamily: 'OpenSans'),
                ),
                Container(
                  height: 120,
                  child: SelectionBarHighlight.withSampleData(),
                ),
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

  Widget _buildBodyStats() {
    return Column(
      children: <Widget>[
        Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                'Body Mass Index (BMI)',
                style: TextStyle(fontSize: 25, fontFamily: 'OpenSans-Bold'),
              ),
            )),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: double.infinity,
            height: 260,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
//                  color: widget._theme[0].withOpacity(0.9),
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 5.0, // has the effect of softening the shadow
                  spreadRadius: 3, // has the effect of extending the shadow
                  offset: Offset(
                    2.0, // horizontal, move right 10
                    4.0, // vertical, move down 10
                  ),
                )
              ],
//          borderRadius: BorderRadius.all(Radius.circular(10)),
//          border: Border.all(
//            width: 2,
//            color: Colors.black54
//          ),
            ),
            child: FittedBox(
                fit: BoxFit.fill,
                child: Image.asset('images/Statistics/BMIChart.jpg')),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 8.0),
                  child: TextField(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 20,
                      ),
//                  controller: _repController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: "Weight (lbs.)",
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
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 12.0),
                  child: TextField(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 20,
                      ),
//                  controller: _repController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: "Height (in)",
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
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            width: 160,
            child: RaisedButton(
              color: Colors.white,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
//                side: BorderSide(color: Colors.red)
              ),
              child: Text(
                'Calculate BMI',
                style: TextStyle(
                    fontSize: 17.5,
                    color: Colors.lightBlueAccent,
                    fontFamily: 'OpenSans'),
              ),
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStrengthStats() {
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
                  'Avg. Weight',
                  style: TextStyle(fontSize: 25, fontFamily: 'OpenSans'),
                ),
                Container(
                  height: 120,
                  child: PointsLineChart.withSampleData(),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            data.toString(),
            style: TextStyle(fontSize: 20, fontFamily: 'OpenSans'),
          ),
        ),
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
      case 'Most Done':
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
          Positioned(
            top: 5,
            left: 7.5,
            child: Container(
              width: 50,
              height: 50,
//            decoration: BoxDecoration(
//              color: Colors.lightBlueAccent,
//              shape: BoxShape.circle
//            ),
              child: statIcon,
            ),
          ),
          Positioned(
            top: 17,
            left: 65,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                label,
                style: TextStyle(fontSize: 20, fontFamily: 'OpenSans-Bold'),
              ),
            ),
          ),
          Positioned(
            top: 12,
            right: 25,
            child: Text(
              data,
              style: TextStyle(
                  fontSize: 22.5, fontFamily: 'OpenSans', color: Colors.blue),
            ),
          )
        ],
      ),
    );
  }
}

class SelectionBarHighlight extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SelectionBarHighlight(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory SelectionBarHighlight.withSampleData() {
    return new SelectionBarHighlight(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // This is just a simple bar chart with optional property
    // [defaultInteractions] set to true to include the default
    // interactions/behaviors when building the chart.
    // This includes bar highlighting.
    //
    // Note: defaultInteractions defaults to true.
    //
    // [defaultInteractions] can be set to false to avoid the default
    // interactions.
    return new charts.BarChart(
      seriesList,
      animate: animate,
      defaultInteractions: true,
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final data = [
      new OrdinalSales('2014', 5),
      new OrdinalSales('2015', 25),
      new OrdinalSales('2016', 100),
      new OrdinalSales('2017', 75),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

class PointsLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  PointsLineChart(this.seriesList, {this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory PointsLineChart.withSampleData() {
    return new PointsLineChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(seriesList,
        animate: animate,
        defaultRenderer: new charts.LineRendererConfig(includePoints: true));
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales, int>> _createSampleData() {
    final data = [
      new LinearSales(0, 5),
      new LinearSales(1, 25),
      new LinearSales(2, 100),
      new LinearSales(3, 75),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}

class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
