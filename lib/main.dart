import 'package:flutter/material.dart';

import 'package:fit_k/Pages/page_calendar.dart';
import 'package:fit_k/Pages/page_home.dart';
import 'package:fit_k/Pages/page_profile.dart';
import 'package:fit_k/Pages/page_statistics.dart';

import 'Logic/data_storage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(
        storage: Storage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Storage storage;

  MyHomePage({Key key, @required this.storage}) : super(key: key);

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

  final PageStorageBucket bucket = PageStorageBucket();
  List<dynamic> dataList;
  Storage _storage;

  @override
  void initState() {
    _storage = Storage();

    DateTime now = new DateTime.now();
    DateTime todaysDate = new DateTime(now.year, now.month, now.day);

    homePage = HomePage(
      key: homeKey,
      dataSet: dataList,
      dateIndex: 0,
    );

    calendarPage = CalendarPage(
      key: calendarKey,
      dataSet: dataList,
    );

    statisticsPage = StatisticsPage(
      key: statisticsKey,
    );

    profilePage = ProfilePage(
      key: profileKey,
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
