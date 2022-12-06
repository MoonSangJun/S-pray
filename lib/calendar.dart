import 'package:bottom_bar/bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_calendar/flutter_advanced_calendar.dart';
import 'package:spray/map.dart';
import 'package:spray/timer.dart';
import 'package:spray/board.dart';
import 'package:spray/home.dart';

import 'model/user.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  Future<Users> getUser(String userkey) async {
    DocumentReference<Map<String,dynamic>> documentReference =
    FirebaseFirestore.instance.collection('users').doc(userkey);
    final DocumentSnapshot<Map<String,dynamic>> documentSnapshot =
    await documentReference.get();
    Users user = Users.fromSnapshot(documentSnapshot);
    return user;
  }

  int _currentPage = 3;

  final _children = [
    TimerPage(),
    BoardPage(),
    HomePage(),
    CalendarPage(), // Calender Page
    MapPage(),
  ];

  _onTap() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) => _children[_currentPage])); // this has changed
  }

  final _pageController = PageController();
  final _calendarControllerToday = AdvancedCalendarController.today();
  final _calendarControllerCustom =
  AdvancedCalendarController.custom(DateTime.now());
  //final ddd = DateTime.parse('${DateTime.fromMillisecondsSinceEpoch(Users.time)}');
  final List<DateTime> events = [
    DateTime.now(),
    DateTime(2022, 12, 1),
    DateTime(2022, 12, 2),
    DateTime(2022, 12, 5),
    DateTime(2022, 12, 6),
  ];

    // DateTiem(ddd.year, ddd.month, ddd.day),
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.purple,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(13.0),
                      child: Text(
                        'Spray',
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
                leading:  Icon(Icons.church, color: Colors.purple.shade100),
                title: const Text('Home'),
                onTap: () {
                  Navigator.pushNamed(context, '/');
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
                leading:  Icon(Icons.group_add, color: Colors.purple.shade100),
                title: const Text('Group'),
                onTap: () {
                  Navigator.pushNamed(context, '/group');
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
                leading:  Icon(Icons.person, color: Colors.purple.shade100),
                title: const Text('My Profile'),
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
                leading:  Icon(Icons.logout, color: Colors.purple.shade100),
                title: const Text('Log Out'),
                onTap: () async {
                  Navigator.pushNamed(context, '/login');
                  await FirebaseAuth.instance.signOut();
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: const Text("Calendar"), centerTitle: true,
        ),
        body:
        PageView(
          controller: _pageController,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AdvancedCalendar(
                //   controller: _calendarControllerToday,
                //   // events: events,
                //   startWeekDay: 1,
                // ),
                Theme(
                  data: ThemeData.light().copyWith(
                    textTheme: ThemeData.light().textTheme.copyWith(
                      subtitle1: ThemeData.light().textTheme.subtitle1?.copyWith(
                        fontSize: 16,
                        color: theme.colorScheme.secondary,
                      ),
                      bodyText1: ThemeData.light().textTheme.bodyText1?.copyWith(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                      bodyText2: ThemeData.light().textTheme.bodyText1?.copyWith(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                    primaryColor: Colors.purple,
                    highlightColor: Colors.purple.shade100,
                    disabledColor: Colors.green,
                  ),
                  child: AdvancedCalendar(
                    controller: _calendarControllerCustom,
                    events: events,
                    weekLineHeight: 48.0,
                    startWeekDay: 1,
                    innerDot: true,
                    keepLineSize: true,
                    calendarTextStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      height: 1.3125,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ],
            ),
          ]
        ),

        bottomNavigationBar: BottomBar(
          selectedIndex: _currentPage,
          onTap: (int index) {
            _pageController.jumpToPage(index);
            setState(() => _currentPage = index);
            _onTap();
          },
          items: <BottomBarItem>[
            BottomBarItem(
                icon: Icon(Icons.timer),
                title: Text('Timer'),
                activeColor: Colors.purple
            ),
            BottomBarItem(
                icon: Icon(Icons.group_add),
                title: Text('Group'),
                activeColor: Colors.purple
            ),
            BottomBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
                activeColor: Colors.purple
            ),
            BottomBarItem(
                icon: Icon(Icons.calendar_month),
                title: Text('calendar'),
                activeColor: Colors.purple
            ),
            BottomBarItem(
                icon: Icon(Icons.map),
                title: Text('Map'),
                activeColor: Colors.purple
            ),
          ],
        ),
      ),
    );
  }
}
