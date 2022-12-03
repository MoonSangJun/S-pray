import 'package:flutter/material.dart';
import 'package:bottom_bar/bottom_bar.dart';
import 'package:spray/login.dart';
import 'package:spray/map.dart';
import 'package:spray/timer.dart';

import 'board.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 2;

  final _children = [
    TimerPage(),
    BoardPage(),
    HomePage(),
    LoginPage(), // Calender Page
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
              title: const Text('Favorite Group'),
              onTap: () {
                Navigator.pushNamed(context, '/hotel');
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

          Column(
            children: [
              SizedBox(height: 80,),
              Text("함께 기도해요!"),
              Container(
                height: 200,
                width: 200,
                color: Colors.purple.shade100,
                child: Text("캠퍼스의 부흥이 일어나도록!"),
              ),
              SizedBox(height: 80,),
              Text("내 그룹"),
              Container(
                  height: 200,
                  width: 200,
                  color: Colors.purple.shade100,
                  child: SingleChildScrollView(
                    child: Column(
                      children:  [
                        Text("한동대학교 19학번"),
                        Text("사랑의 교회"),
                        Text("모앱개 팀플"),
                        Text("한동대학교 19학번"),
                        Text("사랑의 교회"),
                        Text("모앱개 팀플"),
                        Text("한동대학교 19학번"),
                        Text("사랑의 교회"),
                        Text("모앱개 팀플"),
                        Text("한동대학교 19학번"),
                        Text("사랑의 교회"),
                        Text("모앱개 팀플"),
                        Text("한동대학교 19학번"),
                        Text("사랑의 교회"),
                        Text("모앱개 팀플"),
                        Text("한동대학교 19학번"),
                        Text("사랑의 교회"),
                        Text("모앱개 팀플"),
                      ],
                    ),
                  )
              ),
            ],
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



