import 'package:fit_k/Logic/data_storage.dart';
import 'package:fit_k/Logic/exercise.dart';
import 'package:fit_k/UI/card_calendar_exercise.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  List<dynamic> dataSet;

  CalendarPage({Key key, this.dataSet}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with TickerProviderStateMixin {
  Storage _storage;
  Map<DateTime, List> _events;
  AnimationController _animationController;
  CalendarController _calendarController;
  DateTime _selectedDay;
  bool _showSets;

  @override
  void initState() {
    _storage = Storage();
    _showSets = false;
    // @TODO exercise count
    _events = {};

    _selectedDay = Storage.todaysDate;

    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
    _getExerciseList();

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  Future _getExerciseList() async {
    List<dynamic> data = await _storage.readData();

    setState(() {
      widget.dataSet = data;
    });

    setState(() {
      for (int i = 0; i < data.length; i++) {
        _events.putIfAbsent(
            DateTime.parse(data[i]['date']), () => data[i]['exercises']);
      }
    });

    for (int i = 0; i < data.length; i++) {
      if (DateTime.parse(data[i]['date']) == _selectedDay)
        return data[i]['exercises'];
    }

    return List();
  }

  void _onDaySelected(DateTime day, List events) {
    setState(() {
      _selectedDay = DateTime(day.year, day.month, day.day);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        _buildTableCalendarWithBuilders(),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: FlatButton(
            color: Colors.lightBlueAccent.withOpacity(0.2),
            highlightColor: Colors.blue.withOpacity(0.2),
            child: Text(
              'Show Details',
              style: TextStyle(
                  color: Colors.blue, fontSize: 25, fontFamily: 'OpenSans'),
            ),
            onPressed: () {
              setState(() {
                _showSets = !_showSets;
              });
            },
          ),
        ),
        _buildExerciseList(),
//        _buildExerciseList2(),
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
        formatAnimation: FormatAnimation.slide,
        startingDayOfWeek: StartingDayOfWeek.sunday,
        availableGestures: AvailableGestures.all,
        availableCalendarFormats: const {
          CalendarFormat.month: '',
//          CalendarFormat.week: '',
        },
        calendarStyle: CalendarStyle(
          outsideDaysVisible: true,
          outsideStyle:
              TextStyle().copyWith(color: Colors.black26, fontSize: 16),
          outsideWeekendStyle:
              TextStyle().copyWith(color: Colors.black26, fontSize: 16),
          weekdayStyle:
              TextStyle().copyWith(color: Colors.black87, fontSize: 16),
          weekendStyle: TextStyle().copyWith(
              color: Theme.of(context).primaryColorDark, fontSize: 16),
          holidayStyle:
              TextStyle().copyWith(color: Theme.of(context).primaryColor),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle().copyWith(color: Colors.black, fontSize: 17),
          weekendStyle: TextStyle().copyWith(
              color: Theme.of(context).primaryColorDark, fontSize: 17),
        ),
        headerStyle: HeaderStyle(
          titleTextStyle:
          TextStyle().copyWith(color: Colors.black, fontSize: 23),
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
                color: Theme
                    .of(context)
                    .primaryColorLight
                    .withOpacity(0.6),
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
              color: Colors.blue[300],
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
            ? Theme
            .of(context)
            .primaryColorDark
            : _calendarController.isToday(date)
            ? Theme
            .of(context)
            .primaryColorLight
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

  Widget _buildExerciseList() {
    int dateIndex;

    List<dynamic> data;
    if (widget.dataSet == null) {
      data = [];
    } else
      data = widget.dataSet;

    for (int i = 0; i < data.length; i++)
      if (DateTime.parse(data[i]['date']) == _selectedDay) dateIndex = i;

    List<dynamic> exerciseList;
    if (dateIndex == null)
      exerciseList = [];
    else
      exerciseList = data[dateIndex]['exercises'];

    return Column(
      children: <Widget>[
        ...exerciseList.map((entry) {
          return CalendarCard(
            exercise: Exercise.fromJson(entry),
            showSets: _showSets,
          );
        }).toList(),
      ],
    );
  }
}
