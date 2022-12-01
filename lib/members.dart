import 'package:bottom_bar/bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:spray/rounded_button.dart';
import 'package:spray/timer.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'board.dart';
import 'home.dart';
import 'login.dart';
import 'map.dart';

class MemberPage extends StatefulWidget {
  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => MemberPage(),
      ),
    );
  }

  @override
  _State createState() => _State();
}

class _State extends State<MemberPage> {

  CollectionReference user = FirebaseFirestore.instance.collection('user');

  int _currentPage = 0;

  final _children = [
    TimerPage(),
    BoardPage(),//Group Page
    HomePage(),
    LoginPage(), // Calender Page
    MapPage(),
  ];

  _onTap() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) => _children[_currentPage])); // this has changed
  }

  final _pageController = PageController();

  final _isHours = true;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
    onChange: (value) => print('onChange $value'),
    onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
    onChangeRawMinute: (value) => print('onChangeRawMinute $value'),
    onStopped: () {
      print('onStop');
    },
    onEnded: () {
      print('onEnded');
    },
  );

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _stopWatchTimer.rawTime.listen((value) =>
        print('rawTime $value ${StopWatchTimer.getDisplayTime(value)}'));
    _stopWatchTimer.minuteTime.listen((value) => print('minuteTime $value'));
    _stopWatchTimer.secondTime.listen((value) => print('secondTime $value'));
    _stopWatchTimer.records.listen((value) => print('records $value'));
    _stopWatchTimer.fetchStopped
        .listen((value) => print('stopped from stream'));
    _stopWatchTimer.fetchEnded.listen((value) => print('ended from stream'));

    /// Can be set preset time. This case is "00:01.23".
    // _stopWatchTimer.setPresetTime(mSec: 1234);
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              title: const Text('Favorite Group'),
              onTap: () {
                Navigator.pushNamed(context, '/hotel');
              },
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
              leading:  Icon(Icons.person, color: Colors.purple.shade100),
              title: const Text('My Profile'),
              onTap: () {
                Navigator.pushNamed(context, '/my');
              },
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
              leading:  Icon(Icons.logout, color: Colors.purple.shade100),
              title: const Text('Log Out'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text("Timer"), centerTitle: true,


      ),
      body:StreamBuilder(
          stream: user.snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> streamSnapshot){
            return ListView.builder(
                itemBuilder: (context, index){
                  final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
                  return Card(
                    child: Text(documentSnapshot['email'].toString(),),
                  );
                }
            );
          }
      )
    );
  }
}