import 'package:fit_k/Logic/controller_data.dart';
import 'package:flutter/material.dart';

import 'package:fit_k/Enums/cardTheme.dart';
import 'package:fit_k/Enums/workout.dart';
import 'package:fit_k/Logic/exercise.dart';
import 'package:fit_k/Pages/page_calendar.dart';
import 'package:fit_k/Pages/page_home.dart';
import 'package:fit_k/Pages/page_profile.dart';
import 'package:fit_k/Pages/page_statistics.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitK',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'FitK',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Key homeKey = PageStorageKey('HomePage');
  final Key calendarKey = PageStorageKey('CalendarPage');
  final Key statisticsKey = PageStorageKey('StatisticsPage');
  final Key profileKey = PageStorageKey('ProfilePage');

  HomePage homePage;
  CalendarPage calendarPage;
  StatisticsPage statisticsPage;
  ProfilePage profilePage;

  List<Widget> pages; // List of all pages
  Widget currentPage; // Current Selected Page

  Map<DateTime, List<Exercise>> dataList;
  DataController dataController;

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {
    DateTime now = new DateTime.now();
    DateTime todaysDate = new DateTime(now.year, now.month, now.day);


    dataList = {
      todaysDate: [
        Exercise(
          id: 0,
          workout: Workout.Bench,
          theme: ColorTheme.Blue,
        ),
        Exercise(
          id: 1,
          workout: Workout.Squat,
          theme: ColorTheme.Yellow,
        ),
        Exercise(
          id: 2,
          workout: Workout.OverHeadPress,
          theme: ColorTheme.Purple,
        ),
        Exercise(
          id: 3,
          workout: Workout.BentOverRow,
          theme: ColorTheme.Peach,
        ),
        Exercise(
          id: 4,
          workout: Workout.Deadlift,
          theme: ColorTheme.Green,
        ),
      ],
    };


    homePage = HomePage(
      key: homeKey,
      dataSet: dataList,
    );
    calendarPage = CalendarPage(
      key: calendarKey,
      dataSet: dataList,
    );
    statisticsPage = StatisticsPage(
      key: statisticsKey,
      dataSet: dataList,
    );
    profilePage = ProfilePage(
      key: profileKey,
      dataSet: dataList,
    );

    pages = [homePage, calendarPage, statisticsPage, profilePage];

    currentPage = homePage;
    super.initState();
  }

  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: currentPage,
        bucket: bucket,
      ),
      bottomNavigationBar:
          _buildBottomNavigationBar(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentTab,
      onTap: (int index) {
        setState(() {
          _currentTab = index;
          currentPage = pages[index];
        });
      },
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text("Home"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          title: Text("Calendar"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.multiline_chart),
          title: Text("Statistics"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.verified_user),
          title: Text("Profile"),
        ),
      ],
    );
  }
}
