import 'dart:convert';

import 'package:applicaiton/screen/purchaseorder.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../api_config.dart' as configURL;
import 'Map.dart';
import 'Trip.dart'; // Import TripScreen

class TripDetailScreen extends StatefulWidget {
  final String username;
  final String trip_id;

  const TripDetailScreen(
      {Key? key, required this.username, required this.trip_id})
      : super(key: key);

  @override
  _TripDetailScreenState createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  late Future<Map<String, dynamic>> _tripDetailFuture;

  @override
  void initState() {
    super.initState();
    _tripDetailFuture = fetchTripDetail(widget.trip_id);
  }

  Future<Map<String, dynamic>> fetchTripDetail(String tripId) async {
    final apiUrl = '${configURL.deployUrl}/trip_detail.php?trip_id=$tripId';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Received data from API: $data');

      if (data is Map && data.containsKey('error')) {
        // Handle API error case
        throw Exception('API Error: ${data['error']}');
      } else if (data is List) {
        if (data.isNotEmpty) {
          return data[0]
              as Map<String, dynamic>; // Cast to Map<String, dynamic>
        } else {
          throw Exception('No data returned from API');
        }
      } else {
        throw Exception('Invalid data format returned from API');
      }
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
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TripScreen(
                  username: widget.username,
                  trip_id: widget.trip_id,
                ),
              ),
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
            return const Center(child: Text('No data available'));
          } else {
            final tripDetail = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const SizedBox(height: 10),
                _buildDriverHeader(),
                _buildDriverInfo(tripDetail['driver']),
                _buildCarHeader(),
                _buildCarInfo(tripDetail['car']),
                _buildMapButton(),
                _buildTripDetails(tripDetail['trip_detail']),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildDriverHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xff0A8ED9),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
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
                  Icons.person,
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

  Widget _buildDriverInfo(Map<String, dynamic>? driver) {
    if (driver == null || driver.isEmpty) {
      return const Center(child: Text('No driver data available'));
    }

    return _buildDriverCard(driver);
  }

  Widget _buildCarInfo(Map<String, dynamic>? car) {
    if (car == null || car.isEmpty) {
      return const Center(child: Text('No car data available'));
    }

    return _buildCarCard(car);
  }

  Widget _buildDriverCard(Map<String, dynamic> driver) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            color: Color(0xFF000000),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            border: Border.all(
              color: const Color(0xFF0D99FF),
              width: 3,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: _buildDriverImage(driver['picture']),
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(left: 2),
                child: Expanded(
                  child: _buildDriverDetails(driver),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDriverImage(String? picture) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: picture != null
            ? Image.network(
                picture,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              )
            : Icon(
                Icons.person,
                color: Colors.white,
                size: 80,
              ),
      ),
    );
  }

  Widget _buildDriverDetails(Map<String, dynamic> driver) {
    return Expanded(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "เลขประจำตัว : ${driver['id'] ?? 'N/A'}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            Text(
              "ชื่อ : ${driver['titlename'] ?? 'N/A'}${driver['firstname'] ?? 'N/A'}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            Text(
              "นามสกุล : ${driver['surname'] ?? 'N/A'}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            Text(
              "เบอร์โทรศัพท์ : ${driver['telephone'] ?? 'N/A'}",
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

  Widget _buildCarHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xff0A8ED9),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ข้อมูลรถยนต์",
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

  Widget _buildCarCard(Map<String, dynamic> car) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            color: Color(0xFF000000),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            border: Border.all(
              color: const Color(0xFF0D99FF),
              width: 3,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: _buildCarImage(car['picture']),
              ),
              //const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Expanded(
                  child: _buildCarDetails(car),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarImage(String? picture) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: picture != null
            ? Image.network(
                picture,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              )
            : Icon(
                Icons.car_repair_sharp,
                color: Colors.white,
                size: 80,
              ),
      ),
    );
  }

  Widget _buildCarDetails(Map<String, dynamic> car) {
    return Expanded(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ทะเบียน : ${car['license'] ?? 'N/A'}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            Text(
              "ยี่ห้อ : ${car['brand'] ?? 'N/A'}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            Text(
              "สี : ${car['color'] ?? 'N/A'}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            Text(
              "อายุการใช้งาน : ${car['service_life'] ?? 'N/A'} ปี",
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
      ),
    );
  }

  Widget _buildTripDetails(dynamic tripDetailData) {
    if (tripDetailData == null) {
      return const Center(child: Text('No trip details available'));
    }

    // Check if tripDetailData is a List of Maps
    if (tripDetailData is List) {
      List<Map<String, dynamic>> tripDetailsList =
          tripDetailData.cast<Map<String, dynamic>>().toList();

      if (tripDetailsList.isEmpty) {
        return const Center(child: Text('No trip details available'));
      }

      return Column(
        children: tripDetailsList.map<Widget>((entry) {
          final shop = entry['shop'];
          if (shop == null) {
            return Container(); // or any other placeholder widget
          }
          return Card(
            margin: const EdgeInsets.symmetric(
              vertical: 8.0,
            ),
            child: ListTile(
              title: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ร้านค้า : ${shop['name'] ?? 'N/A'}'),
                        Text('ที่อยู่ : ${shop['address'] ?? 'N/A'}'),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Text(
                                    'สถานะ : ${entry['status_check'] ?? 'N/A'}'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              onTap: () {
                // ทำงานที่ต้องการเมื่อคลิกที่รายการนี้
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PurchaseorderScreen(
                      username: widget
                          .username, // ใช้งาน widget.username ที่ได้รับจาก constructor
                      tripId: entry['trip'],
                      purchaseorderId: entry['purchaseorder'],
                    ),
                  ),
                );
              },
              tileColor: Color(0xFF000000),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xFF0A8ED9), width: 3),
              ),
            ),
          );
        }).toList(),
      );
    } else {
      // Handle other data types or invalid data format
      return const Center(child: Text('Invalid data format for trip details'));
    }
  }
}
