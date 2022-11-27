import 'package:bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spray/timer.dart';
import 'home.dart';
import 'login.dart';
import 'src/locations.dart' as locations;

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  int _currentPage = 4;

  final _children = [
    TimerPage(),
    LoginPage(),//Group Page
    HomePage(),
    LoginPage(), // Calender Page
    MapPage(),
  ];

  _onTap() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) => _children[_currentPage])); // this has changed
  }

  final _pageController = PageController();

  List<Marker> _markers =[];

  @override
  void initState() {
    super.initState();
    //서울
    _markers.add(
      Marker(
          markerId: MarkerId("1"),
          draggable: true,
          onTap: () => print("Marker!"),
          position: LatLng(37.5481 , 126.9785)
      ),
    );

    //부산
    _markers.add(
      Marker(
          markerId: MarkerId("2"),
          draggable: true,
          onTap: () => print("Marker!"),
          position: LatLng(35.1771 , 129.045)
      ),
    );
    _markers.add(
      Marker(
          markerId: MarkerId("2"),
          draggable: true,
          onTap: () => print("Marker!"),
          position: LatLng(35.1771 , 129.045)
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
        appBar: AppBar(
          title: const Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
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