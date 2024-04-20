import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

const String google_api_key = "YOUR_GOOGLE_MAPS_API_KEY";

const Color primaryColor = Color(0xFF7B61FF);
const double defaultPadding = 16.0;

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const LatLng sourceLocation = LatLng(14.13784, 100.61700);
  static const LatLng destination = LatLng(13.98894, 100.61756);

  List<LatLng> polylineCoordinates = [
    LatLng(14.13784, 100.61700), // source location
    LatLng(13.98894, 100.61756), // destination
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
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 18, 23, 27),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "เส้นทาง",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          mapController = controller;
        },
        initialCameraPosition:
            const CameraPosition(target: sourceLocation, zoom: 12),
        markers: {
          const Marker(
            markerId: MarkerId("source"),
            position: sourceLocation,
          ),
          const Marker(
            markerId: MarkerId("destination"),
            position: destination,
          ),
          if (currentLocation != null)
            Marker(
              markerId: const MarkerId("currentLocation"),
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
    );
  }
}
