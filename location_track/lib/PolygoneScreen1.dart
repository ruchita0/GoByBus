import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class PolygoneScreen extends StatefulWidget {
  const PolygoneScreen({Key? key}) : super(key: key);

  @override
  _PolygoneScreenState createState() => _PolygoneScreenState();
}

/*
I.M.S chowk 

kumatekar hospital 9.5   asara chowk
nadagiri petrol pump 9.10 sanchar pres
saiful 9.15   juna hotgi nska9:20
attar nagar 9.20 gental chowk9:25
jigahini petrol pump  ashok chowk 9.30
mantri chandak 9.25 
orchid clg 9.45
 */

class _PolygoneScreenState extends State<PolygoneScreen> {
  Completer<GoogleMapController> _controller = Completer();

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(17.6622198, 75.9221364),
    zoom: 14,
  );
  final Set<Marker> _markers = {};
  Set<Polygon> _polygone = HashSet<Polygon>();
  LocationData? currentLocation;

  void getCurrentLocation() {
    Location location = Location();
    print("yes");
    location.getLocation().then(
      (location) {
        currentLocation = location;
      },
    );
  }

  List<LatLng> points = [
    LatLng(17.6622198, 75.9221364), //ASHOK CHOWK
    LatLng(17.676429, 75.917541), //KANNA
    LatLng(17.719552, 75.919007)
  ];

  void _setPolygone() {
    _polygone.add(Polygon(
        polygonId: PolygonId('1'),
        points: points,
        strokeColor: Colors.deepOrange,
        strokeWidth: 5,
        fillColor: Colors.deepOrange.withOpacity(0.1),
        geodesic: true));
  }

  @override
  void initState() {
    getCurrentLocation();
    // TODO: implement initState
    super.initState();
    /* _markers.add(Marker(
      markerId: MarkerId("currentlocation"),
      position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
    ));*/
    for (int i = 0; i < points.length; i++) {
      _markers.add(Marker(
        markerId: MarkerId(i.toString()),
        position: points[i],
      ));
    }
    _setPolygone();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Polygone'),
      ),
      body: /* currentLocation == null
          ? Text("Loading")
          :*/
          GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        myLocationButtonEnabled: true,
        myLocationEnabled: false,
        // cameraTargetBounds: CameraTargetBounds(LatLngBounds(
        //   northeast: LatLng(9.006808, -79.508148),
        //   southwest:  LatLng(9.003121, -79.505702),
        // )),
        //  onCameraMove: ((_position) => _updatePosition(_position)),
        markers: _markers,
        polygons: _polygone,

        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
