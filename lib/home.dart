import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bottom_bar/bottom_bar.dart';
import 'package:spray/calendar.dart';
import 'package:spray/login.dart';
import 'package:spray/map.dart';
import 'package:spray/timer.dart';

import 'board.dart';
import 'groupview.dart';
import 'model/group.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 2;
  var prayTitle = [
    "북한을 위해 중보합니다." ,
    "캠퍼스를 위해 기도합시다!",
    "한동이 하나님의 대학이 되기를!" ,
    "제 병을 고쳐주세요",
    "제 친구와의 관계가 회복되기를!",
    "하나님의 나라와 뜻이 이 땅 가운데!",
    "하나님을 찬양합니다."
  ];

  final _children = [
    TimerPage(),
    GroupPage(),
    HomePage(),
    CalendarPage(), // Calender Page
    MapPage(),
  ];

  _onTap() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) => _children[_currentPage])); // this has changed
  }

  final _pageController = PageController();

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
        title: const Text("Home"), centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: const Icon(
                Icons.add,
                semanticLabel: 'search',
              ),
              onPressed: () => {Navigator.pushNamed(context, '/add')}),
        ],
      ),
      body:
      PageView(
        controller: _pageController,
        children: [
          StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context , snapshot){
                List<dynamic> datas = snapshot.data?.get('liked');
                if(snapshot.data != null){
                  return
                    Column(
                      children: [
                        SizedBox(height: 80,),
                        Text("함께 기도해요!"),
                        SizedBox(height: 8,),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 20, 0, 0),

                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.purple.shade100,
                          ),
                          child: Text("${prayTitle[Random().nextInt(6)]}"),
                        ),
                        SizedBox(height: 80,),
                        Text("내 그룹"),
                        SizedBox(height: 8,),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(45, 20, 0, 0),
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.purple.shade100,
                          ),
                          child: ListView.builder(
                            itemCount: datas.length,
                            itemBuilder: (BuildContext context, int index) {
                              String data = datas[index];
                              if(data == null){
                                return Text("그룹에 가입하세요!");
                              }
                              else
                                return Text('- ${data}');
                            },
                          ),
                        ),

                      ],
                    );
                }
                else if (snapshot.hasError){
                  return const Center(child: CircularProgressIndicator());
                }
                else {
                  return const Center(child: CircularProgressIndicator());
                }
              }
          )
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
