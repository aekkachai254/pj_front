import 'dart:convert';

import 'package:applicaiton/api_config.dart' as configURL;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Map.dart';
import 'TravelList.dart';

class TravelDetailScreen extends StatefulWidget {
  final String id;

  const TravelDetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  _TravelDetailScreenState createState() => _TravelDetailScreenState();
}

class _TravelDetailScreenState extends State<TravelDetailScreen> {
  late Future<Map<String, dynamic>> _tripDetailFuture;

  @override
  void initState() {
    super.initState();
    _tripDetailFuture = fetchTripDetail(widget.id);
  }

  Future<Map<String, dynamic>> fetchTripDetail(String tripId) async {
    final apiUrl = '${configURL.deployApiUrl}/trip_detail.php?id=$tripId';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Received data from API: $data');
      return data[0]; // Assuming your API returns a single trip detail object
    } else {
      throw Exception(
          'Failed to load trip detail. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TravelListScreen()),
            );
          },
        ),
        centerTitle: true,
        title: const Text(
          "รายละเอียดการเดินทาง",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _tripDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null) {
            return Center(child: Text('No data available'));
          } else {
            final tripDetail = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const SizedBox(height: 10),
                _buildHeader(),
                _buildDriverInfo(tripDetail['car']),
                _buildMapButton(),
                _buildTripDetails(tripDetail['trip_detail']),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Container(
          width: double.infinity,
          height: 40,
          color: const Color(0xff0A8ED9),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ข้อมูลพนักงาน",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.local_shipping,
                  color: Colors.white,
                  size: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDriverInfo(Map<String, dynamic> car) {
    if (car == null || car.isEmpty) {
      return Center(child: Text('No car data available'));
    }

    return _buildDriverCard(car);
  }

  Widget _buildDriverCard(Map<String, dynamic> car) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          width: double.infinity,
          height: 140,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            border: Border.all(
              color: const Color(0xFF0D99FF),
              width: 3,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(9),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildDriverImage(
                          "${configURL.apiUrl}/Avatar.jpg".toString()),
                      const SizedBox(width: 5),
                      _buildDriverDetails(car),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDriverImage(String? imageUrl) {
    if (imageUrl == null) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            ("${configURL.apiUrl}/Avatar.jpg"),
            height: 80,
            width: 80,
          ),
        ),
      ); // or any other widget you want to show when imageUrl is null
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          "${configURL.apiUrl}/Avatar.jpg",
          height: 80,
          width: 80,
        ),
      ),
    );
  }

  Widget _buildDriverDetails(Map<String, dynamic> car) {
    if (car == null) {
      return Container(); // or any other widget you want to show when car is null
    }

    return Expanded(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ทะเบียนรถ: ${car['license'] ?? 'N/A'}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            Text(
              "คนขับรถ: ${car['driver']['firstname'] ?? 'N/A'} ${car['driver']['surname'] ?? 'N/A'}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            Text(
              "หมายเลขโทรศัพท์: ${car['driver']['telephone'] ?? 'N/A'}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapButton() {
    return Padding(
        padding: const EdgeInsets.only(top: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 40,
              width: 120,
              decoration: const BoxDecoration(
                color: Color(0xFF0A8ED9),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MapScreen()),
                  );
                },
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map, color: Colors.white, size: 20),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "เส้นทาง",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Widget _buildTripDetails(List<dynamic> tripDetailsList) {
    if (tripDetailsList == null || tripDetailsList.isEmpty) {
      return Center(child: Text('No trip details available'));
    }

    return Column(
      children: tripDetailsList.map<Widget>((entry) {
        final shop = entry['shop'];
        if (shop == null) {
          return Container(); // or any other placeholder widget
        }
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            title: Text('Shop: ${shop['name'] ?? 'N/A'}'),
            subtitle: Text('Address: ${shop['address'] ?? 'N/A'}'),
            trailing: Text('Status: ${entry['status_check'] ?? 'N/A'}'),
          ),
        );
      }).toList(),
    );
  }
}
