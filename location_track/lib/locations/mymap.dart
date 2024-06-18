import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

class MyMap extends StatefulWidget {
  final String user_id;
  final String? lo;
  MyMap(this.user_id, this.lo);
  @override
  _MyMapState createState() => _MyMapState(lo);
}

class _MyMapState extends State<MyMap> {
  final String? l;
  _MyMapState(this.l);
  final loc.Location location = loc.Location();
  late GoogleMapController _controller;
  bool _added = false;
  @override
  void initState() {
    checkpoint();
    //loadBusIcon();
    loadBusIcon();
    super.initState();
    //_addPolyline();
    // Load the custom marker icon
  }

  List<LatLng> points1 = [
    LatLng(17.658518, 75.936379), //ASHOK CHOWK
    LatLng(17.631852, 75.908861), //KANNA
    LatLng(17.635648, 75.897974),
    LatLng(17.626141, 75.898396),
    LatLng(17.633000, 75.895261),
    LatLng(17.638826, 75.896599),
    LatLng(17.688525, 75.902253),
    //   LatLng(17.720287, 75.918749), //clg
    //KANNA
    //KANNA
  ];

  List<LatLng> points2 = [
    LatLng(17.637074, 75.898063), //'nehru nagar \n   - 9.05 AM',

    LatLng(17.643654, 75.899018), //'I.T.I \n   - 9.10 AM',

    LatLng(17.639406, 75.924106), // 'rasul hotel \n   - 9.15 AM',

    LatLng(17.652938, 75.904757), //  'patrakar bhavan \n   - 9.25 AM',

    LatLng(17.684784, 75.913642), // 'Doodh Dairy \n   - 9.30 AM',

//    LatLng(17.720287, 75.918749), // 'Orchid college \n   - 9.45 AM'
  ];
  List<LatLng> extra = [
    LatLng(17.709772, 75.915336),
    LatLng(17.710262, 75.915442),
    LatLng(17.710580, 75.915518),
    LatLng(17.710958, 75.915597),
    LatLng(17.711251, 75.915657),
    LatLng(17.711590, 75.915776),
    LatLng(17.711923, 75.915895),
    LatLng(17.712189, 75.915988),
    LatLng(17.712462, 75.916076),
    LatLng(17.712637, 75.916155),
    LatLng(17.712889, 75.916281),
    LatLng(17.713157, 75.916391),
    LatLng(17.713477, 75.916580),
    LatLng(17.713755, 75.916714),
    LatLng(17.714118, 75.916893),
    LatLng(17.714483, 75.917095),
    LatLng(17.714768, 75.917277),
    LatLng(17.715176, 75.917494),
    LatLng(17.715541, 75.917741),
    LatLng(17.715690, 75.917834),
    LatLng(17.716167, 75.918171),
    LatLng(17.716367, 75.918310),
    LatLng(17.717216, 75.918949),
    LatLng(17.717626, 75.919250),
    LatLng(17.720287, 75.918749)
  ];

  BitmapDescriptor? busIcon;
  List<LatLng> points3 = [
    ///golllll
    ///
    LatLng(17.635635, 75.913392), //'D-mart ( jule solapur) \n   - 9.00 AM',
    LatLng(17.636641, 75.910863), //'Govindshree \n   - 9.05 AM',//c
    LatLng(17.639995, 75.901624), //'bharati vidyapeeth \n   - 9.10 AM',//c
    LatLng(17.649146, 75.902125), //'kambar talav \n   - 9.20 AM',
    // LatLng(17.720287, 75.918749), //'Orchid college \n   - 9.45 AM'  //c
  ];
  List<LatLng> points = [];

  List<LatLng> points4 = [
    LatLng(17.658249, 75.906752), //'Saat Rasta \n   - 9.10 AM',
    LatLng(17.657443, 75.902867), //'Modi \n   - 9.15 AM',
    LatLng(17.659049, 75.898191), //'DRM office \n   - 9.15 AM',
    LatLng(17.664384, 75.894141), //'railway station \n   - 9.30 AM',
    LatLng(17.685289, 75.900769), //'samrat chowk  \n   - 9.35 AM',   //c
    LatLng(
        17.671312, 75.908772), //'Mantri Chandak(Rupa bhavani) \n   - 9.40 AM',
    //  LatLng(17.720287, 75.918749), //'Orchid college \n   - 9.45 AM'
  ];

  void checkpoint() {
    setState(() {
      switch (l) {
        case "1":
          points = points1;
          break;
        case "2":
          points = points2;
          break;
        case "3":
          points = points3;
          break;
        case "4":
          points = points4;
          break;
        default:
          points = [];
      }
    });
  }

  Future<void> loadBusIcon() async {
    busIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(48, 48)),
      'images/location1.png',
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseFirestore.instance.collection('location$l').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (_added) {
          mymap(snapshot);
        }
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } // Create a set of markers from points1
        Set<Marker> markers = points
            .map((point) => Marker(
                  position: point,
                  markerId: MarkerId(point.toString()),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueGreen),
                ))
            .toSet();

        // Add the user's location marker
        markers.add(Marker(
          position: LatLng(
            snapshot.data!.docs.singleWhere(
                (element) => element.id == widget.user_id)['latitude'],
            snapshot.data!.docs.singleWhere(
                (element) => element.id == widget.user_id)['longitude'],
          ),
          markerId: MarkerId('user_location'),
          icon: busIcon ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        )); // Add the destination marker
        markers.add(Marker(
          markerId: MarkerId('destination'),
          position: LatLng(17.720287, 75.918749),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
            title: 'Destination',
          ),
        ));

        List<LatLng> polylinePoints = List.from(points)..addAll(extra);

        // Create the polyline
        Set<Polyline> polylines = {
          Polyline(
            polylineId: PolylineId('route'),
            points: polylinePoints,
            color: Colors.blue,
            width: 5,
          )
        };
        return GoogleMap(
          mapType: MapType.normal,
          markers: markers,
          polylines: polylines,
          initialCameraPosition: CameraPosition(
              target: LatLng(
                snapshot.data!.docs.singleWhere(
                    (element) => element.id == widget.user_id)['latitude'],
                snapshot.data!.docs.singleWhere(
                    (element) => element.id == widget.user_id)['longitude'],
              ),
              zoom: 17.47),
          onMapCreated: (GoogleMapController controller) async {
            setState(() {
              _controller = controller;
              _added = true;
            });
          },
        );
      },
    ));
  }

  Future<void> mymap(AsyncSnapshot<QuerySnapshot> snapshot) async {
    await _controller
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(
              snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.user_id)['latitude'],
              snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.user_id)['longitude'],
            ),
            zoom: 17.47)));
  }
}
