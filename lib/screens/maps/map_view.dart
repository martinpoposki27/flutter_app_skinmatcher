import 'dart:async';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lab193004/model/list_item.dart';
import 'package:lab193004/screens/home/home.dart';
import 'package:lab193004/services/location_service.dart';
import 'package:lab193004/widgets/loading.dart';
import '../../services/database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';




class MapSample extends StatefulWidget {
  const MapSample({Key? key, required this.productName, required this.location, required this.cameraPosition}) : super(key: key);
  final String productName;
  final String location;
  final String cameraPosition;

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {

  bool loading = false;

  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();
  String? _currentAddress;
  Position? _currentPosition;
  List<ListItem> productList = [];

  Set<Marker> _markers = Set<Marker>();
  Set<Marker> _markersProducts = Set<Marker>();
  Set<Polyline> _polylines = Set<Polyline>();
  Set<Polyline> _polylines1 = Set<Polyline>();
  List<LatLng> points1 = [LatLng(42.0041222,21.4073592), LatLng(41.0041222,22.4073592)];

  int _polylineIdCounter = 1;

  void _addMarkersToSet() async {

    final String userId = FirebaseAuth.instance.currentUser!.uid;

    Future<List<ListItem>> currentList () async  {
      return await DatabaseService(userId).users.first;
    }

    productList = await currentList();
    //print(productList);
    // setState(() {
    //   loading = true;
    // });
    setState(() {
      productList.forEach((element) async {
        //print(element.location);
        if(element.location.isNotEmpty)
        {
          _setMarker(LatLng(
              (await LocationService().getPlace(element.location))['geometry']['location']['lat'],
              (await LocationService().getPlace(element.location))['geometry']['location']['lng']),
              element.id,
              element.productName,
              element.location
          );
        }
      });
      //loading = false;
    });
  }

  TextEditingController _originController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();

  late String cameraLocation = widget.cameraPosition;

  Future<LatLng> getLatLng() async {
    LatLng latLngOfProduct = LatLng(
        (await LocationService().getPlace(cameraLocation))['geometry']['location']['lat'],
        (await LocationService().getPlace(cameraLocation))['geometry']['location']['lng']);
    if(latLngOfProduct.latitude.isNaN || latLngOfProduct.longitude.isNaN){
      return LatLng(
          (await LocationService().getPlace("Skopje"))['geometry']['location']['lat'],
          (await LocationService().getPlace("Skopje"))['geometry']['location']['lng']);
    } else {
      return latLngOfProduct;
    }

  }

  CameraPosition _productPosition = CameraPosition(
    target: LatLng(41.9979121,21.3923406),
    zoom: 10,
  );

  Future<void> setCameraOnProduct() async {
    // setState(() {
    //   loading = true;
    // });
    setState(() async {
      if (getLatLng() != null) {
        LatLng latLngOfProduct = await getLatLng();
        _setMarker(latLngOfProduct, "Product", widget.productName, widget.location);
        _productPosition = CameraPosition(
          target: latLngOfProduct,
          zoom: 14.4746,
        );
      } else {
        _productPosition = CameraPosition(
          target: LatLng(41.9990903,21.4248902),
          zoom: 14.4746,
        );
      }
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
          _productPosition
        ));
      // loading = false;
    });
    }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    setState(() {
      loading = true;
    });

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        loading = false;
      });
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    setState(() {
      loading = true;
    });
    await placemarkFromCoordinates(
        _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = '${place.street}, ${place.subLocality},${place.subAdministrativeArea}, ${place.postalCode}';
        loading = false;
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }


  // static const CameraPosition _productPosition = CameraPosition(
  //   target: LatLng(42.0041222,21.4073592),
  //   zoom: 14.4746,
  // );

  @override
  void initState() {
    super.initState();
    setCameraOnProduct();
    //_addMarkersToSet();

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
      //promena
      _markersProducts.add(
        Marker(
          markerId: MarkerId(markerId),
          position: point,
          infoWindow: InfoWindow (title: subject),
          onTap: () {
            setState(() {
              _getCurrentPosition();
              _destinationController.text = location;
              _originController.text = _currentAddress ?? "Type or get current location";
            });
          },
        )
      );
    });
  }

  void _setStartingMarker(LatLng point) {
    setState(() {
      _markersProducts.add(
          Marker(
            markerId: MarkerId("Starting position"),
            position: point,
            infoWindow: InfoWindow (title: "Starting position"),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          )
      );
    });
  }




  // static const CameraPosition _kLake = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(37.43296265331129, -122.08832357078792),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);

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
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        title: Text("SkinMatcher"),
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
                    Row(
                      children: [
                        IconButton(
                            onPressed: () async {
                              setState(() async {
                                _getCurrentPosition();
                                _originController.text = _currentAddress ?? "Loading... Press again.";
                                LatLng currentLatLng = LatLng(
                                    (await LocationService().getPlace(_originController.text))['geometry']['location']['lat'],
                                    (await LocationService().getPlace(_originController.text))['geometry']['location']['lng']);
                                _setStartingMarker(currentLatLng);
                                // _productPosition = CameraPosition(
                                //   target: currentLatLng,
                                //   zoom: 14.4746,
                                //);
                              });
                            },
                            icon: Icon(Icons.my_location, color: Colors.blue,)
                        ),
                        SizedBox(
                          width: 250,
                          child: TextFormField(
                            controller: _originController,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(hintText: " Start destination"),
                            onChanged: (value) {
                              print(value);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                    ),
                    SizedBox(
                      width: 250,
                      child: TextFormField(
                        controller: _destinationController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(hintText: " End destination"),
                        onChanged: (value) {
                          print(value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                  onPressed: () async {
                      _polylines = Set<Polyline>();
                      var directions = await LocationService().getDirections(
                          _originController.text, _destinationController.text);
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
              markers: _markersProducts,
              polylines: _polylines,
              initialCameraPosition: _productPosition,
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

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

}