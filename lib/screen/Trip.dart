import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../api_config.dart' as configURL;
import 'Home.dart';
import 'Intro.dart';
import 'TripDetail.dart';

class TripScreen extends StatefulWidget {
  final String username;

  const TripScreen({Key? key, required this.username, required String trip_id})
      : super(key: key);

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  List<Map<String, dynamic>> trips = [];
  bool _serverError = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final apiUrl =
          '${configURL.deployUrl}/trip.php?username=${widget.username}';
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          setState(() {
            trips = List<Map<String, dynamic>>.from(data);
          });
        } else {
          _showAlert('ไม่พบข้อมูลรายการเดินทาง');
        }
      } else {
        _showAlert('มีปัญหาในการเชื่อมต่อกับเซิร์ฟเวอร์');
      }
    } catch (e) {
      _showAlert('ขาดการเชื่อมต่อกับเซิร์ฟเวอร์');
    }
  }

  void _showAlert(String message) {
    if (!_serverError) {
      setState(() {
        _serverError = true;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('แจ้งเตือนระบบ'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // ปิด AlertDialog เดิม
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          IntroScreen(), // แก้เป็นหน้าที่ต้องการเปิด
                    ),
                  );
                },
                child: Text("เข้าใจแล้ว"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_serverError) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
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
        body: trips.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: trips.length,
                itemBuilder: (context, index) {
                  final trip = trips[index];
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                    color: const Color.fromRGBO(0, 14, 19, 26),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(
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
                              left: 10,
                              right: 10,
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
                                              image: NetworkImage(
                                                "${configURL.imageUrl}/pin_marker.png",
                                              ),
                                              width: 20,
                                              fit: BoxFit.contain,
                                            ),
                                            SizedBox(width: 10),
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
                                          'วันที่ ${trip['date'].toString()}',
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
                          padding: const EdgeInsets.only(
                              top: 20, left: 15, right: 15, bottom: 20),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
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
                                      builder: (context) => TripDetailScreen(
                                            trip_id: trip['id'],
                                            username: widget
                                                .username, // ส่งค่า username ไปยังหน้า TripDetailScreen
                                          )),
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
      );
    } else {
      return Scaffold(); // แสดง Scaffold ว่างๆ เมื่อเกิดข้อผิดพลาดจากเซิร์ฟเวอร์
    }
  }
}
