import 'package:bottom_bar/bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spray/timer.dart';
import 'board.dart';
import 'calendar.dart';
import 'groupview.dart';
import 'home.dart';
import 'login.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  int _currentPage = 4;

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

  List<Marker> _markers =[];

  Future<void> requestPermission() async { await Permission.location.request(); }


  @override
  void initState() {
    super.initState();
    requestPermission();
    //서울
    _markers.add(
      Marker(
          markerId: MarkerId("1"),
          draggable: true,
          onTap: () => print("Marker!"),
          position: LatLng(37.5481 , 126.9785)
      ),
    );

    //충청
    _markers.add(
      Marker(
          markerId: MarkerId("2"),
          draggable: true,
          onTap: () => print("Marker!"),
          position: LatLng(36.5571, 126.9605)
      ),
    );

    //강원도
    _markers.add(
      Marker(
          markerId: MarkerId("3"),
          draggable: true,
          onTap: () => print("Marker!"),
          position: LatLng(37.818 , 128.1614)
      ),
    );

    //제주도
    _markers.add(
      Marker(
          markerId: MarkerId("4"),
          draggable: true,
          onTap: () => print("Marker!"),
          position: LatLng(33.3778 , 126.568)
      ),
    );

    //전라도
    _markers.add(
      Marker(
          markerId: MarkerId("5"),
          draggable: true,
          onTap: () => print("Marker!"),
          position: LatLng(35.5279 , 127.0496)
      ),
    );

    //경상도
    _markers.add(
      Marker(
          markerId: MarkerId("6"),
          draggable: true,
          onTap: () => print("Marker!"),
          position: LatLng(35.8142 , 128.9886)
      ),
    );

  }



  late GoogleMapController mapController;

  //Center 정하는 코드
  final LatLng _center = const LatLng(36.0043, 127.444);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
          title: const Text("Map"), centerTitle: true,


        ),
        body:
        PageView(
          controller: _pageController,
          children: [

            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 7.0,
              ),
              markers: Set.from(_markers),
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

      ),
    );
  }
}

