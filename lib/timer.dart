import 'package:bottom_bar/bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_chart/d_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spray/rounded_button.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'board.dart';
import 'groupview.dart';
import 'home.dart';
import 'login.dart';
import 'map.dart';

class TimerPage extends StatefulWidget {
  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => TimerPage(),
      ),
    );
  }


  @override
  _State createState() => _State();
}

class _State extends State<TimerPage> {


  void updateDoc(String count) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'praynumber' : count});
  }

  int _currentPage = 0;

  final _children = [
    TimerPage(),
    GroupPage(),//Group Page
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
        title: const Text("Timer"), centerTitle: true,

      ),
      body:
      PageView(
        controller: _pageController,
        children: [
          Scrollbar(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 16,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 70),
                    /// Display stop watch time
                    StreamBuilder<int>(
                      stream: _stopWatchTimer.rawTime,
                      initialData: _stopWatchTimer.rawTime.value,
                      builder: (context, snap) {
                        final value = snap.data!;
                        final displayTime =
                        StopWatchTimer.getDisplayTime(value, hours: _isHours);
                        return Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                displayTime,
                                style: const TextStyle(
                                    fontSize: 40,
                                    fontFamily: 'Helvetica',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    StreamBuilder(
                        stream: _stopWatchTimer.rawTime,
                        initialData: _stopWatchTimer.rawTime.value,
                        builder: (context, snap){
                          final value = snap.data!;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: RoundedButton(
                                  color: Colors.purple.shade100,
                                  onTap: _stopWatchTimer.onStartTimer,
                                  child: const Text(
                                    'Start',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: RoundedButton(
                                  color: Colors.green,
                                  onTap: _stopWatchTimer.onStopTimer,
                                  child: const Text(
                                    'Stop',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: RoundedButton(
                                  color: Colors.red,
                                  onTap: _stopWatchTimer.onResetTimer,
                                  child: const Text(
                                    'Reset',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                  onPressed:(){
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(FirebaseAuth.instance.currentUser!.uid)
                                        .update({
                                      'praynumber' : 5,
                                      'total_time': value});
                                  },
                                  child: Text("SAVE"))
                            ],
                          );
                        }
                    ),
                    /// Button

                    const SizedBox(height: 200),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child:
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: DChartBar(
                          data: [
                            {
                              'id': 'Bar',
                              'data': [
                                {'domain': 'MO', 'measure': 2},
                                {'domain': 'TU', 'measure': 1},
                                {'domain': 'WE', 'measure': 1.2},
                                {'domain': 'TH', 'measure': 1.3},
                                {'domain': 'FR', 'measure': 0.8},
                                {'domain': 'SA', 'measure': 0.6},
                                {'domain': 'SU', 'measure': 0.3},
                              ],
                            },
                          ],
                          domainLabelPaddingToAxisLine: 16,
                          axisLineTick: 2,
                          axisLinePointTick: 2,
                          axisLinePointWidth: 10,
                          axisLineColor: Colors.purple,
                          measureLabelPaddingToAxisLine: 16,
                          barColor: (barData, index, id) => Colors.purple,
                          showBarValue: true,
                        ),
                      ),
                    ),
                  ],

                ),
              ),
            ),
          ),


        ],
        onPageChanged: (index) {
          // Use a better state management solution
          // setState is used for simplicity
          setState(() => _currentPage = index);
        },
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
    );
  }
}