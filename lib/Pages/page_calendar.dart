import 'package:fit_k/Logic/data_storage.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  CalendarPage({Key key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with TickerProviderStateMixin {
  Storage _storage;
  Map<DateTime, List> _events;
  AnimationController _animationController;
  CalendarController _calendarController;
  DateTime todaysDate;
  DateTime _selectedDay;
  List _selectedEvents;

  @override
  void initState() {
    super.initState();
    _storage = Storage();
    _updateDataSet();

    DateTime now = new DateTime.now();
    todaysDate = new DateTime(now.year, now.month, now.day);

    // @TODO exercise count
    _events = {};

    _selectedDay = todaysDate;
    _selectedEvents = _events[_selectedDay];

    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  Future _updateDataSet() async {
    List<dynamic> data = await _storage.readData();

    setState(() {
      for (int i = 0; i < data.length; i++) {
        _events.putIfAbsent(
            DateTime.parse(data[i]['date']), () => data[i]['exercises']);
      }
    });

//    print(_events);

    for (int i = 0; i < data.length; i++) {
      if (DateTime.parse(data[i]['date']) == _selectedDay)
        return data[i]['exercises'];
    }

    return List();
  }

  void _onDaySelected(DateTime day, List events) {
//    print('CALLBACK: _onDaySelected');
    setState(() {
//      print(events);
      _selectedDay = DateTime(day.year, day.month, day.day);
//      _selectedEvents = events;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        _buildTableCalendarWithBuilders(),
        _buildEventList(),
      ],
    );
  }

  Widget _buildTableCalendarWithBuilders() {
    return Container(
      child: TableCalendar(
//      locale: 'pl_PL',
        calendarController: _calendarController,
        events: _events,
//      holidays: _holidays,
        initialCalendarFormat: CalendarFormat.month,
//        formatAnimation: FormatAnimation.slide,
        startingDayOfWeek: StartingDayOfWeek.sunday,
        availableGestures: AvailableGestures.all,
        availableCalendarFormats: const {
          CalendarFormat.month: '',
//          CalendarFormat.week: '',
        },
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
          holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
        ),
        headerStyle: HeaderStyle(
          centerHeaderTitle: true,
          formatButtonVisible: false,
        ),
        builders: CalendarBuilders(
          selectedDayBuilder: (context, date, _) {
            return FadeTransition(
              opacity:
                  Tween(begin: 0.0, end: 1.0).animate(_animationController),
              child: Container(
                margin: const EdgeInsets.all(4.0),
                padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                color: Colors.lightBlueAccent[100],
                width: 100,
                height: 100,
                child: Text(
                  '${date.day}',
                  style: TextStyle().copyWith(fontSize: 16.0),
                ),
              ),
            );
          },
          todayDayBuilder: (context, date, _) {
            return Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: Colors.lightBlueAccent[400],
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            );
          },
          markersBuilder: (context, date, events, holidays) {
            final children = <Widget>[];

            if (events.isNotEmpty) {
              children.add(
                Positioned(
                  right: 1,
                  bottom: 1,
                  child: _buildEventsMarker(date, events),
                ),
              );
            }

//          if (holidays.isNotEmpty) {
//            children.add(
//              Positioned(
//                right: -2,
//                top: -2,
//                child: _buildHolidaysMarker(),
//              ),
//            );
//          }

            return children;
          },
        ),
        onDaySelected: (date, events) {
          _onDaySelected(date, events);
          _animationController.forward(from: 0.0);
        },
//      onVisibleDaysChanged: _onVisibleDaysChanged,
      ),
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date)
                ? Colors.brown[300]
                : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildEventList() {
    List<Widget> items = new List();

    return FutureBuilder(
      future: _updateDataSet(),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Text('Loading...');
        }
//        print(snapshot.data);
        List<dynamic> parsedJson = snapshot.data;
        items = parsedJson.map((element) {
          return Container(
            width: double.infinity,
            height: 20,
            color: Colors.red,
            child: Text(
              element.toString(),
            ),
          );
        }).toList();

        return ListView.builder(
          primary: false,
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Column(
              children: <Widget>[
                item,
              ],
            );
          },
        );
      },
    );

//    return Column(
//      children: _selectedEvents
//          .map((event) => Container(
//                decoration: BoxDecoration(
//                  border: Border.all(width: 0.8),
//                  borderRadius: BorderRadius.circular(12.0),
//                ),
//                margin:
//                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//                child: ListTile(
//                  title: Text(event.toString()),
//                  onTap: () => print('$event tapped!'),
//                ),
//              ))
//          .toList(),
//    );
  }
}
