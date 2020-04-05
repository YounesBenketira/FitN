import 'package:fit_k/Logic/route_generator.dart';
import 'package:fit_k/Pages/page_calendar.dart';
import 'package:fit_k/Pages/page_home.dart';
import 'package:fit_k/Pages/page_profile.dart';
import 'package:fit_k/Pages/page_statistics.dart';
import 'package:flutter/material.dart';

import 'Logic/data_storage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColorDark: Colors.lightBlueAccent[700],
        primaryColor: Colors.lightBlueAccent,
        primaryColorLight: Colors.lightBlueAccent[100],
      ),
      home: MyHomePage(
        storage: Storage(),
      ),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
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

  @override
  void initState() {
    homePage = HomePage(
      key: homeKey,
      dataSet: dataList,
    ); //

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
      backgroundColor: Colors.white,
//      appBar: AppBar(
//        centerTitle: true,
//        title: Text(
//          'FitN',
//          style: TextStyle(
//            fontSize: 45,
//            color: Colors.black,
//            fontFamily: 'OpenSans',
//          ),
//        ),
//        backgroundColor: Colors.white,
//      ),
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
      backgroundColor: Colors.white,
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
