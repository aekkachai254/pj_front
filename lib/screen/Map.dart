import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

const String google_api_key = "API_KEY";
const Color primaryColor = Color.fromARGB(255, 7, 11, 242);
const double defaultPadding = 16.0;

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const LatLng sourceLocation = LatLng(14.1377, 100.6170);
  static const LatLng destination = LatLng(14.2831, 100.5279);

  List<LatLng> polylineCoordinates = [
    //LatLng(14.1377, 100.6170), // source location
    LatLng(14.2831, 100.5279), // destination
  ];

  late GoogleMapController mapController;
  LocationData? currentLocation;

  void getCurrentLocation() async {
    Location location = Location();

    try {
      currentLocation = await location.getLocation();
      mapController.animateCamera(
        CameraUpdate.newLatLng(LatLng(
          currentLocation!.latitude!,
          currentLocation!.longitude!,
        )),
      );

      // Update polylineCoordinates to the current location
      updatePolylineCoordinates(LatLng(
        currentLocation!.latitude!,
        currentLocation!.longitude!,
      ));
    } catch (e) {
      print('Error getting location: $e');
    }

    location.onLocationChanged.listen((newLoc) {
      setState(() {
        currentLocation = newLoc;
        mapController.animateCamera(
          CameraUpdate.newLatLng(LatLng(
            currentLocation!.latitude!,
            currentLocation!.longitude!,
          )),
        );

        // Update polylineCoordinates to the new location
        updatePolylineCoordinates(LatLng(
          currentLocation!.latitude!,
          currentLocation!.longitude!,
        ));
      });
    });
  }

  void updatePolylineCoordinates(LatLng newLocation) {
    setState(() {
      // Add the new location to polylineCoordinates
      polylineCoordinates.add(newLocation);
    });
  }

  Future<void> _fetchPolylines() async {
    final String apiUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${sourceLocation.latitude},${sourceLocation.longitude}&destination=${destination.latitude},${destination.longitude}&key=$google_api_key';

    final http.Response response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data['status'] == 'OK') {
        final List<dynamic> routes = data['routes'];
        final Map<String, dynamic> route = routes[0];
        final Map<String, dynamic> overviewPolyline =
            route['overview_polyline'];
        final String points = overviewPolyline['points'];

        final List<LatLng> decodedPolyline =
            decodePolyline(points) as List<LatLng>;

        setState(() {
          polylineCoordinates = decodedPolyline;
        });
      } else {
        print('Error fetching polylines: ${data['status']}');
      }
    } else {
      print('Error fetching polylines. Status code: ${response.statusCode}');
    }
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      double latitude = lat / 1E5;
      double longitude = lng / 1E5;
      points.add(LatLng(latitude, longitude));
    }

    return points;
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    _fetchPolylines(); // เรียกใช้งานเพื่อดึงข้อมูลเส้นทาง
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, //Color(0xFF17203A),
      appBar: AppBar(
        backgroundColor: Colors.black, //Color(0xFF17203A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "เส้นทาง",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(target: sourceLocation, zoom: 12),
        markers: {
          Marker(
            markerId: MarkerId("source"),
            position: sourceLocation,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
          ),
          Marker(
            markerId: MarkerId("destination"),
            position: destination,
            icon: BitmapDescriptor.defaultMarker,
          ),
          if (currentLocation != null)
            Marker(
              markerId: MarkerId("currentLocation"),
              position: LatLng(
                currentLocation!.latitude!,
                currentLocation!.longitude!,
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueBlue,
              ),
            ),
        },
        polylines: {
          Polyline(
            polylineId: PolylineId("route"),
            color: primaryColor,
            width: 5,
            points: polylineCoordinates,
          ),
        },
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 16, right: 16),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue, // Set the background color to blue
        ),
        child: IconButton(
          icon: Icon(Icons.navigation),
          color: Colors.white,
          onPressed: () async {
            await launchUrl(Uri.parse(
                'google.navigation:q=${destination.latitude},${destination.longitude}&key=YOUR_API_KEY'));
          },
        ),
      ),
    );
  }
}
