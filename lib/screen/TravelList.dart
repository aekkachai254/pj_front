import 'dart:convert';

import 'package:applicaiton/screen/Home.dart';
import 'package:applicaiton/screen/TravelDetail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TravelListScreen extends StatefulWidget {
  const TravelListScreen({super.key});

  @override
  State<TravelListScreen> createState() => _TravelListScreenState();
}

class _TravelListScreenState extends State<TravelListScreen> {
  List<Map<String, dynamic>> trips = [];
  final List<String> travelTitles = [
    "กรุงเทพ --> เชียงใหม่",
    "กรุงเทพ --> ภูเก็ต",
    "กรุงเทพ --> ปัตตานี",
    "กรุงเทพ --> บุรีรัมย์",
    "กรุงเทพ --> นนทบุรี",
  ];
  final List<String> travelRegions = [
    "วันที่: 15 มกราคม 2567",
    "วันที่: 18 มกราคม 2567",
    "วันที่: 18 มกราคม 2567",
    "วันที่: 25 มกราคม 2567",
    "วันที่: 31 มกราคม 2567",
  ];
  //final List<String> time = [
  // "เวลา: 08.30 น.",
  // "เวลา: 06.30 น.",
  // "เวลา: 12.00 น.",
  // "เวลา: 08.30 น.",
  // "เวลา: 08.30 น.",
  //];

  Future<void> fetchData() async {
    final apiUrl = 'http://192.168.1.69/api/trip.php';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        print('Received data from API: $data');

        setState(() {
          trips = List<Map<String, dynamic>>.from(data['ms_trip']);
        });
      } else {
        print('Error: ${response.statusCode}');
        print('API Response Body: ${response.body}');
        // Handle errors - you can display a SnackBar or AlertDialog here
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: constraints.maxHeight,
            ),
            child: Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                backgroundColor: Colors.black,
                leading: BackButton(
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return HomeScreen();
                        },
                      ),
                    );
                  },
                ),
                title: const Text(
                  "รายการการเดินทาง",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                centerTitle: true,
              ),
              body: ListView.builder(
                itemCount: trips.length,
                itemBuilder: (context, index) {
                  final trip = trips[index];
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.all(20),
                    color: Color.fromRGBO(0, 14, 19, 26),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: Color(0xFF0D99FF),
                        width: 3,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 7,
                              top: 15,
                              bottom: 15,
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Image(
                                              image: AssetImage(
                                                "assets/images/arrow-point-to-down.png",
                                              ),
                                              color: Colors.white,
                                              width: 20,
                                              fit: BoxFit.contain,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              trip['name'].toString(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          'วันที่: ${trip['date'].toString()}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 13, bottom: 20),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0xff0A8ED9),
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          TravelDetailScreen()),
                                );
                              },
                              child: const Center(
                                child: Text(
                                  "รายละเอียด",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
