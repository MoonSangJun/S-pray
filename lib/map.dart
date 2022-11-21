import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'src/locations.dart' as locations;

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

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
  final LatLng _center = const LatLng(36.710382, 127.817165);

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
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 7.3,
          ),
          markers: Set.from(_markers),
        ),
      ),
    );
  }
}