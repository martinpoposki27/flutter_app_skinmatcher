import 'dart:async';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lab193004/model/list_item.dart';
import 'package:lab193004/screens/home/home.dart';
import 'package:lab193004/services/location_service.dart';
import '../../services/database.dart';



class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  List<ListItem> examList = [];

  Set<Marker> _markers = Set<Marker>();
  Set<Polyline> _polylines = Set<Polyline>();
  Set<Polyline> _polylines1 = Set<Polyline>();
  List<LatLng> points1 = [LatLng(42.0041222,21.4073592), LatLng(41.0041222,22.4073592)];

  int _polylineIdCounter = 1;

  void _addMarkersToSet() async {

    final String userId = FirebaseAuth.instance.currentUser!.uid;

    Future<List<ListItem>> currentList () async  {
      return await DatabaseService(userId).exams.first;
    }

    examList = await currentList();
    print(examList);

    setState(() {
      examList.forEach((element) async {
        print(element.location);
        if(element.location.isNotEmpty)
        {
          _setMarker(LatLng(
              (await LocationService().getPlace(element.location))['geometry']['location']['lat'],
              (await LocationService().getPlace(element.location))['geometry']['location']['lng']),
              element.id,
              element.subject,
              element.location
          );
        }
      });
    });
  }

  TextEditingController _originController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(42.0041222,21.4073592),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    _addMarkersToSet();
    //_setMarker(LatLng(42.0041222,21.4073592), "Test", "Subject", "ФИНКИ");
    _polylines1.add(Polyline(
      polylineId: PolylineId("polylineIdVal"),
      width: 2,
      color: Colors.blue,
      points: points1,
    ),);
  }

  void _setMarker(LatLng point, String markerId, String subject, String location) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(markerId),
          position: point,
          infoWindow: InfoWindow (title: subject),
          onTap: () {
            _destinationController.text = location;
          },
        )
      );
    });
    print(_markers);
  }


  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  void _setPolyline(List<PointLatLng> points) {
    setState(() {
      final String polylineIdVal = 'polyline_$_polylineIdCounter';
      _polylineIdCounter++;

      _polylines.add(
        Polyline(
          polylineId: PolylineId(polylineIdVal),
          width: 5,
          color: Colors.blue,
          points: points.map(
                (point) => LatLng(point.latitude, point.longitude),
          ).toList(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Planner"),
        // actions: <Widget>[
        //   IconButton(
        //       onPressed: () async { Navigator.push( context, MaterialPageRoute(builder: (context) => Home()));},
        //       icon: Icon(Icons.home)
        //   ),
        // ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _originController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(hintText: " Start destination"),
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                    TextFormField(
                      controller: _destinationController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(hintText: " End destination"),
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                  ],
                ),
              ),
              IconButton(
                  onPressed: () async {
                    _polylines = Set<Polyline>();
                    var directions = await LocationService().getDirections(_originController.text, _destinationController.text);
                    _goToPlaceLatLng(
                        directions['start_location']['lat'],
                        directions['start_location']['lng'],
                        directions['bounds_ne'],
                        directions['bounds_sw']
                    );
                    print(directions['polyline_decoded']);
                    _setPolyline(directions['polyline_decoded']);
                  },
                  icon: Icon(Icons.directions)
              ),
            ],
          ),
          // Row(
          //   children: [
          //     Expanded(child: TextFormField(
          //       controller: _searchController,
          //       textCapitalization: TextCapitalization.words,
          //       decoration: InputDecoration(hintText: "Search places"),
          //       onChanged: (value) {
          //         print(value);
          //       },
          //     )),
          //   ],
          // ),
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              markers: _markers,
              polylines: _polylines,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: const Text('To the lake!'),
      //   icon: const Icon(Icons.directions_boat),
      // ),
    );
  }

  Future<void> _goToPlace(Map<String,dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat, lng),
      zoom: 12,
      ),
    ));
  }

  Future<void> _goToPlaceLatLng(double lat, double lng, Map<String, dynamic> boundsNe, Map<String, dynamic> boundsSw) async {

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat, lng), zoom: 12,),
    ));
    
    controller.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
            southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
            northeast: LatLng(boundsNe['lat'], boundsNe['lng'])),
        25),
    );
    

  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}