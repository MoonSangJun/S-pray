import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bottom_bar/bottom_bar.dart';
import 'package:flutter/scheduler.dart';
import 'package:spray/calendar.dart';
import 'package:spray/map.dart';
import 'package:spray/timer.dart';
import 'package:unicons/unicons.dart';
import 'groupview.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _prayTitle = TextEditingController();
  var prayTitle = [
    "북한을 위해 중보합니다." ,
    "캠퍼스를 위해 기도합시다!",
    "한동이 하나님의 대학이 되기를!" ,
    "제 병을 고쳐주세요",
    "제 친구와의 관계가 회복되기를!",
    "하나님의 나라와 뜻이 이 땅 가운데!",
    "하나님을 찬양합니다."
  ];
  int _currentPage = 2;
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

  // @override
  // void initState(){
  //   SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
  //     showBannerDialog();
  //   });
  //   super.initState();
  // }



  showBannerDialog(){

    return
      showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context,setState){
          return
            AlertDialog(
              title: const Text('함께 기도할게요!'),
              content:  TextField(
                decoration: InputDecoration(
                  labelText: '기도제목을 입력 해주세요.',
                ),
                controller: _prayTitle,

              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('pray')
                        .doc('praySet')
                        .update(
                      {
                        'prayTitle': FieldValue.arrayUnion([_prayTitle.text])
                      }
                    );
                    // FirebaseFirestore.instance.collection("pray").doc("pray").set(
                    //   {
                    //     'praytitle' : ;
                    //   }
                    // );
                    _prayTitle.clear();
                    Navigator.pop(context, 'OK');
                  },
                  child: const Text('OK'),
                ),
              ],
            );

        })

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:
        Drawer(
          child:
            ListView(
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
                Navigator.pushNamed(context, '/home');
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
      appBar:
        AppBar(
        backgroundColor: Colors.purple,
        title: const Text("Home"), centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: const Icon(
                Icons.add,
                semanticLabel: 'search',
              ),
              onPressed: () => {Navigator.pushNamed(context, '/add')}),
          IconButton(
              icon: const Icon(
                UniconsLine.megaphone
              ),
              onPressed: () => {showBannerDialog()},
          )
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
                return StreamBuilder(
                  stream: FirebaseFirestore.instance
                  .collection('pray').doc('praySet').snapshots(),
                  builder: (context1, snapshot1){
                    List<dynamic> datas = snapshot.data?.get('liked');
                    List<dynamic> prays = snapshot1.data?.get("prayTitle");
                    if(snapshot.data != null){
                      return
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: 80,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("함께 기도해요!   ",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Icon(
                                    Icons.handshake,
                                    color: Colors.purple,
                                  )
                                ],
                              ),

                              SizedBox(height: 8,),
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                                height: 200,
                                width: 350,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.purple.shade100,
                                ),
                                child: Text("${prays[Random().nextInt(prays.length)]}",
                                textAlign: TextAlign.center,
                                    style: TextStyle(
                                  fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                )),
                              ),
                              SizedBox(height: 80,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("내 그룹   ",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Icon(
                                    Icons.groups_rounded,
                                    color: Colors.purple,
                                  )
                                ],
                              ),

                              SizedBox(height: 8,),
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.fromLTRB(45, 20, 0, 0),
                                height: 200,
                                width: 350,
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
                                      return Text('- ${data}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ));
                                  },
                                ),
                              ),

                            ],
                          ),
                        );
                    }
                    else if (snapshot.hasError){
                      return const Center(child: CircularProgressIndicator());
                    }
                    else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }
                );

              }
          )
        ],
        onPageChanged: (index) {
          setState(() => _currentPage = index);
        },
      ),
      bottomNavigationBar:
        BottomBar(
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

        resizeToAvoidBottomInset: true

    );
  }
}
