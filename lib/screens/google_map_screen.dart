import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:intl/intl.dart';
import 'package:mis_lab3/services/notification_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/exam.dart';

class GoogleMapScreen extends StatefulWidget {
  static const String id = "googleMapScreen";
  final List<Exam> _exams;
  GoogleMapScreen(this._exams);

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState(_exams);
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  final NotificationService service = NotificationService();
  Completer<GoogleMapController> _controller = Completer();
  final List<Marker> markers = <Marker>[];
  Map<PolylineId, Polyline> polylines = {};
  String googleAPI = 'AIzaSyBLaLwyg4v3BxL46qrKtHCHmT6FIJxZzkY';
  List<Exam> _exams;

  _GoogleMapScreenState(this._exams);

  @override
  void initState() {
    super.initState();
    _setMarkers(_exams);
    _setGeofence();
  }

  void _notification() async {
    await service.showNotification(
        id: 0,
        title: 'You have scheduled exams in this location!',
        body: 'Check your calendar');
  }

  void _setGeofence() {
    print("Setting geofence");
    final double fenceLat = 42.0043165;
    final double fenceLong = 21.4096452;
    final double fenceRadius = 300.0;

    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    //start listening to location updates
    StreamSubscription<Position> positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      (Position position) {
        //check if the device is witin the geofence
        double distance = Geolocator.distanceBetween(
            position.latitude, position.longitude, fenceLat, fenceLong);
        if (distance <= fenceRadius) {
          //trigger a notification
          print("Entered geofence");
          _notification();
        }
      },
    );
    // positionStream.cancel();
  }

  // set initial location
  static const CameraPosition _kGoogle = CameraPosition(
    target: LatLng(42.00189631487379, 21.40748422242309),
    zoom: 14.4746,
  );

  // method for getting user current location
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  //finding and drawing shortest route to selected location
  void _getShortestRoute(LatLng userLocationCoordinates,
      LatLng destinationLocationCoordinates) async {
    print("Getting shortest route for selected destination");

    // Print the coordinates to check if they are correct
    print("User Location Coordinates: $userLocationCoordinates");
    print("Destination Coordinates: $destinationLocationCoordinates");

    PolylinePoints polylinePoints = PolylinePoints();

    addPolyLine(List<LatLng> polylineCoordinates) {
      PolylineId id = PolylineId("poly");
      Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.deepOrange,
        points: polylineCoordinates,
        width: 8,
      );
      polylines[id] = polyline;
      setState(() {});
    }

    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPI,
      PointLatLng(
          userLocationCoordinates.latitude, userLocationCoordinates.longitude),
      PointLatLng(destinationLocationCoordinates.latitude,
          destinationLocationCoordinates.longitude),
      travelMode: TravelMode.driving,
    );

    // Print the response from the Directions API
    print("Directions API Response: $result");

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print("No route points found. Error message: ${result.errorMessage}");
    }
    addPolyLine(polylineCoordinates);
  }

  //set markers for all exams
  void _setMarkers(exams) {
    for (var i = 0; i < exams.length; i++) {
      markers.add(Marker(
          markerId: MarkerId(i.toString()),
          position: LatLng(exams[i].location.latitude,
              exams[i].location.longitude), //position of marker
          infoWindow: InfoWindow(
            //popup info
            title: exams[i].name,
            snippet: DateFormat("yyyy-MM-dd HH:mm:ss").format(exams[i].date),
          ),
          icon: BitmapDescriptor.defaultMarker, //Icon for Marker
          onTap: () {
            //on tap we get shortest route to the selected location
            getUserCurrentLocation().then((userLocation) async {
              LatLng destinationLocationCoordinates = LatLng(
                  exams[i].location.latitude, exams[i].location.longitude);
              LatLng userLocationCoordinates =
                  LatLng(userLocation.latitude, userLocation.longitude);
              _getShortestRoute(
                  userLocationCoordinates, destinationLocationCoordinates);
            });
          }));
    }
    print("Number of markers created: " + markers.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Map Page"),
      ),
      body: Container(
        child: SafeArea(
          child: GoogleMap(
            //adding marker for every exam location
            markers: Set<Marker>.of(markers),
            polylines: Set<Polyline>.of(polylines.values),
            initialCameraPosition: _kGoogle,
            mapType: MapType.normal,
            myLocationEnabled: true,
            compassEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ),
      ),
      // on pressing floating action button the camera will take to user current location
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async {
          getUserCurrentLocation().then((value) async {
            print(value.latitude.toString() + " " + value.longitude.toString());
            // specified current users location
            CameraPosition cameraPosition = CameraPosition(
              target: LatLng(value.latitude, value.longitude),
              zoom: 16,
            );

            final GoogleMapController controller = await _controller.future;
            controller
                .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
            setState(() {});
          });
        },
        child: Icon(
          Icons.map_sharp,
          color: Colors.pink,
        ),
      ),
    );
  }
}
